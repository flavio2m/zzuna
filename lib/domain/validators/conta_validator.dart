import 'package:lucid_validation/lucid_validation.dart';
import 'package:zzuna/domain/dtos/conta/conta_dto.dart';

class ContaValidator<T extends ContaDto> extends LucidValidator<T> {
  ContaValidator() {
    ruleFor((dto) => dto.descricao, key: 'descricao').notEmpty().minLength(2);

    ruleFor((dto) => dto.bancoSigla, key: 'bancoSigla').notEmpty();
  }
}
