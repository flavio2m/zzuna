import 'package:brasil_fields/brasil_fields.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';
import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import 'package:zzuna/data/repositories/lancamento/extrato_fatura_repository.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/resolve_extrato_fatura_dto.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/exceptions/domain_exception.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';
import 'recalculate_extrato_fatura_balance_usecase.dart';
import 'resolve_extrato_fatura_usecase.dart';

class UpdateLancamentosDataGrupoUseCase {
  final ResolveExtratoFaturaUseCase _resolveUseCase;
  final RecalculateExtratoFaturaBalanceUseCase _recalculateUseCase;
  final LancamentoRepository _repository;
  final ExtratoFaturaRepository _extratoRepository;
  final ContaRepository _contaRepository;
  final CartaoRepository _cartaoRepository;

  UpdateLancamentosDataGrupoUseCase(
    this._resolveUseCase,
    this._recalculateUseCase,
    this._repository,
    this._extratoRepository,
    this._contaRepository,
    this._cartaoRepository,
  );

  int _getMonthDifference(DateTime d1, DateTime d2) {
    return (d1.year - d2.year) * 12 + d1.month - d2.month;
  }

  DateTime _addMonthsAndClampDay(DateTime baseDate, int monthsToAdd) {
    int targetYear = baseDate.year;
    int targetMonth = baseDate.month + monthsToAdd;

    final firstOfDay = DateTime(targetYear, targetMonth, 1);
    final actualYear = firstOfDay.year;
    final actualMonth = firstOfDay.month;

    final lastDayOfMonth = DateTime(actualYear, actualMonth + 1, 0).day;

    int actualDay = baseDate.day;
    if (actualDay > lastDayOfMonth) {
      actualDay = lastDayOfMonth;
    }

    return DateTime(
      actualYear,
      actualMonth,
      actualDay,
      baseDate.hour,
      baseDate.minute,
      baseDate.second,
    );
  }

