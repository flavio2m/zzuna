import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/domain/dtos/categoria/categoria_dto.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/domain/usecases/categoria/categoria_save_usecase.dart';

class CategoriaUpdateViewModel {
  final CategoriaSaveUseCase _saveUseCase;

  CategoriaUpdateViewModel(this._saveUseCase);

  late final updateCommand = Command1(_update);

  AsyncResult<Categoria> _update(CategoriaDto dto) async {
    return _saveUseCase.update(dto);
  }
}
