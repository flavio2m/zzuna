import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/lancamento/extrato_fatura_repository.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/exceptions/domain_exception.dart';
import 'package:zzuna/domain/usecases/lancamento/recalculate_extrato_fatura_balance_usecase.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_grupo.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';

class DeleteLancamentoUseCase {
  final LancamentoRepository _lancamentoRepository;
  final ExtratoFaturaRepository _extratoRepository;
  final RecalculateExtratoFaturaBalanceUseCase _recalculateUseCase;

  DeleteLancamentoUseCase(
    this._lancamentoRepository,
    this._extratoRepository,
    this._recalculateUseCase,
  );

  /// [excluirTodos] — aplica apenas para grupos que não sejam Transferência
  /// (parcelamento, recorrência, replicação). Exclui o lançamento atual e os
  /// futuros do mesmo grupo. O passado (anoMes < anoMes atual) não é tocado.
  AsyncResult<Unit> execute(
    String lancamentoId, {
    bool excluirTodos = false,
  }) async {
    // Passo 1 – Buscar o lançamento original
    final originalResult = await _lancamentoRepository.getById(lancamentoId);
    if (originalResult.isError()) {
      return Failure(originalResult.exceptionOrNull()!);
    }
    final original = originalResult.getOrThrow();

    // Passo 2 – Barreira: período fechado
    final extratoResult = await _extratoRepository.getById(
      original.extratoFaturaId,
    );
    if (extratoResult.isError()) {
      return Failure(DomainException('Extrato do lançamento não encontrado.'));
    }
    final extrato = extratoResult.getOrThrow();
    if (extrato.fechado) {
      return Failure(
        DomainException(
          'Não é possível excluir lançamentos de um período encerrado.',
        ),
      );
    }

    // Passo 3 – Mapear quais lançamentos serão excluídos
    final List<Lancamento> paraExcluir = [];

    final grupo = original.grupo;
    final isTransferencia = grupo is LancamentoGrupoTransferencia;

    if (isTransferencia) {
      // Sempre excluir as duas pontas da transferência
      final grupoId = grupo.grupoId;
      final grupoResult = await _lancamentoRepository.getByGrupoId(grupoId);
      if (grupoResult.isError()) return Failure(grupoResult.exceptionOrNull()!);
      paraExcluir.addAll(grupoResult.getOrThrow());
    } else if (excluirTodos && grupo != null) {
      // Excluir o atual + futuros do mesmo grupo (anoMes >= anoMes do original)
      final grupoResult = await _lancamentoRepository.getByGrupoId(
        grupo.grupoId,
      );
      if (grupoResult.isError()) return Failure(grupoResult.exceptionOrNull()!);
      final todos = grupoResult.getOrThrow();
      paraExcluir.addAll(todos.where((l) => l.anoMes >= original.anoMes));
    } else {
      // Excluir apenas este lançamento
      paraExcluir.add(original);
    }

    // Passo 4 – Barreira em massa: nenhum dos lançamentos pode estar em período fechado
    for (final l in paraExcluir) {
      if (l.id == original.id) continue; // já validado acima
      final eRes = await _extratoRepository.getById(l.extratoFaturaId);
      if (eRes.isError()) continue;
      if (eRes.getOrThrow().fechado) {
        return Failure(
          DomainException(
            'Um ou mais lançamentos do grupo estão em período encerrado.',
          ),
        );
      }
    }

    // Passo 5 – Coletar origens e anoMes mínimo antes de deletar
    // (Mapa: origem → menor anoMes encontrado naquele origem)
    final Map<LancamentoOrigem, int> origemAnoMes = {};
    for (final l in paraExcluir) {
      final current = origemAnoMes[l.origem];
      if (current == null || l.anoMes < current) {
        origemAnoMes[l.origem] = l.anoMes;
      }
    }

    // Passo 6 – Deletar
    final ids = paraExcluir.map((l) => l.id).toList();
    final deleteResult = await _lancamentoRepository.deleteAll(ids);
    if (deleteResult.isError()) return Failure(deleteResult.exceptionOrNull()!);

    // Passo 7 – Recalcular saldo para cada origem afetada
    for (final entry in origemAnoMes.entries) {
      final origem = entry.key;
      final anoMes = entry.value;
      final startingAno = anoMes ~/ 100;
      final startingMes = Mes.values.firstWhere(
        (m) => m.numero == (anoMes % 100),
      );
      final recalcResult = await _recalculateUseCase.execute(
        origem,
        startingAno: startingAno,
        startingMes: startingMes,
      );
      if (recalcResult.isError()) {
        return Failure(recalcResult.exceptionOrNull()!);
      }
    }

    return const Success(unit);
  }
}
