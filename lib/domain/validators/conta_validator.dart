import 'package:lucid_validation/lucid_validation.dart';

abstract interface class ContaDto {
  String get descricao;
  String get bancoSigla;
}

class ContaValidator<T extends ContaDto> extends LucidValidator<T> {
  ContaValidator() {
    ruleFor((dto) => dto.descricao, key: 'descricao').notEmpty().minLength(2);

    ruleFor((dto) => dto.bancoSigla, key: 'bancoSigla').notEmpty();
  }
}
