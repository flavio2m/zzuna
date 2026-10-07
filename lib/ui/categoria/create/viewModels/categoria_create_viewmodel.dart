import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/domain/dtos/categoria/categoria_dto.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/domain/usecases/categoria/categoria_save_usecase.dart';

class CategoriaCreateViewModel {
  final CategoriaSaveUseCase _saveUseCase;

  CategoriaCreateViewModel(this._saveUseCase);

  late final createCommand = Command1(_create);

  AsyncResult<Categoria> _create(CategoriaDto dto) async {
    return _saveUseCase.create(dto);
  }
}
