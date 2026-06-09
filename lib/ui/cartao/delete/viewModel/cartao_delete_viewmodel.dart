import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';

class CartaoDeleteViewModel {
  final CartaoRepository _repository;

  CartaoDeleteViewModel(this._repository);

  late final deleteCommand = Command1(_delete);

  AsyncResult<Unit> _delete(String id) async {
    return _repository.delete(id);
  }
}
