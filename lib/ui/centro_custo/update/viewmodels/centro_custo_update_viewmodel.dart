import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/centro_custo/centro_custo_repository.dart';
import 'package:zzuna/domain/dtos/centro_custo/centro_custo_dto.dart';
import 'package:zzuna/domain/entities/centro_custo_entity.dart';

class CentroCustoUpdateViewModel {
  final CentroCustoRepository _repository;

  CentroCustoUpdateViewModel(this._repository);

  late final updateCommand = Command1(_update);

  AsyncResult<CentroCusto> _update(CentroCustoDto dto) async {
    return _repository.update(dto);
  }
}
