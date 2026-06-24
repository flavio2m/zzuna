import 'package:flutter_test/flutter_test.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_dto.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_item_entity.dart';
import 'package:zzuna/domain/validators/lancamento_validator.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';

void main() {
  late LancamentoValidator validator;

  LancamentoItem buildItem({
    String id = 'item-1',
    String categoriaId = 'cat-1',
    String centroCustoId = 'cc-1',
    double valor = 100.0,
  }) {
    return LancamentoItem(
      id: id,
      categoriaId: categoriaId,
      centroCustoId: centroCustoId,
      valor: valor,
    );
  }

  LancamentoDto buildDto({
    String descricao = 'Supermercado',
    DateTime? data,
    LancamentoOrigem? origem,
    List<LancamentoItem>? itens,
  }) {
    return LancamentoDto(
      tipo: LancamentoTipo.despesa,
      descricao: descricao,
      data: data ?? DateTime.now(),
      origem: origem ?? const LancamentoOrigem.conta(contaId: 'conta-1'),
      itens: itens ?? [buildItem()],
    );
  }

  setUp(() {
    validator = LancamentoValidator();
  });

  group('LancamentoValidator – descricao', () {
    test('descrição vazia → inválido', () {
      final dto = buildDto(descricao: '');
      final result = validator.validate(dto);
      expect(result.isValid, isFalse);
      expect(result.exceptions.any((e) => e.key == 'descricao'), isTrue);
    });

    test('descrição com 2 chars → inválido (minLength 3)', () {
      final dto = buildDto(descricao: 'AB');
      final result = validator.validate(dto);
      expect(result.isValid, isFalse);
      expect(result.exceptions.any((e) => e.key == 'descricao'), isTrue);
    });

    test('descrição com 3 chars → válido para este campo', () {
      final dto = buildDto(descricao: 'ABC');
      final result = validator.validate(dto);
      expect(result.exceptions.any((e) => e.key == 'descricao'), isFalse);
    });
  });

  group('LancamentoValidator – data', () {
    test('data superior a 24 meses → inválido', () {
      final dto = buildDto(data: DateTime.now().add(const Duration(days: 731)));
      final result = validator.validate(dto);
      expect(result.isValid, isFalse);
      expect(result.exceptions.any((e) => e.key == 'data'), isTrue);
    });

    test('data atual → válido', () {
      final dto = buildDto(data: DateTime.now());
      final result = validator.validate(dto);
      expect(result.exceptions.any((e) => e.key == 'data'), isFalse);
    });
  });

  group('LancamentoValidator – origem', () {
    test('contaId vazio → inválido', () {
      final dto = buildDto(origem: const LancamentoOrigem.conta(contaId: ''));
      final result = validator.validate(dto);
      expect(result.isValid, isFalse);
      expect(result.exceptions.any((e) => e.key == 'origem'), isTrue);
    });

    test('cartaoId vazio → inválido', () {
      final dto = buildDto(origem: const LancamentoOrigem.cartao(cartaoId: ''));
      final result = validator.validate(dto);
      expect(result.isValid, isFalse);
      expect(result.exceptions.any((e) => e.key == 'origem'), isTrue);
    });

    test('contaId preenchido → válido para este campo', () {
      final dto = buildDto(origem: const LancamentoOrigem.conta(contaId: 'conta-1'));
      final result = validator.validate(dto);
      expect(result.exceptions.any((e) => e.key == 'origem'), isFalse);
    });
  });

  group('LancamentoValidator – itens', () {
    test('sem itens → inválido', () {
      final dto = buildDto(itens: []);
      final result = validator.validate(dto);
      expect(result.isValid, isFalse);
      expect(result.exceptions.any((e) => e.key == 'itens'), isTrue);
    });

    test('item sem categoriaId → inválido', () {
      final dto = buildDto(itens: [buildItem(categoriaId: '')]);
      final result = validator.validate(dto);
      expect(result.isValid, isFalse);
      expect(result.exceptions.any((e) => e.key == 'itensCategorias'), isTrue);
    });

    test('item sem centroCustoId → inválido', () {
      final dto = buildDto(itens: [buildItem(centroCustoId: '')]);
      final result = validator.validate(dto);
      expect(result.isValid, isFalse);
      expect(result.exceptions.any((e) => e.key == 'itensCentrosCusto'), isTrue);
    });

    test('item com valor 0 → inválido', () {
      final dto = buildDto(itens: [buildItem(valor: 0)]);
      final result = validator.validate(dto);
      expect(result.isValid, isFalse);
      expect(result.exceptions.any((e) => e.key == 'itensValores'), isTrue);
    });

    test('item com valor negativo → inválido', () {
      final dto = buildDto(itens: [buildItem(valor: -50)]);
      final result = validator.validate(dto);
      expect(result.isValid, isFalse);
      expect(result.exceptions.any((e) => e.key == 'itensValores'), isTrue);
    });
  });

  group('LancamentoValidator – dto completo', () {
    test('DTO válido com todos os campos preenchidos → válido', () {
      final dto = buildDto();
      final result = validator.validate(dto);
      expect(result.isValid, isTrue);
    });
  });
}
