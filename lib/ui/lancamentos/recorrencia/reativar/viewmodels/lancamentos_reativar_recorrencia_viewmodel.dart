import 'package:flutter/foundation.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/domain/usecases/lancamento/reativar_recorrencia_usecase.dart';
import 'package:result_command/result_command.dart';

class LancamentosReativarRecorrenciaViewModel extends ChangeNotifier {
  final ReativarRecorrenciaUseCase _reativarUseCase;

  LancamentosReativarRecorrenciaViewModel(this._reativarUseCase);

  late final reativarRecorrenciaCommand = Command1<Unit, String>(
    (lancamentoId) => _reativarUseCase.execute(lancamentoId),
  );
}
