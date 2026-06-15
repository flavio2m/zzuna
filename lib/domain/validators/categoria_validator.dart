import 'package:lucid_validation/lucid_validation.dart';
import 'package:zzuna/domain/dtos/categoria/categoria_dto.dart';

class CategoriaValidator<T extends CategoriaDto> extends LucidValidator<T> {
  CategoriaValidator() {
    ruleFor((dto) => dto.descricao, key: 'descricao').notEmpty().minLength(2);
  }
}
