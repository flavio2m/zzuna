import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/usecases/lancamento/atualizar_sequencia_recorrencia_usecase.dart';

class LancamentosAtualizarSequenciaRecorrenciaViewModel {
  final AtualizarSequenciaRecorrenciaUseCase _atualizarSequenciaUseCase;

  late final Command1<Unit, ({String lancamentoId, int novaSequencia})>
  updateCommand;

  LancamentosAtualizarSequenciaRecorrenciaViewModel(
    this._atualizarSequenciaUseCase,
  ) {
    updateCommand = Command1(_update);
  }

  AsyncResult<Unit> _update(({String lancamentoId, int novaSequencia}) args) {
    return _atualizarSequenciaUseCase.execute(
      args.lancamentoId,
      args.novaSequencia,
    );
  }
}

final lancamentosAtualizarSequenciaRecorrenciaViewModelProvider =
    Provider.autoDispose<LancamentosAtualizarSequenciaRecorrenciaViewModel>((
      ref,
    ) {
      return LancamentosAtualizarSequenciaRecorrenciaViewModel(
        ref.read(atualizarSequenciaRecorrenciaUseCaseProvider),
      );
    });
