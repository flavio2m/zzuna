import 'package:flutter/foundation.dart';
import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/domain/dtos/lancamento/update_lancamentos_metadata_dto.dart';
import 'package:zzuna/domain/usecases/lancamento/update_lancamentos_metadata_usecase.dart';

class LancamentoUpdateMetadataViewModel extends ChangeNotifier {
  final UpdateLancamentosMetadataUseCase _useCase;

  LancamentoUpdateMetadataViewModel(this._useCase);

  late final updateMetadataCommand =
      Command1<Unit, UpdateLancamentosMetadataDto>(_updateMetadata);

  AsyncResult<Unit> _updateMetadata(UpdateLancamentosMetadataDto dto) async {
    return _useCase.execute(dto);
  }
}
