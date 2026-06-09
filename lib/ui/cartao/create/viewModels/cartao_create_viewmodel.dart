import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';
import 'package:zzuna/domain/dtos/cartao/cartao_dto.dart';
import 'package:zzuna/domain/entities/cartao_entity.dart';

class CartaoCreateViewModel {
  final CartaoRepository _repository;

  CartaoCreateViewModel(this._repository);

  late final createCommand = Command1(_create);

  AsyncResult<Cartao> _create(CartaoDto dto) async {
    return _repository.create(dto);
  }
}
