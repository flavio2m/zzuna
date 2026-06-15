import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/categoria/categoria_repository.dart';

class CategoriaDeleteViewModel {
  final CategoriaRepository _repository;

  CategoriaDeleteViewModel(this._repository);

  late final deleteCommand = Command1(_delete);

  AsyncResult<Unit> _delete(String id) async {
    return _repository.delete(id);
  }
}
