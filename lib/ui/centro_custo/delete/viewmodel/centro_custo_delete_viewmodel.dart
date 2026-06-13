// lib/ui/centro_custo/delete/viewmodel/centro_custo_delete_viewmodel.dart
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/centro_custo/centro_custo_repository.dart';

class CentroCustoDeleteViewModel {
  final CentroCustoRepository _repository;

  CentroCustoDeleteViewModel(this._repository);

  late final deleteCommand = Command1(_delete);

  AsyncResult<Unit> _delete(String id) async => _repository.delete(id);
}
