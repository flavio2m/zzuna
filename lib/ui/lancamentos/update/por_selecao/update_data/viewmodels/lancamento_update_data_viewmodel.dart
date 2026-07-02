import 'package:flutter/foundation.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/domain/usecases/lancamento/update_lancamentos_data_usecase.dart';

class LancamentoUpdateDataViewModel extends ChangeNotifier {
  final UpdateLancamentosDataUseCase _useCase;

  LancamentoUpdateDataViewModel(this._useCase);

  late final updateDataCommand =
      Command1<Unit, ({List<String> ids, DateTime novaData})>(_updateData);

  AsyncResult<Unit> _updateData(
    ({List<String> ids, DateTime novaData}) params,
  ) async {
    return _useCase.execute(ids: params.ids, novaData: params.novaData);
  }
}
