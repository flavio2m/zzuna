import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/lancamento/extrato_fatura_repository.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_dto.dart';
import 'package:zzuna/domain/exceptions/domain_exception.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_item.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'recalculate_extrato_fatura_balance_usecase.dart';

class UpdateLancamentosItensGrupoUseCase {
  final RecalculateExtratoFaturaBalanceUseCase _recalculateUseCase;
  final LancamentoRepository _repository;
  final ExtratoFaturaRepository _extratoRepository;

  UpdateLancamentosItensGrupoUseCase(
    this._recalculateUseCase,
    this._repository,
    this._extratoRepository,
  );

  AsyncResult<Unit> execute({
    required String lancamentoId,
    required List<LancamentoItem> novosItens,
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
    if (grupoId == null) {
      return Failure(DomainException('Lançamento não pertence a um grupo.'));
    }

    // 2. Buscar companheiros do grupo
    final companionsRes = await _repository.getByGrupoId(grupoId);
    if (companionsRes.isError()) {
      return Failure(companionsRes.exceptionOrNull()!);
    }
    final allGroupLaunches = companionsRes.getOrThrow();

    // Filtrar desconsiderando lançamentos com data anterior à data do
    //lançamento de referência
    final targetLaunches = allGroupLaunches
        .where((l) => !l.data.isBefore(refLaunch.data))
        .toList();

    // 3. Validar se há algum lançamento conciliado ou de período fechado
    for (final l in targetLaunches) {
      if (l.conciliado) {
        return Failure(
          DomainException(
            'Não é possível alterar itens de lançamentos conciliados.',
          ),
        );
      }

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
      final oldExtrato = oldExtratoResult.getOrThrow();
      if (oldExtrato.fechado) {
        return Failure(
          DomainException(
            'Não é possível editar lançamentos de um período encerrado.',
          ),
        );
      }
    }

    // 4. Calcular valor total calculado dos novos itens
    final double novoValorTotal = novosItens.fold<double>(
      0.0,
      (sum, item) => sum + item.valor,
    );

    // Validar se o valor de cada item é maior que zero
    for (final item in novosItens) {
      if (item.valor <= 0) {
        return Failure(
          DomainException('O valor de cada item deve ser superior a zero.'),
        );
      }
    }

    // 5. Mapear para DTOs e atualizar
    final List<LancamentoDto> dtosToUpdate = [];
    for (final l in targetLaunches) {
      dtosToUpdate.add(
        LancamentoDto(
          id: l.id,
          tipo: l.tipo,
          data: l.data,
          descricao: l.descricao,
          extratoFaturaId: l.extratoFaturaId,
          origem: l.origem,
          itens: novosItens,
          conciliado: l.conciliado,
          anoMes: l.anoMes,
          grupo: l.grupo,
          observacao: l.observacao,
        ),
      );
    }

    // Salvar tudo em lote
    final updateRes = await _repository.updateAll(dtosToUpdate);
    if (updateRes.isError()) {
      return Failure(updateRes.exceptionOrNull()!);
    }

    // 6. Verificar se o valor foi alterado
    final double refOriginalValor = refLaunch.itens.fold<double>(
      0.0,
      (sum, item) => sum + item.valor,
    );

    final bool valorAlterado = refOriginalValor != novoValorTotal;

    if (valorAlterado) {
      // Recalcular saldos de todas as origens únicas afetadas
      final Set<LancamentoOrigem> origensAfetadas = targetLaunches
          .map((l) => l.origem)
          .toSet();
      for (final origem in origensAfetadas) {
        final lancamentosDaOrigem = targetLaunches.where(
          (l) => l.origem == origem,
        );
        final oldestDate = lancamentosDaOrigem
            .map((l) => l.data)
            .reduce((a, b) => a.isBefore(b) ? a : b);

        final recalcRes = await _recalculateUseCase.execute(
          origem,
          startingAno: oldestDate.year,
          startingMes: Mes.fromDate(oldestDate),
        );
        if (recalcRes.isError()) {
          return Failure(recalcRes.exceptionOrNull()!);
        }
      }
    }

    return const Success(unit);
  }
}
