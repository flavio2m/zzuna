import 'package:result_dart/result_dart.dart';
import 'package:zzuna/domain/exceptions/domain_exception.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_dto.dart';

class ReconcileLancamentosUseCase {
  final LancamentoRepository _repository;

  ReconcileLancamentosUseCase(this._repository);

  AsyncResult<Unit> execute({required List<String> ids, required bool conciliado}) async {
    final List<LancamentoDto> dtosToUpdate = [];

    for (final id in ids) {
      final res = await _repository.getById(id);
      if (res.isError()) {
        return Failure(
          DomainException(
            'Lançamento com ID $id não encontrado.', //
          ),
        );
      }
      final lancamento = res.getOrThrow();

      if (lancamento.conciliado == conciliado) {
        continue;
      }

      dtosToUpdate.add(
        LancamentoDto(
          id: lancamento.id,
          tipo: lancamento.tipo,
          data: lancamento.data,
          descricao: lancamento.descricao,
          origem: lancamento.origem,
          extratoFaturaId: lancamento.extratoFaturaId,
          itens: lancamento.itens,
          conciliado: conciliado,
          grupo: lancamento.grupo,
          observacao: lancamento.observacao,
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
