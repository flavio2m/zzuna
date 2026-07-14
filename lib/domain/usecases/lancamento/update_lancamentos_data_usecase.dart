import 'package:brasil_fields/brasil_fields.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';
import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import '../../../data/repositories/lancamento/extrato_fatura_repository.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/resolve_extrato_fatura_dto.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/exceptions/domain_exception.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';
import 'recalculate_extrato_fatura_balance_usecase.dart';
import 'resolve_extrato_fatura_usecase.dart';

class UpdateLancamentosDataUseCase {
  final ResolveExtratoFaturaUseCase _resolveUseCase;
  final RecalculateExtratoFaturaBalanceUseCase _recalculateUseCase;
  final LancamentoRepository _repository;
  final ExtratoFaturaRepository _extratoRepository;
  final ContaRepository _contaRepository;
  final CartaoRepository _cartaoRepository;

  UpdateLancamentosDataUseCase(
    this._resolveUseCase,
    this._recalculateUseCase,
    this._repository,
    this._extratoRepository,
    this._contaRepository,
    this._cartaoRepository,
  );

  AsyncResult<Unit> execute({
    required List<String> ids,
    required DateTime novaData,
  }) async {
    if (ids.isEmpty) {
      return const Success(unit);
    }

    // 1. Carregar todos os lançamentos originais e seus companheiros de transferência
    final Map<String, Lancamento> uniqueLancamentos = {};
    for (final id in ids) {
      final res = await _repository.getById(id);
      if (res.isError()) {
        return Failure(
          DomainException('Lançamento com ID $id não encontrado.'),
        );
      }
      final l = res.getOrThrow();
      uniqueLancamentos[l.id] = l;
    }

    final List<Lancamento> initialLancamentos =
        uniqueLancamentos //
            .values
            .toList();
    for (final l in initialLancamentos) {
      if (l.tipo == LancamentoTipo.transferencia && l.grupo?.grupoId != null) {
        final grupoId = l.grupo!.grupoId;
        final companionsRes = await _repository.getByGrupoId(grupoId);
        if (companionsRes.isSuccess()) {
          for (final comp in companionsRes.getOrThrow()) {
            uniqueLancamentos[comp.id] = comp;
          }
        }
      }
    }

    final List<Lancamento> lancamentos = uniqueLancamentos.values.toList();

    // 2. Validar se o período original de cada lançamento está aberto
    for (final l in lancamentos) {
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

    // 3. Validar limite da nova data (não superior a 24 meses do dia atual)
    final limit = DateTime.now().add(const Duration(days: 730));
    if (novaData.isAfter(limit)) {
      return Failure(
        DomainException('Data não pode ser superior a 24 meses da data atual'),
      );
    }

    // 4. Validar se a data destino é anterior à data inicial da conta/cartão
    // e se o extrato destino está aberto
    final targetMonth = DateTime(novaData.year, novaData.month, 1);
    final mes = Mes.values.firstWhere((m) => m.numero == novaData.month);

    for (final l in lancamentos) {
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
      if (targetMonth.isBefore(dataInicialCompare)) {
        final dateStr = UtilData.obterDataDDMMAAAA(novaData);
        final dataInicialStr = UtilData.obterDataDDMMAAAA(dataInicial);
        return Failure(
          DomainException(
            'A data do lançamento "${l.descricao}" ($dateStr) não pode ser '
            'anterior à data inicial ($dataInicialStr) do(a) "$nomeOrigem".',
          ),
        );
      }

      final targetExtratosRes = await _extratoRepository.searchByPeriodo(
        origem,
        novaData.year,
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
    }

    // 5. Resolver os novos extratos e mapear para DTOs
    final List<LancamentoDto> dtosToUpdate = [];
    for (final l in lancamentos) {
      final resolveDto = ResolveExtratoFaturaDto(
        origem: l.origem,
        data: novaData,
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
          data: novaData,
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

    // 6. Atualizar os lançamentos no repositório em lote
    final updateRes = await _repository.updateAll(dtosToUpdate);
    if (updateRes.isError()) {
      return Failure(updateRes.exceptionOrNull()!);
    }

    // 7. Recalcular os saldos de todas as origens únicas afetadas
    final Set<LancamentoOrigem> origensAfetadas = lancamentos
        .map((l) => l.origem)
        .toSet();
    for (final origem in origensAfetadas) {
      final lancamentosDaOrigem = lancamentos.where((l) => l.origem == origem);
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
