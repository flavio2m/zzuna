import 'package:flutter/foundation.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/domain/usecases/lancamento/finalizar_recorrencia_usecase.dart';
import 'package:result_command/result_command.dart';

class LancamentosFinalizarRecorrenciaViewModel extends ChangeNotifier {
  final FinalizarRecorrenciaUseCase _finalizarUseCase;

  LancamentosFinalizarRecorrenciaViewModel(this._finalizarUseCase);

  late final finalizarRecorrenciaCommand = Command1<Unit, String>(
    (lancamentoId) => _finalizarUseCase.execute(lancamentoId),
  );
}
