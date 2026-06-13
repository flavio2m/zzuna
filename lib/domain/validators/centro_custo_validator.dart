import 'package:lucid_validation/lucid_validation.dart';
import 'package:zzuna/domain/dtos/centro_custo/centro_custo_dto.dart';

class CentroCustoValidator<T extends CentroCustoDto> extends LucidValidator<T> {
  CentroCustoValidator() {
    ruleFor((dto) => dto.descricao, key: 'descricao') //
        .notEmpty(message: 'Descrição obrigatória')
        .minLength(2, message: 'Descrição deve ter ao menos 2 caracteres');
  }
}
