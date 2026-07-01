import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zzuna/data/repositories/lancamento/extrato_fatura_repository.dart';
import 'package:zzuna/domain/dtos/lancamento/extrato_fatura_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/extrato_fatura_filter_dto.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';
import 'package:zzuna/domain/enums/mes.dart';

import 'package:zzuna/data/services/storage/local/local_storage.dart';
import 'package:zzuna/domain/entities/lancamento/extrato_fatura_entity.dart';
import '../../../helpers/test_storage.dart';

void main() {
  late ExtratoFaturaRepository repository;
  late LocalStorage<ExtratoFatura> storage;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    storage = createTestExtratoFaturaStorage();
    repository = ExtratoFaturaRepository(storage);
  });

  tearDown(() {
    repository.dispose();
  });

  group('ExtratoFaturaRepository', () {
    test('create saves an extrato_fatura successfully', () async {
      final dto = ExtratoFaturaDto(
        origem: const LancamentoOrigem.conta(contaId: 'conta-1'),
        ano: 2026,
        mes: Mes.junho,
        dataInicio: DateTime(2026, 6, 1),
        dataFim: DateTime(2026, 6, 30),
        saldoInicial: 100.0,
        saldoFinal: 200.0,
        fechado: false,
      );

      final result = await repository.create(dto);
      final list = await storage.getAll();

      expect(result.isSuccess(), isTrue);
      expect(list.getOrThrow(), hasLength(1));
      expect(list.getOrThrow().first.saldoInicial, 100.0);
    });

    test('update changes an existing extrato_fatura', () async {
      final created = await repository.create(
        ExtratoFaturaDto(
          origem: const LancamentoOrigem.conta(contaId: 'conta-1'),
          ano: 2026,
          mes: Mes.junho,
          dataInicio: DateTime(2026, 6, 1),
          dataFim: DateTime(2026, 6, 30),
          saldoInicial: 100.0,
          saldoFinal: 200.0,
          fechado: false,
        ),
      );

      final model = created.getOrThrow();

      final result = await repository.update(
        ExtratoFaturaDto(
          id: model.id,
          origem: model.origem,
          ano: model.ano,
          mes: model.mes,
          dataInicio: model.dataInicio,
          dataFim: model.dataFim,
          saldoInicial: 150.0,
          saldoFinal: 300.0,
          fechado: true,
        ),
      );

      final updatedList = await storage.getAll();

      expect(result.isSuccess(), isTrue);
      expect(updatedList.getOrThrow().first.saldoInicial, 150.0);
      expect(updatedList.getOrThrow().first.fechado, isTrue);
    });

    test('delete removes an existing extrato_fatura', () async {
      final created = await repository.create(
        ExtratoFaturaDto(
          origem: const LancamentoOrigem.conta(contaId: 'conta-1'),
          ano: 2026,
          mes: Mes.junho,
        ),
      );

      final model = created.getOrThrow();
      final deleteResult = await repository.delete(model.id);
      final list = await storage.getAll();

      expect(deleteResult.isSuccess(), isTrue);
      expect(list.getOrThrow(), isEmpty);
    });

    test('getById returns the correct extrato_fatura', () async {
      final created = await repository.create(
        ExtratoFaturaDto(
          origem: const LancamentoOrigem.conta(contaId: 'conta-1'),
          ano: 2026,
          mes: Mes.junho,
        ),
      );

      final model = created.getOrThrow();
      final searchResult = await repository.getById(model.id);

      expect(searchResult.getOrThrow().id, model.id);
    });

    test('search filters by mes', () async {
      await repository.create(
        ExtratoFaturaDto(
          origem: const LancamentoOrigem.conta(contaId: 'conta-1'),
          mes: Mes.junho,
          ano: 2026, //
        ),
      );
      await repository.create(
        ExtratoFaturaDto(
          origem: const LancamentoOrigem.conta(contaId: 'conta-1'),
          mes: Mes.maio,
          ano: 2026, //
        ),
      );

      final filter = ExtratoFaturaFilterDto(mes: Mes.junho, ano: 2026);
      final result = await repository.search(filter);

      expect(result.getOrThrow(), hasLength(1));
      expect(result.getOrThrow().first.mes, Mes.junho);
    });
  });
}
