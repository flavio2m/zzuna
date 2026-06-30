import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_item.dart';
import 'package:zzuna/domain/dtos/lancamento/extrato_fatura_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_dto.dart';
import 'package:zzuna/domain/usecases/lancamento/recalculate_extrato_fatura_balance_usecase.dart';
import 'package:zzuna/data/repositories/lancamento/extrato_fatura_repository.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';

import 'package:zzuna/data/services/storage/local/local_storage.dart';
import 'package:zzuna/domain/entities/lancamento/extrato_fatura_entity.dart';
import '../../../helpers/test_storage.dart';

void main() {
  late ExtratoFaturaRepository extratoRepository;
  late LancamentoRepository lancamentoRepository;
  late RecalculateExtratoFaturaBalanceUseCase recalculateUseCase;
  late LocalStorage<ExtratoFatura> extratoStorage;
  late LancamentoOrigem origemA;
  late LancamentoOrigem origemB;

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    extratoStorage = createTestExtratoFaturaStorage();
    final lancamentoStorage = createTestLancamentoStorage();

    extratoRepository = ExtratoFaturaRepository(extratoStorage);
    recalculateUseCase = RecalculateExtratoFaturaBalanceUseCase(extratoStorage, lancamentoStorage);
    lancamentoRepository = LancamentoRepository(lancamentoStorage);

    origemA = const LancamentoOrigem.conta(contaId: 'conta-A');
    origemB = const LancamentoOrigem.conta(contaId: 'conta-B');
  });

  tearDown(() {
    extratoRepository.dispose();
    lancamentoRepository.dispose();
  });

  group('RecalculateExtratoFaturaBalanceUseCase Tests', () {
    test('Should propagate balance forward starting with first period initial balance', () async {
      // 1. Criar extratos para origem A de forma cronológica
      final ef1Res = await extratoRepository.create(ExtratoFaturaDto(
        origem: origemA,
        ano: 2026,
        mes: Mes.janeiro,
        dataInicio: DateTime(2026, 1, 1),
        dataFim: DateTime(2026, 1, 31),
        saldoInicial: 100.0, // Saldo inicial não-zero
        saldoFinal: 100.0,
        fechado: false,
      ));
      final ef1 = ef1Res.getOrThrow();

      final ef2Res = await extratoRepository.create(ExtratoFaturaDto(
        origem: origemA,
        ano: 2026,
        mes: Mes.fevereiro,
        dataInicio: DateTime(2026, 2, 1),
        dataFim: DateTime(2026, 2, 28),
        saldoInicial: 0.0,
        saldoFinal: 0.0,
        fechado: false,
      ));
      final ef2 = ef2Res.getOrThrow();

      // 2. Fazer lançamento de receita em Janeiro (+50)
      await lancamentoRepository.create(LancamentoDto(
        tipo: LancamentoTipo.receita,
        descricao: 'Freelance',
        extratoFaturaId: ef1.id,
        origem: origemA,
        data: DateTime(2026, 1, 15),
        itens: [const LancamentoItem(numero: 1, categoriaId: 'cat-1', centroCustoId: 'cc-1', valor: 50.0)],
      ));

      // 3. Fazer lançamento de despesa em Fevereiro (-30)
      await lancamentoRepository.create(LancamentoDto(
        tipo: LancamentoTipo.despesa,
        descricao: 'Mercado',
        extratoFaturaId: ef2.id,
        origem: origemA,
        data: DateTime(2026, 2, 10),
        itens: [const LancamentoItem(numero: 1, categoriaId: 'cat-2', centroCustoId: 'cc-2', valor: 30.0)],
      ));

      // Executar recálculo manual
      await recalculateUseCase.execute(origemA);

      // 4. Verificar propagação
      final extratos = await extratoStorage.getAll();
      final extratosList = extratos.getOrThrow()..sort((a, b) => a.dataInicio.compareTo(b.dataInicio));

      expect(extratosList[0].saldoInicial, 100.0);
      expect(extratosList[0].saldoFinal, 150.0); // 100 + 50

      expect(extratosList[1].saldoInicial, 150.0); // saldoFinal anterior
      expect(extratosList[1].saldoFinal, 120.0); // 150 - 30
    });

    test('Should recalculate both old and new origin on update', () async {
      // 1. Criar extratos para origem A e origem B
      final efARes = await extratoRepository.create(ExtratoFaturaDto(
        id: 'ef-A',
        origem: origemA,
        ano: 2026,
        mes: Mes.janeiro,
        dataInicio: DateTime(2026, 1, 1),
        dataFim: DateTime(2026, 1, 31),
        saldoInicial: 100.0,
        fechado: false,
      ));
      final efA = efARes.getOrThrow();

      final efBRes = await extratoRepository.create(ExtratoFaturaDto(
        id: 'ef-B',
        origem: origemB,
        ano: 2026,
        mes: Mes.janeiro,
        dataInicio: DateTime(2026, 1, 1),
        dataFim: DateTime(2026, 1, 31),
        saldoInicial: 200.0,
        saldoFinal: 200.0,
        fechado: false,
      ));
      final efB = efBRes.getOrThrow();

      // 2. Criar lançamento na origem A
      final createdLancRes = await lancamentoRepository.create(LancamentoDto(
        tipo: LancamentoTipo.receita,
        descricao: 'Freelance',
        extratoFaturaId: efA.id,
        origem: origemA,
        data: DateTime(2026, 1, 15),
        itens: [const LancamentoItem(numero: 1, categoriaId: 'cat-1', centroCustoId: 'cc-1', valor: 50.0)],
      ));
      final lancamento = createdLancRes.getOrThrow();

      // Recalcular origem A
      await recalculateUseCase.execute(origemA);

      // Verificar que saldo de A subiu para 150 e B manteve 200
      var extA = (await extratoRepository.getById(efA.id)).getOrThrow();
      var extB = (await extratoRepository.getById(efB.id)).getOrThrow();
      expect(extA.saldoFinal, 150.0);
      expect(extB.saldoFinal, 200.0);

      // 3. Atualizar o lançamento mudando para origem B e seu respectivo extratoFaturaId
      await lancamentoRepository.update(LancamentoDto(
        id: lancamento.id,
        tipo: LancamentoTipo.receita,
        descricao: 'Freelance',
        extratoFaturaId: efB.id,
        origem: origemB,
        data: DateTime(2026, 1, 15),
        itens: [const LancamentoItem(numero: 1, categoriaId: 'cat-1', centroCustoId: 'cc-1', valor: 50.0)],
      ));

      // Recalcular ambas as origens
      await recalculateUseCase.execute(origemA);
      await recalculateUseCase.execute(origemB);

      // Verificar que saldo de A voltou para 100 e B subiu para 250
      extA = (await extratoRepository.getById(efA.id)).getOrThrow();
      extB = (await extratoRepository.getById(efB.id)).getOrThrow();
      expect(extA.saldoFinal, 100.0);
      expect(extB.saldoFinal, 250.0);
    });

    test('Should recalculate when a transaction is deleted', () async {
      final efRes = await extratoRepository.create(ExtratoFaturaDto(
        origem: origemA,
        ano: 2026,
        mes: Mes.janeiro,
        dataInicio: DateTime(2026, 1, 1),
        dataFim: DateTime(2026, 1, 31),
        saldoInicial: 100.0,
        fechado: false,
      ));
      final ef = efRes.getOrThrow();

      final createdLancRes = await lancamentoRepository.create(LancamentoDto(
        tipo: LancamentoTipo.receita,
        descricao: 'Freelance',
        extratoFaturaId: ef.id,
        origem: origemA,
        data: DateTime(2026, 1, 15),
        itens: [const LancamentoItem(numero: 1, categoriaId: 'cat-1', centroCustoId: 'cc-1', valor: 50.0)],
      ));
      final lancamento = createdLancRes.getOrThrow();

      // Recalcular
      await recalculateUseCase.execute(origemA);

      var ext = (await extratoRepository.getById(ef.id)).getOrThrow();
      expect(ext.saldoFinal, 150.0);

      // Excluir lançamento
      await lancamentoRepository.delete(lancamento.id);

      // Recalcular
      await recalculateUseCase.execute(origemA);

      ext = (await extratoRepository.getById(ef.id)).getOrThrow();
      expect(ext.saldoFinal, 100.0);
    });
  });
}
