import 'package:flutter_test/flutter_test.dart';
import 'package:zzuna/domain/dtos/categoria/categoria_dto.dart';
import 'package:zzuna/domain/enums/categoria_natureza.dart';
import 'package:zzuna/domain/validators/categoria_validator.dart';

void main() {
  group('CategoriaValidator', () {
    late CategoriaValidator validator;

    setUp(() {
      validator = CategoriaValidator();
    });

    test('validates valid CategoriaDto with percentual and natureza', () {
      final dto = CategoriaDto(
        descricao: 'Custos Fixos',
        percentualOrcamento: 30,
        natureza: CategoriaNatureza.saida,
      );

      final result = validator.validate(dto);
      expect(result.isValid, isTrue);
    });

    test('validates valid CategoriaDto with null percentual (ex: Terceiros)', () {
      final dto = CategoriaDto(
        descricao: 'Terceiros',
        percentualOrcamento: null,
        natureza: CategoriaNatureza.saida,
      );

      final result = validator.validate(dto);
      expect(result.isValid, isTrue);
    });

    test('fails validation when percentual is negative', () {
      final dto = CategoriaDto(
        descricao: 'Investimentos',
        percentualOrcamento: -5,
      );

      final result = validator.validate(dto);
      expect(result.isValid, isFalse);
      expect(result.exceptions.any((e) => e.key == 'percentualOrcamento'), isTrue);
    });

    test('fails validation when percentual is greater than 100', () {
      final dto = CategoriaDto(
        descricao: 'Investimentos',
        percentualOrcamento: 105,
      );

      final result = validator.validate(dto);
      expect(result.isValid, isFalse);
      expect(result.exceptions.any((e) => e.key == 'percentualOrcamento'), isTrue);
    });

    test('serializes and deserializes CategoriaDto with percentual and natureza', () {
      final dto = CategoriaDto(
        id: 'cat-123',
        descricao: 'Receitas',
        percentualOrcamento: null,
        natureza: CategoriaNatureza.entrada,
      );

      final json = dto.toJson();
      expect(json['natureza'], equals('entrada'));
      expect(json['percentualOrcamento'], isNull);

      final fromJson = CategoriaDto.fromJson(json);
      expect(fromJson.id, equals('cat-123'));
      expect(fromJson.descricao, equals('Receitas'));
      expect(fromJson.natureza, equals(CategoriaNatureza.entrada));
      expect(fromJson.percentualOrcamento, isNull);
    });
  });
}
