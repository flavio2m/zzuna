import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/conta/conta_repository.dart';

class ContaDeleteViewModel {
  final ContaRepository _repository;

  ContaDeleteViewModel(this._repository);

  late final deleteCommand = Command1(_delete);

  AsyncResult<Unit> _delete(String id) {
    return _repository.delete(id);
  }
}
