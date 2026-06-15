import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/categoria/categoria_repository.dart';
import 'package:zzuna/domain/dtos/categoria/categoria_dto.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';

class CategoriaUpdateViewModel {
  final CategoriaRepository _repository;

  CategoriaUpdateViewModel(this._repository);

  late final updateCommand = Command1(_update);

  AsyncResult<Categoria> _update(CategoriaDto dto) async {
    return _repository.update(dto);
  }
}
