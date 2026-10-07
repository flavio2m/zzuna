import 'package:result_command/result_command.dart';
import 'package:result_dart/result_dart.dart';
import 'package:zzuna/data/repositories/auth/auth_repository.dart';
import 'package:zzuna/domain/dtos/user/loaded_user_dto.dart';
import 'package:zzuna/domain/entities/user_entity.dart';

class DefinirOrcamentoViewModel {
  final AuthRepository _authRepository;

  DefinirOrcamentoViewModel(this._authRepository);

  late final updateOrcamentoCommand = Command1(_updateOrcamento);

  AsyncResult<LoggedUser> _updateOrcamento(
    ({User user, double orcamento}) params,
  ) async {
    final dto = LoadedUserDto(
      id: params.user.currentId ?? '',
      name: params.user.currentName ?? '',
      email: params.user.currentEmail ?? '',
      orcamento: params.orcamento,
    );
    return _authRepository.updateUser(dto);
  }
}
