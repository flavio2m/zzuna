import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/enums/lancamento_tipo.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';
import 'package:zzuna/domain/dtos/conta/create_conta_dto.dart';
import 'package:zzuna/domain/dtos/conta/loaded_conta_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/extrato_fatura_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/resolve_extrato_fatura_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_dto.dart';
import 'package:zzuna/domain/usecases/lancamento/resolve_extrato_fatura_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/create_lancamento_usecase.dart';
import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';
import 'package:zzuna/data/repositories/lancamento/extrato_fatura_repository.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';

import '../../../helpers/test_storage.dart';

void main() {
  late ContaRepository contaRepository;
  late CartaoRepository cartaoRepository;
  late ExtratoFaturaRepository extratoRepository;
  late LancamentoRepository lancamentoRepository;
  late ResolveExtratoFaturaUseCase resolveUseCase;
  late CreateLancamentoUseCase createLancamentoUseCase;

  late LancamentoOrigem origemConta;
  late DateTime dataInicialConta;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final contaStorage = createTestContaStorage();
    final cartaoStorage = createTestCartaoStorage();
    final extratoStorage = createTestExtratoFaturaStorage();
    final lancamentoStorage = createTestLancamentoStorage();

    contaRepository = ContaRepository(contaStorage);
    cartaoRepository = CartaoRepository(cartaoStorage);
    extratoRepository = ExtratoFaturaRepository(extratoStorage);
    lancamentoRepository = LancamentoRepository(lancamentoStorage);

    resolveUseCase = ResolveExtratoFaturaUseCase(
      extratoRepository,
      contaRepository,
      cartaoRepository,
    );

    createLancamentoUseCase = CreateLancamentoUseCase(
      resolveUseCase,
      lancamentoRepository,
    );

    dataInicialConta = DateTime(2026, 3, 1); // Conta criada em Março 2026

    final conta = await contaRepository.create(
      CreateContaDto(
        descricao: 'Conta Principal',
        bancoSigla: 'BB',
        ativo: true,
        dataInicial: dataInicialConta, //
      ),
    );

    origemConta = LancamentoOrigem.conta(contaId: conta.getOrThrow().id);
  });

  tearDown(() {
    contaRepository.dispose();
    cartaoRepository.dispose();
    extratoRepository.dispose();
    lancamentoRepository.dispose();
  });

  group('ResolveExtratoFaturaUseCase & CreateLancamentoUseCase Tests', () {
    test('Should throw error when resolving/creating transaction before dataInicial', () async {
      final dto = LancamentoDto(
        tipo: LancamentoTipo.despesa,
        descricao: 'Café',
        origem: origemConta,
        data: DateTime(2026, 2, 28), // Antes de 01/03/2026
      );

      final res = await createLancamentoUseCase.execute(dto);
      expect(res.isError(), isTrue);
      expect(res.exceptionOrNull()!.toString(), contains('não pode ser anterior à data inicial'));
    });

    test('Should resolve and create missing months since dataInicial when none exists', () async {
      // 1. Data do lançamento: Junho 2026. Conta iniciou em Março 2026.
      // Deve criar apenas o extrato de Junho 2026.
      final dto = ResolveExtratoFaturaDto(
        origem: origemConta,
        data: DateTime(2026, 6, 15),
        valor: 100.0,
        tipo: LancamentoTipo.despesa,
      );

      final extrato = (await resolveUseCase.execute(dto)).getOrThrow();
      expect(extrato.ano, 2026);
      expect(extrato.mes, Mes.junho);
      expect(extrato.saldoInicial, 0.0);
      expect(extrato.saldoFinal, -100.0); // Despesa subtrai

      // Verificar que apenas o de Junho foi criado (meses intermediários vazios são ignorados)
      final extratosAll = (await extratoRepository.getAll()).getOrThrow();
      expect(extratosAll, hasLength(1));
      expect(extratosAll[0].mes, Mes.junho);
      expect(extratosAll[0].saldoInicial, 0.0);
      expect(extratosAll[0].saldoFinal, -100.0);
    });

    test('Should find latest existing extrato from previous year and NOT build intermediate months', () async {
      // 1. Criar um extrato em Dezembro de 2025 com saldo final de 500
      await extratoRepository.create(
        ExtratoFaturaDto(
          id: 'ef-old',
          origem: origemConta,
          ano: 2025,
          mes: Mes.dezembro,
          dataInicio: DateTime(2025, 12, 1),
          dataFim: DateTime(2025, 12, 31),
          saldoInicial: 500.0,
          saldoFinal: 500.0,
          fechado: false,
        ),
      );

      // Ajustar dataInicial da conta para trás para permitir busca em 2025
      final conta = (await contaRepository.getAll()).getOrThrow().first;
      await contaRepository.update(
        LoadedContaDto(
          id: conta.id,
          descricao: conta.descricao,
          bancoSigla: conta.bancoSigla,
          ativo: conta.ativo,
          dataInicial: DateTime(2025, 12, 1),
        ),
      );

      // 2. Novo lançamento em Fevereiro de 2026.
      // Deve pesquisar anos anteriores, encontrar Dezembro 2025, e criar apenas Fevereiro 2026.
      final dto = ResolveExtratoFaturaDto(
        origem: origemConta,
        data: DateTime(2026, 2, 10),
        valor: 150.0,
        tipo: LancamentoTipo.receita, // Receita soma
      );

      final extrato = (await resolveUseCase.execute(dto)).getOrThrow();
      expect(extrato.ano, 2026);
      expect(extrato.mes, Mes.fevereiro);
      expect(extrato.saldoInicial, 500.0); // herdado de dezembro 2025
      expect(extrato.saldoFinal, 650.0); // 500 + 150

      final extratosAll = (await extratoRepository.getAll()).getOrThrow();
      // Dezembro 2025 e Fevereiro 2026
      expect(extratosAll, hasLength(2));
      final sorted = extratosAll..sort((a, b) => a.dataInicio.compareTo(b.dataInicio));
      expect(sorted[0].mes, Mes.dezembro);
      expect(sorted[1].mes, Mes.fevereiro);
    });

    test('Should construct transaction successfully through CreateLancamentoUseCase', () async {
      final dto = LancamentoDto(
        tipo: LancamentoTipo.receita,
        descricao: 'Salário',
        origem: origemConta,
        data: DateTime(2026, 3, 5),
        itens: const [],
      );

      final res = await createLancamentoUseCase.execute(dto);
      expect(res.isSuccess(), isTrue);

      final created = res.getOrThrow();
      expect(created.extratoFaturaId, isNotEmpty);

      final extrato = (await extratoRepository.getById(created.extratoFaturaId)).getOrThrow();
      expect(extrato.mes, Mes.marco);
      expect(extrato.saldoFinal, 0.0); // Sem itens, valor 0
    });

    test('Should propagate delta to future months chronologically', () async {
      // 1. Criar extratos para Janeiro, Fevereiro e Março de 2026
      final efJanRes = await extratoRepository.create(
        ExtratoFaturaDto(
          origem: origemConta,
          ano: 2026,
          mes: Mes.janeiro,
          dataInicio: DateTime(2026, 1, 1),
          dataFim: DateTime(2026, 1, 31),
          saldoInicial: 1000.0,
          saldoFinal: 1000.0,
          fechado: false,
        ),
      );
      final efJan = efJanRes.getOrThrow();

      final efFevRes = await extratoRepository.create(
        ExtratoFaturaDto(
          origem: origemConta,
          ano: 2026,
          mes: Mes.fevereiro,
          dataInicio: DateTime(2026, 2, 1),
          dataFim: DateTime(2026, 2, 28),
          saldoInicial: 1000.0,
          saldoFinal: 1200.0,
          fechado: false,
        ),
      );
      final efFev = efFevRes.getOrThrow();

      final efMarRes = await extratoRepository.create(
        ExtratoFaturaDto(
          origem: origemConta,
          ano: 2026,
          mes: Mes.marco,
          dataInicio: DateTime(2026, 3, 1),
          dataFim: DateTime(2026, 3, 31),
          saldoInicial: 1200.0,
          saldoFinal: 1500.0,
          fechado: false,
        ),
      );
      final efMar = efMarRes.getOrThrow();

      // Ajustar dataInicial para permitir esses meses
      final conta = (await contaRepository.getAll()).getOrThrow().first;
      await contaRepository.update(
        LoadedContaDto(
          id: conta.id,
          descricao: conta.descricao,
          bancoSigla: conta.bancoSigla,
          ativo: conta.ativo,
          dataInicial: DateTime(2026, 1, 1),
        ),
      );

      // Novo lançamento em Janeiro: Despesa de 100 (delta = -100)
      final dto = ResolveExtratoFaturaDto(
        origem: origemConta,
        data: DateTime(2026, 1, 15),
        valor: 100.0,
        tipo: LancamentoTipo.despesa,
      );

      final resolved = (await resolveUseCase.execute(dto)).getOrThrow();
      expect(resolved.saldoFinal, 900.0); // 1000 - 100

      // Buscar extratos atualizados
      final extJan = (await extratoRepository.getById(efJan.id)).getOrThrow();
      final extFev = (await extratoRepository.getById(efFev.id)).getOrThrow();
      final extMar = (await extratoRepository.getById(efMar.id)).getOrThrow();

      expect(extJan.saldoFinal, 900.0);

      expect(extFev.saldoInicial, 900.0); // 1000 - 100
      expect(extFev.saldoFinal, 1100.0); // 1200 - 100

      expect(extMar.saldoInicial, 1100.0); // 1200 - 100
      expect(extMar.saldoFinal, 1400.0); // 1500 - 100
    });

    test('Should return failure when the resolved extrato is closed', () async {
      // 1. Criar um extrato fechado para Janeiro de 2026
      await extratoRepository.create(
        ExtratoFaturaDto(
          origem: origemConta,
          ano: 2026,
          mes: Mes.janeiro,
          dataInicio: DateTime(2026, 1, 1),
          dataFim: DateTime(2026, 1, 31),
          saldoInicial: 1000.0,
          saldoFinal: 1000.0,
          fechado: true, // fechado!
        ),
      );

      // Ajustar dataInicial para permitir esse mês
      final conta = (await contaRepository.getAll()).getOrThrow().first;
      await contaRepository.update(
        LoadedContaDto(
          id: conta.id,
          descricao: conta.descricao,
          bancoSigla: conta.bancoSigla,
          ativo: conta.ativo,
          dataInicial: DateTime(2026, 1, 1),
        ),
      );

      final dto = ResolveExtratoFaturaDto(
        origem: origemConta,
        data: DateTime(2026, 1, 15),
        valor: 100.0,
        tipo: LancamentoTipo.despesa,
      );

      final res = await resolveUseCase.execute(dto);
      expect(res.isError(), isTrue);
      expect(res.exceptionOrNull()!.toString(), contains('Não é possível registrar lançamentos em um período encerrado.'));
    });
  });
}
