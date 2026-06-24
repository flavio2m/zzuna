import 'package:result_dart/result_dart.dart';
import 'package:uuid/uuid.dart';
import 'package:zzuna/domain/exceptions/domain_exception.dart';
import 'package:zzuna/domain/dtos/lancamento/resolve_extrato_fatura_lote_dto.dart';
import 'package:zzuna/domain/entities/lancamento/extrato_fatura_entity.dart';
import 'package:zzuna/domain/dtos/lancamento/extrato_fatura_dto.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/enums/lancamento_tipo.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';
import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';
import 'package:zzuna/data/repositories/lancamento/extrato_fatura_repository.dart';

class ResolveExtratoFaturasUseCase {
  final ExtratoFaturaRepository _extratoRepository;
  final ContaRepository _contaRepository;
  final CartaoRepository _cartaoRepository;

  ResolveExtratoFaturasUseCase(
    this._extratoRepository,
    this._contaRepository,
    this._cartaoRepository, //
  );

  AsyncResult<List<ExtratoFatura>> execute(ResolveExtratoFaturaLoteDto dto) async {
    try {
      // 1. Agrupar impactos por Origem + Período
      final Map<LancamentoOrigem, Map<int, double>> deltasByOrigem = {};
      final Map<LancamentoOrigem, Set<int>> periodosByOrigem = {};

      for (final item in dto.itens) {
        final origem = item.origem;
        final periodo = item.data.year * 100 + item.data.month;
        final delta = _calculateDelta(item.tipo, item.valor);

        deltasByOrigem.putIfAbsent(origem, () => {});
        deltasByOrigem[origem]![periodo] = //
            (deltasByOrigem[origem]![periodo] ?? 0.0) + delta;

        periodosByOrigem.putIfAbsent(origem, () => {});
        periodosByOrigem[origem]!.add(periodo);
      }

      final List<ExtratoFatura> allResolvedExtratos = [];
      final Map<LancamentoOrigem, DateTime> dataInicialCache = {};

      // Acumuladores globais para gravação única ao final
      final allNewExtratos = <ExtratoFaturaDto>[];
      final allUpdatedExtratos = <ExtratoFaturaDto>[];

      // 2. Processar cada origem separadamente
      for (final origem in deltasByOrigem.keys) {
        final deltas = deltasByOrigem[origem]!;
        final periodos = periodosByOrigem[origem]!.toList()..sort();

        // Buscar a data inicial da origem para validação
        final dataInicial =
            dataInicialCache[origem] //
            ??= await _getDataInicial(
              origem,
            );

        final pMin = periodos.first;

        // Buscar extratos no banco
        final targetRes = await _extratoRepository.searchByPeriodo(
          origem,
          pMin ~/ 100,
          Mes.fromNumero(pMin % 100), //
        );
        if (targetRes.isError()) {
          return Failure(
            DomainException(
              'Erro ao buscar extrato do período inicial: '
              '${targetRes.exceptionOrNull()}', //
            ),
          );
        }
        final p1StatementList = targetRes.getOrThrow();

        final afterRes = await _extratoRepository.searchAfter(
          origem,
          pMin ~/ 100,
          Mes.fromNumero(pMin % 100), //
        );
        if (afterRes.isError()) {
          return Failure(
            DomainException(
              'Erro ao buscar extratos futuros: ${afterRes.exceptionOrNull()}', //
            ),
          );
        }
        final searchAfterList = afterRes.getOrThrow();

        final prevRes = await _extratoRepository.searchPrevious(
          origem,
          pMin ~/ 100,
          Mes.fromNumero(pMin % 100), //
        );
        if (prevRes.isError()) {
          return Failure(
            DomainException(
              'Erro ao buscar extrato anterior: ${prevRes.exceptionOrNull()}', //
            ),
          );
        }
        final prevList = prevRes.getOrThrow();

        // Encontrar pMax
        var pMax = periodos.last;
        for (final fe in searchAfterList) {
          if (fe.periodo > pMax) {
            pMax = fe.periodo;
          }
        }

        // Gerar a linha do tempo contínua
        final timeline = _generateTimeline(pMin, pMax);

        // Map temporário para gerenciar os extratos da origem em memória
        final Map<int, ExtratoFatura> inMemoryExtratos = {};
        final Set<String> newExtratoIds = {};

        if (p1StatementList.isNotEmpty) {
          inMemoryExtratos[pMin] = p1StatementList.first;
        }
        for (final fe in searchAfterList) {
          inMemoryExtratos[fe.periodo] = fe;
        }

        // 3. Criar os períodos inexistentes na linha do tempo em memória e validar fechados
        for (int i = 0; i < timeline.length; i++) {
          final currentPeriod = timeline[i];
          final year = currentPeriod ~/ 100;
          final monthVal = currentPeriod % 100;

          final targetMonth = DateTime(year, monthVal, 1);
          if (targetMonth.isBefore(dataInicial)) {
            return Failure(
              DomainException(
                'Data do lançamento não pode ser anterior à data inicial do '
                'cartão/conta', //
              ),
            );
          }

          if (inMemoryExtratos.containsKey(currentPeriod)) {
            // Se já existe e estiver fechado, falhar o processo antes da persistência
            if (inMemoryExtratos[currentPeriod]!.fechado) {
              return Failure(
                DomainException(
                  'Não é possível registrar lançamentos em um período encerrado.', //
                ),
              );
            }
            continue;
          }

          // Período não existe no banco, criar em memória
          double saldoInicial = 0.0;
          if (i == 0) {
            if (prevList.isNotEmpty) {
              saldoInicial = prevList.first.saldoFinal;
            }
          } else {
            final prevPeriod = timeline[i - 1];
            saldoInicial = inMemoryExtratos[prevPeriod]!.saldoFinal;
          }

          final mes = Mes.fromNumero(monthVal);
          final newId = const Uuid().v4();
          newExtratoIds.add(newId);

          inMemoryExtratos[currentPeriod] = ExtratoFatura(
            id: newId,
            origem: origem,
            ano: year,
            mes: mes,
            dataInicio: DateTime(year, monthVal, 1),
            dataFim: DateTime(year, monthVal + 1, 0, 23, 59, 59, 999),
            saldoInicial: saldoInicial,
            saldoFinal: saldoInicial,
            fechado: false,
            periodo: currentPeriod,
            origemKey: _getOrigemKey(origem),
          );
        }

        // 4. Armazenar a movimentação de cada período na linha do tempo
        final Map<int, double> movimentacoes = {};
        for (final currentPeriod in timeline) {
          final extrato = inMemoryExtratos[currentPeriod]!;
          movimentacoes[currentPeriod] = extrato.saldoFinal - extrato.saldoInicial;
        }

        // 5. Aplicar os novos deltas às movimentações
        for (final currentPeriod in deltas.keys) {
          movimentacoes[currentPeriod] = (movimentacoes[currentPeriod] ?? 0.0) + deltas[currentPeriod]!;
        }

        // 6. Recalcular a linha do tempo cronologicamente
        for (int i = 0; i < timeline.length; i++) {
          final currentPeriod = timeline[i];
          var extrato = inMemoryExtratos[currentPeriod]!;

          if (i > 0) {
            final prevPeriod = timeline[i - 1];
            final prevExtrato = inMemoryExtratos[prevPeriod]!;
            extrato = extrato.copyWith(saldoInicial: prevExtrato.saldoFinal);
          }

          final mov = movimentacoes[currentPeriod] ?? 0.0;
          extrato = extrato.copyWith(saldoFinal: extrato.saldoInicial + mov);

          inMemoryExtratos[currentPeriod] = extrato;
        }

        // 7. Separar novos e modificados para persistência acumulada
        final allOrigemResolved = inMemoryExtratos.values.toList();
        final newExtratos = allOrigemResolved.where((e) => newExtratoIds.contains(e.id)).map(_toDto).toList();
        final updatedExtratos = allOrigemResolved.where((e) => !newExtratoIds.contains(e.id)).map(_toDto).toList();

        allNewExtratos.addAll(newExtratos);
        allUpdatedExtratos.addAll(updatedExtratos);

        allResolvedExtratos.addAll(allOrigemResolved);
      }

      // 8. PERSISTÊNCIA ÚNICA AO FINAL
      if (allNewExtratos.isNotEmpty) {
        final createRes = await _extratoRepository.createAll(allNewExtratos);
        if (createRes.isError()) {
          return Failure(DomainException('Falha ao salvar novos extratos em lote: ${createRes.exceptionOrNull()}'));
        }
      }

      if (allUpdatedExtratos.isNotEmpty) {
        final updateRes = await _extratoRepository.updateAll(allUpdatedExtratos);
        if (updateRes.isError()) {
          return Failure(DomainException('Falha ao atualizar extratos em lote: ${updateRes.exceptionOrNull()}'));
        }
      }

      return Success(allResolvedExtratos);
    } catch (e, s) {
      return Failure(DomainException('Erro durante resolução de extratos em lote: $e', s));
    }
  }

