import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import 'package:zzuna/domain/dtos/conta/create_conta_dto.dart';
import 'package:zzuna/domain/entities/conta_entity.dart';

class ContaCreateViewModel {
  final ContaRepository _repository;

  ContaCreateViewModel(this._repository);

  late final createCommand = Command1(_create);

  AsyncResult<Conta> _create(CreateContaDto dto) {
    return _repository.create(dto);
  }
}
