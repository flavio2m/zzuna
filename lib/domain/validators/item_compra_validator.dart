import 'package:lucid_validation/lucid_validation.dart';
import 'package:zzuna/domain/dtos/lista_compras/item_compra_dto.dart';

class ItemCompraValidator<T extends ItemCompraDto> extends LucidValidator<T> {
  ItemCompraValidator() {
    ruleFor((dto) => dto.produto, key: 'produto')
        .notEmpty(message: 'O nome do produto é obrigatório.')
        .minLength(2, message: 'O nome deve ter no mínimo 2 caracteres.');

    ruleFor((dto) => dto.quantidadePlanejada, key: 'quantidadePlanejada')
        .greaterThan(0, message: 'A quantidade deve ser maior que zero.');
  }
}
