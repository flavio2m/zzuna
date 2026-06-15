import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/categoria/categoria_repository.dart';
import 'package:zzuna/domain/dtos/categoria/categoria_dto.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';

class CategoriaCreateViewModel {
  final CategoriaRepository _repository;

  CategoriaCreateViewModel(this._repository);

  late final createCommand = Command1(_create);

  AsyncResult<Categoria> _create(CategoriaDto dto) async {
    return _repository.create(dto);
  }
}
