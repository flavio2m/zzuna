import 'package:flutter/foundation.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/domain/usecases/lancamento/update_lancamentos_data_grupo_usecase.dart';

class LancamentosUpdateDataGrupoViewModel extends ChangeNotifier {
  final UpdateLancamentosDataGrupoUseCase _useCase;

  LancamentosUpdateDataGrupoViewModel(this._useCase);

  late final updateDataGrupoCommand =
      Command1<Unit, ({String lancamentoId, DateTime novaData})>(
        _updateDataGrupo,
      );

  AsyncResult<Unit> _updateDataGrupo(
    ({String lancamentoId, DateTime novaData}) params,
  ) async {
    return _useCase.execute(
      lancamentoId: params.lancamentoId,
      novaData: params.novaData,
    );
  }
}
