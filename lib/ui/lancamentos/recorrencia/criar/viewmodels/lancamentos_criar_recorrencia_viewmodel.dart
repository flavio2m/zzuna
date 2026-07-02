import 'package:flutter/foundation.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/domain/usecases/lancamento/criar_recorrencia_usecase.dart';
import 'package:result_command/result_command.dart';

class LancamentosCriarRecorrenciaViewModel extends ChangeNotifier {
  final CriarRecorrenciaUseCase _criarUseCase;

  LancamentosCriarRecorrenciaViewModel(this._criarUseCase);

  late final criarRecorrenciaCommand = Command1<Unit, String>(
    (lancamentoId) => _criarUseCase.execute(lancamentoId),
  );
}
