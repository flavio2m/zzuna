import 'package:flutter/foundation.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/domain/usecases/lancamento/atualizar_data_recorrencia_usecase.dart';

class LancamentosAtualizarDataRecorrenciaViewModel extends ChangeNotifier {
  final AtualizarDataRecorrenciaUseCase _atualizarDataUseCase;

  LancamentosAtualizarDataRecorrenciaViewModel(this._atualizarDataUseCase);

  late final atualizarDataRecorrenciaCommand = Command1<Unit, String>(
    (lancamentoId) => _atualizarDataUseCase.execute(lancamentoId),
  );
}
