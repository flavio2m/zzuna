import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/lancamento/extrato_fatura_repository.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/resolve_extrato_fatura_dto.dart';
import 'package:zzuna/domain/exceptions/domain_exception.dart';
import 'package:zzuna/domain/usecases/lancamento/resolve_extrato_fatura_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/recalculate_extrato_fatura_balance_usecase.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';
import 'package:zzuna/domain/enums/mes.dart';

class UpdateLancamentosOrigemGrupoUseCase {
  final ResolveExtratoFaturaUseCase _resolveUseCase;
  final RecalculateExtratoFaturaBalanceUseCase _recalculateUseCase;
  final LancamentoRepository _repository;
  final ExtratoFaturaRepository _extratoRepository;

  UpdateLancamentosOrigemGrupoUseCase(
    this._resolveUseCase,
    this._recalculateUseCase,
    this._repository,
    this._extratoRepository,
  );

  AsyncResult<Unit> execute({
    required String lancamentoId,
    required LancamentoOrigem novaOrigem,
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
    // lançamento de referência
    final targetLaunches = allGroupLaunches
        .where((l) => !l.data.isBefore(refLaunch.data))
        .toList();

    // 3. Validar se há algum lançamento conciliado ou de período fechado
    for (final l in targetLaunches) {
      if (l.conciliado) {
        return Failure(
          DomainException(
            'Não é possível alterar a origem de lançamentos conciliados.',
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

    // 4. Mapear para DTOs resolvendo o extrato da nova origem
    final List<LancamentoDto> dtosToUpdate = [];
    for (final l in targetLaunches) {
      final double lValorTotal = l.itens.fold<double>(
        0.0,
        (sum, item) => sum + item.valor,
      );

      final resolveDto = ResolveExtratoFaturaDto(
        origem: novaOrigem,
        data: l.data,
        valor: lValorTotal,
        tipo: l.tipo,
      );

      final extratoRes = await _resolveUseCase.execute(resolveDto);
      if (extratoRes.isError()) {
        return Failure(extratoRes.exceptionOrNull()!);
      }
      final newExtrato = extratoRes.getOrThrow();

      dtosToUpdate.add(
        LancamentoDto(
          id: l.id,
          tipo: l.tipo,
          data: l.data,
          descricao: l.descricao,
          extratoFaturaId: newExtrato.id,
          origem: novaOrigem,
          itens: l.itens,
          conciliado: l.conciliado,
          grupo: l.grupo,
          observacao: l.observacao,
        ),
      );
    }

    // Salvar todas as atualizações
    final updateRes = await _repository.updateAll(dtosToUpdate);
    if (updateRes.isError()) {
      return Failure(updateRes.exceptionOrNull()!);
    }

    // 5. Recalcular saldos de todas as origens únicas antigas + nova origem
    final Set<LancamentoOrigem> origensParaRecalcular = targetLaunches
        .map((l) => l.origem)
        .toSet();
    origensParaRecalcular.add(novaOrigem);

    for (final origem in origensParaRecalcular) {
      final lancamentosDaOrigem = targetLaunches.where(
        (l) => l.origem == origem,
      );
      final dtosDaOrigem = dtosToUpdate.where((d) => d.origem == origem);

      DateTime? oldestDate;
      if (lancamentosDaOrigem.isNotEmpty) {
        oldestDate = lancamentosDaOrigem
            .map((l) => l.data)
            .reduce((a, b) => a.isBefore(b) ? a : b);
      }
      if (dtosDaOrigem.isNotEmpty) {
        final oldestNewDate = dtosDaOrigem
            .map((d) => d.data)
            .reduce((a, b) => a.isBefore(b) ? a : b);
        if (oldestDate == null || oldestNewDate.isBefore(oldestDate)) {
          oldestDate = oldestNewDate;
        }
      }

      if (oldestDate != null) {
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
