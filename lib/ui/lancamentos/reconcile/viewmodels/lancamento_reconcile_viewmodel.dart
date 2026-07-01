import 'package:flutter/foundation.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/domain/usecases/lancamento/reconcile_lancamentos_usecase.dart';

class LancamentoReconcileViewModel extends ChangeNotifier {
  final ReconcileLancamentosUseCase _useCase;

  LancamentoReconcileViewModel(this._useCase);

  late final reconcileCommand = Command1<Unit, ({List<String> ids, bool conciliado})>(_reconcile);

  AsyncResult<Unit> _reconcile(
    ({List<String> ids, bool conciliado}) params, //
  ) async {
    return _useCase.execute(ids: params.ids, conciliado: params.conciliado);
  }
}
