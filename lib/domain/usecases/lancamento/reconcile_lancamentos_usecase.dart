import 'package:result_dart/result_dart.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/exceptions/domain_exception.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_dto.dart';

class ReconcileLancamentosUseCase {
  final LancamentoRepository _repository;

  ReconcileLancamentosUseCase(this._repository);

  AsyncResult<Unit> execute({required List<String> ids, required bool conciliado}) async {
    final Map<String, Lancamento> uniqueLancamentos = {};

    for (final id in ids) {
      final res = await _repository.getById(id);
      if (res.isError()) {
        return Failure(
          DomainException(
            'Lançamento com ID $id não encontrado.',
          ),
        );
      }
      final l = res.getOrThrow();
      uniqueLancamentos[l.id] = l;
    }

    final List<Lancamento> initialLancamentos = uniqueLancamentos.values.toList();
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

    final List<LancamentoDto> dtosToUpdate = [];
    for (final l in uniqueLancamentos.values) {
      if (l.conciliado == conciliado) {
        continue;
      }

      dtosToUpdate.add(
        LancamentoDto(
          id: l.id,
          tipo: l.tipo,
          data: l.data,
          descricao: l.descricao,
          origem: l.origem,
          extratoFaturaId: l.extratoFaturaId,
          itens: l.itens,
          conciliado: conciliado,
          anoMes: l.anoMes,
          grupo: l.grupo,
          observacao: l.observacao,
        ),
      );
    }

    if (dtosToUpdate.isEmpty) {
      return const Success(unit);
    }

    final updateResult = await _repository.updateAll(dtosToUpdate);
    if (updateResult.isError()) {
      return Failure(updateResult.exceptionOrNull()!);
    }

    return const Success(unit);
  }
}