  List<int> _generateTimeline(int minPeriodo, int maxPeriodo) {
    final timeline = <int>[];
    var current = minPeriodo;
    while (current <= maxPeriodo) {
      timeline.add(current);

      var year = current ~/ 100;
      var month = current % 100;
      month += 1;
      if (month > 12) {
        year += 1;
        month = 1;
      }
      current = year * 100 + month;
    }
    return timeline;
  }

  Future<DateTime> _getDataInicial(LancamentoOrigem origem) async {
    DateTime dataInicial;
    if (origem is LancamentoOrigemConta) {
      final contaRes = await _contaRepository.getById(origem.contaId);
      if (contaRes.isError()) {
        throw Exception('Conta não encontrada: ${origem.contaId}');
      }
      dataInicial = contaRes.getOrThrow().dataInicial;
    } else if (origem is LancamentoOrigemCartao) {
      final cartaoRes = await _cartaoRepository.getById(origem.cartaoId);
      if (cartaoRes.isError()) {
        throw Exception('Cartão não encontrado: ${origem.cartaoId}');
      }
      dataInicial = cartaoRes.getOrThrow().dataInicial;
    } else {
      throw Exception('Origem de lançamento desconhecida');
    }
    return DateTime(dataInicial.year, dataInicial.month, 1);
  }

  double _calculateDelta(LancamentoTipo tipo, double valor) {
    if (tipo == LancamentoTipo.receita) {
      return valor;
    }
    return -valor;
  }

  String _getOrigemKey(LancamentoOrigem origem) {
    return origem.map(conta: (c) => 'conta_${c.contaId}', cartao: (c) => 'cartao_${c.cartaoId}');
  }

  ExtratoFaturaDto _toDto(ExtratoFatura entity) {
    return ExtratoFaturaDto(
      id: entity.id,
      origem: entity.origem,
      ano: entity.ano,
      mes: entity.mes,
      dataInicio: entity.dataInicio,
      dataFim: entity.dataFim,
      saldoInicial: entity.saldoInicial,
      saldoFinal: entity.saldoFinal,
      fechado: entity.fechado,
    );
  }
}
