import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';
import 'package:zzuna/domain/dtos/cartao/cartao_dto.dart';
import 'package:zzuna/domain/entities/cartao_entity.dart';

class CartaoUpdateViewModel {
  final CartaoRepository _repository;

  CartaoUpdateViewModel(this._repository);

  late final updateCommand = Command1(_update);

  AsyncResult<Cartao> _update(CartaoDto dto) async {
    return _repository.update(dto);
  }
}
