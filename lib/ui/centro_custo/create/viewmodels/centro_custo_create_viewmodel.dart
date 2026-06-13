import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/centro_custo/centro_custo_repository.dart';
import 'package:zzuna/domain/dtos/centro_custo/centro_custo_dto.dart';
import 'package:zzuna/domain/entities/centro_custo_entity.dart';

class CentroCustoCreateViewModel {
  final CentroCustoRepository _repository;

  CentroCustoCreateViewModel(this._repository);

  late final createCommand = Command1(_create);

  AsyncResult<CentroCusto> _create(CentroCustoDto dto) async {
    return _repository.create(dto);
  }
}
