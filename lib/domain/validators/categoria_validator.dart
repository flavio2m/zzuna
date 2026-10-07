import 'package:lucid_validation/lucid_validation.dart';
import 'package:zzuna/domain/dtos/categoria/categoria_dto.dart';

class CategoriaValidator<T extends CategoriaDto> extends LucidValidator<T> {
  CategoriaValidator() {
    ruleFor((dto) => dto.descricao, key: 'descricao').notEmpty().minLength(2);
    ruleFor((dto) => dto.percentualOrcamento, key: 'percentualOrcamento').must(
      (val) => val == null || (val >= 0 && val <= 100),
      'O percentual deve estar entre 0 e 100%',
      'percentualInvalido',
    );
  }
}
