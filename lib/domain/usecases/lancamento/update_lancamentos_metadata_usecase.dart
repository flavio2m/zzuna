import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/update_lancamentos_metadata_dto.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/exceptions/domain_exception.dart';

class UpdateLancamentosMetadataUseCase {
  final LancamentoRepository _repository;

  UpdateLancamentosMetadataUseCase(this._repository);

  AsyncResult<Unit> execute(UpdateLancamentosMetadataDto dto) async {
    if (dto.ids.isEmpty) {
      return const Success(unit);
    }

    final List<Lancamento> lancamentos = [];
    for (final id in dto.ids) {
      final res = await _repository.getById(id);
      if (res.isError()) {
        return Failure(
          DomainException('Lançamento com ID $id não encontrado.'),
        );
      }
      lancamentos.add(res.getOrNull()!);
    }

    final updatedDtos = lancamentos.map((l) {
      final lancamentoDto = LancamentoDto.fromEntity(l);
      if (dto.descricao != null) {
        lancamentoDto.descricao = dto.descricao!;
      }
      if (dto.observacao != null) {
        lancamentoDto.observacao = dto.observacao!;
      }
      return lancamentoDto;
    }).toList();

    return _repository.updateAll(updatedDtos);
  }
}
