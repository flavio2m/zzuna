import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import 'package:zzuna/domain/dtos/conta/loaded_conta_dto.dart';
import 'package:zzuna/domain/entities/conta_entity.dart';

class ContaUpdateViewModel {
  final ContaRepository _repository;

  ContaUpdateViewModel(this._repository);

  late final updateCommand = Command1(_update);

  AsyncResult<Conta> _update(LoadedContaDto dto) {
    return _repository.update(dto);
  }
}
