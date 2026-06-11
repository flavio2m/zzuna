import 'package:lucid_validation/lucid_validation.dart';
import 'package:zzuna/domain/dtos/cartao/cartao_dto.dart';

class CartaoValidator<T extends CartaoDto> extends LucidValidator<T> {
  CartaoValidator() {
    ruleFor((dto) => dto.descricao, key: 'descricao').notEmpty().minLength(2);

    ruleFor((dto) => dto.bancoSigla, key: 'bancoSigla').notEmpty();

    ruleFor((dto) => dto.limite, key: 'limite').min(
      100,
      message: 'Informe um limite maior que 100', //
    );

    ruleFor(
      (dto) => dto.diaFechamento,
      key: 'diaFechamento',
    ).min(1, message: 'Dia mínimo é 1').max(31, message: 'Dia máximo é 31');
  }
}