  AsyncResult<Unit> execute({
    required String lancamentoId,
    required DateTime novaData,
  }) async {
    // 1. Buscar lançamento de referência
    final refRes = await _repository.getById(lancamentoId);
    if (refRes.isError()) {
      return Failure(
        DomainException('Lançamento com ID $lancamentoId não encontrado.'),
      );
    }
    final refLaunch = refRes.getOrThrow();

    final grupoId = refLaunch.grupo?.grupoId;
    List<Lancamento> targetLaunches = [refLaunch];

    if (grupoId != null) {
      // Buscar companheiros do grupo
      final companionsRes = await _repository.getByGrupoId(grupoId);
      if (companionsRes.isError()) {
        return Failure(companionsRes.exceptionOrNull()!);
      }
      final allGroupLaunches = companionsRes.getOrThrow();

      // Filtrar desconsiderando lançamentos com data anterior à data do
      // lançamento de referência
      targetLaunches = allGroupLaunches
          .where((l) => !l.data.isBefore(refLaunch.data))
          .toList();
    }

    // 2. Validar se o período original de cada lançamento está aberto
    for (final l in targetLaunches) {
      final oldExtratoResult = await _extratoRepository.getById(
        l.extratoFaturaId,
      );
      if (oldExtratoResult.isError()) {
        return Failure(
          DomainException(
            'Extrato original do lançamento ${l.id} não encontrado.',
          ),
        );
      }
      final oldExtrato = oldExtratoResult.getOrNull()!;
      if (oldExtrato.fechado) {
        return Failure(
          DomainException(
            'Não é possível editar lançamentos de um período encerrado.',
          ),
        );
      }
    }

    // 3. Resolver novas datas, validar limites e períodos fechados de destino
    final List<LancamentoDto> dtosToUpdate = [];
    final limit = DateTime.now().add(const Duration(days: 730));

    for (final l in targetLaunches) {
      final int monthsDiff = _getMonthDifference(l.data, refLaunch.data);
      final DateTime targetNewDate = _addMonthsAndClampDay(
        novaData,
        monthsDiff,
      );

      // Validar limite de 24 meses
      if (targetNewDate.isAfter(limit)) {
        return Failure(
          DomainException(
            'Data não pode ser superior a 24 meses da data atual',
          ),
        );
      }

      // Validar dataInicial da conta/cartão
      final DateTime dataInicial;
      final String nomeOrigem;
      final origem = l.origem;

      if (origem is LancamentoOrigemConta) {
        final contaRes = await _contaRepository.getById(origem.contaId);
        if (contaRes.isError()) {
          return Failure(
            DomainException('Conta não encontrada: ${origem.contaId}'),
          );
        }
        final conta = contaRes.getOrThrow();
        dataInicial = conta.dataInicial;
        nomeOrigem = conta.descricao;
      } else if (origem is LancamentoOrigemCartao) {
        final cartaoRes = await _cartaoRepository.getById(origem.cartaoId);
        if (cartaoRes.isError()) {
          return Failure(
            DomainException('Cartão não encontrado: ${origem.cartaoId}'),
          );
        }
        final cartao = cartaoRes.getOrThrow();
        dataInicial = cartao.dataInicial;
        nomeOrigem = cartao.descricao;
      } else {
        return Failure(DomainException('Origem de lançamento desconhecida'));
      }

      final dataInicialCompare = DateTime(
        dataInicial.year,
        dataInicial.month,
        1,
      );
      final targetMonth = DateTime(targetNewDate.year, targetNewDate.month, 1);
      if (targetMonth.isBefore(dataInicialCompare)) {
        final dateStr = UtilData.obterDataDDMMAAAA(targetNewDate);
        final dataInicialStr = UtilData.obterDataDDMMAAAA(dataInicial);
        return Failure(
          DomainException(
            'A data do lançamento "${l.descricao}" ($dateStr) não pode ser '
            'anterior à data inicial ($dataInicialStr) do(a) "$nomeOrigem".',
          ),
        );
      }

      // Validar se o extrato de destino está fechado
      final mes = Mes.values.firstWhere((m) => m.numero == targetNewDate.month);
      final targetExtratosRes = await _extratoRepository.searchByPeriodo(
        origem,
        targetNewDate.year,
        mes,
      );
      if (targetExtratosRes.isError()) {
        return Failure(DomainException('Erro ao buscar extrato de destino.'));
      }
      final targetExtratos = targetExtratosRes.getOrThrow();
      if (targetExtratos.isNotEmpty && targetExtratos.first.fechado) {
        return Failure(
          DomainException(
            'Não é possível registrar lançamentos em um período encerrado.',
          ),
        );
      }

      // Resolver o extrato correspondente
      final resolveDto = ResolveExtratoFaturaDto(
        origem: l.origem,
        data: targetNewDate,
        valor: l.itens.fold<double>(0.0, (sum, item) => sum + item.valor),
        tipo: l.tipo,
      );
      final extratoRes = await _resolveUseCase.execute(resolveDto);
      if (extratoRes.isError()) {
        return Failure(extratoRes.exceptionOrNull()!);
      }
      final targetExtrato = extratoRes.getOrThrow();

      dtosToUpdate.add(
        LancamentoDto(
          id: l.id,
          tipo: l.tipo,
          data: targetNewDate,
          descricao: l.descricao,
          extratoFaturaId: targetExtrato.id,
          origem: l.origem,
          itens: l.itens,
          conciliado: l.conciliado,
          anoMes: targetExtrato.periodo,
          grupo: l.grupo,
          observacao: l.observacao,
        ),
      );
    }

    // 4. Salvar tudo em lote
    final updateRes = await _repository.updateAll(dtosToUpdate);
    if (updateRes.isError()) {
      return Failure(updateRes.exceptionOrNull()!);
    }

    // 5. Recalcular saldos de todas as origens únicas afetadas
    final Set<LancamentoOrigem> origensAfetadas = targetLaunches
        .map((l) => l.origem)
        .toSet();
    for (final origem in origensAfetadas) {
      final lancamentosDaOrigem = targetLaunches.where(
        (l) => l.origem == origem,
      );
      final dtosDaOrigem = dtosToUpdate.where((d) => d.origem == origem);

      final oldestOldDate = lancamentosDaOrigem
          .map((l) => l.data)
          .reduce((a, b) => a.isBefore(b) ? a : b);
      final oldestNewDate = dtosDaOrigem
          .map((d) => d.data)
          .reduce((a, b) => a.isBefore(b) ? a : b);

      final oldestDate = oldestOldDate.isBefore(oldestNewDate)
          ? oldestOldDate
          : oldestNewDate;

      final recalcRes = await _recalculateUseCase.execute(
        origem,
        startingAno: oldestDate.year,
        startingMes: Mes.fromDate(oldestDate),
      );
      if (recalcRes.isError()) {
        return Failure(recalcRes.exceptionOrNull()!);
      }
    }

    return const Success(unit);
  }
}
