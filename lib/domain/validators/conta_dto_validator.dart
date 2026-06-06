import 'package:lucid_validation/lucid_validation.dart';
import 'package:zzuna/domain/dtos/conta_dto.dart';

class ContaDtoValidator extends LucidValidator<ContaDto> {
  ContaDtoValidator() {
    ruleFor((dto) => dto.descricao, key: 'descricao').notEmpty().minLength(2);

    ruleFor((dto) => dto.bancoSigla, key: 'bancoSigla').notEmpty();
  }
}
