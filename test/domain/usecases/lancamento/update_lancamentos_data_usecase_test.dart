import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';
import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import 'package:zzuna/data/repositories/lancamento/extrato_fatura_repository.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/domain/dtos/conta/create_conta_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/extrato_fatura_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_dto.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_item.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';
import 'package:zzuna/domain/usecases/lancamento/create_lancamento_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/recalculate_extrato_fatura_balance_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/resolve_extrato_fatura_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/update_lancamentos_data_usecase.dart';
import 'package:zzuna/domain/validators/lancamento_validator.dart';

import 'package:zzuna/data/services/storage/local/local_storage.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/dtos/lancamento/create_transferencia_dto.dart';
import 'package:zzuna/domain/usecases/lancamento/create_lancamentos_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/create_transferencia_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/resolve_extrato_faturas_usecase.dart';
import 'package:zzuna/domain/validators/transferencia_validator.dart';

import '../../../helpers/test_storage.dart';

void main() {
  late ContaRepository contaRepository;
  late CartaoRepository cartaoRepository;
  late ExtratoFaturaRepository extratoRepository;
  late LancamentoRepository lancamentoRepository;
  late ResolveExtratoFaturaUseCase resolveUseCase;
  late ResolveExtratoFaturasUseCase resolveLoteUseCase;
  late RecalculateExtratoFaturaBalanceUseCase recalculateUseCase;
  late CreateLancamentoUseCase createLancamentoUseCase;
  late CreateLancamentosUseCase createLancamentosUseCase;
  late CreateTransferenciaUseCase createTransferenciaUseCase;
  late UpdateLancamentosDataUseCase updateDataUseCase;
  late LocalStorage<Lancamento> lancamentoStorage;

  late LancamentoOrigem origemConta;
  late LancamentoOrigem origemConta2;
  late DateTime dataInicialConta;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final contaStorage = createTestContaStorage();
    final cartaoStorage = createTestCartaoStorage();
    final extratoStorage = createTestExtratoFaturaStorage();
    lancamentoStorage = createTestLancamentoStorage();

    contaRepository = ContaRepository(contaStorage);
    cartaoRepository = CartaoRepository(cartaoStorage);
    extratoRepository = ExtratoFaturaRepository(extratoStorage);
    lancamentoRepository = LancamentoRepository(lancamentoStorage);

    resolveUseCase = ResolveExtratoFaturaUseCase(extratoRepository, contaRepository, cartaoRepository);
    resolveLoteUseCase = ResolveExtratoFaturasUseCase(extratoRepository, contaRepository, cartaoRepository);

    recalculateUseCase = RecalculateExtratoFaturaBalanceUseCase(extratoStorage, lancamentoStorage);

    createLancamentoUseCase = CreateLancamentoUseCase(resolveUseCase, lancamentoRepository, LancamentoValidator());
    createLancamentosUseCase = CreateLancamentosUseCase(resolveLoteUseCase, lancamentoRepository, LancamentoValidator());
    createTransferenciaUseCase = CreateTransferenciaUseCase(
      createLancamentosUseCase,
      TransferenciaValidator(),
    );

    updateDataUseCase = UpdateLancamentosDataUseCase(
      resolveUseCase,
      recalculateUseCase,
      lancamentoRepository,
      extratoRepository,
      contaRepository,
      cartaoRepository,
    );

    dataInicialConta = DateTime(2026, 1, 1);

    final conta = await contaRepository.create(
      CreateContaDto(descricao: 'Conta Principal', bancoSigla: 'BB', ativo: true, dataInicial: dataInicialConta),
    );
    origemConta = LancamentoOrigem.conta(contaId: conta.getOrThrow().id);

    final conta2 = await contaRepository.create(
      CreateContaDto(descricao: 'Conta Secundária', bancoSigla: 'NU', ativo: true, dataInicial: dataInicialConta),
    );
    origemConta2 = LancamentoOrigem.conta(contaId: conta2.getOrThrow().id);
  });

  tearDown(() {
    contaRepository.dispose();
    cartaoRepository.dispose();
    extratoRepository.dispose();
    lancamentoRepository.dispose();
  });

  group('UpdateLancamentosDataUseCase Tests', () {
    test('Should successfully change date within the same month', () async {
      // 1. Criar lançamento em 05/01/2026
      final created = (await createLancamentoUseCase.execute(
        LancamentoDto(
          tipo: LancamentoTipo.despesa,
          descricao: 'Padaria',
          origem: origemConta,
          data: DateTime(2026, 1, 5),
          itens: [LancamentoItem(numero: 1, categoriaId: 'cat-1', centroCustoId: 'cc-1', valor: 20.0)],
        ),
      )).getOrThrow();

      // 2. Mover para 20/01/2026
      final novaData = DateTime(2026, 1, 20);
      final res = await updateDataUseCase.execute(ids: [created.id], novaData: novaData);
      expect(res.isSuccess(), isTrue);

      // 3. Verificar se a data foi atualizada no repositório
      final updated = (await lancamentoRepository.getById(created.id)).getOrThrow();
      expect(updated.data, novaData);
    });

    test('Should successfully move multiple launches to a different month and recalculate balances', () async {
      // 1. Criar dois lançamentos em janeiro de 2026
      final l1 = (await createLancamentoUseCase.execute(
        LancamentoDto(
          tipo: LancamentoTipo.despesa,
          descricao: 'Mercado',
          origem: origemConta,
          data: DateTime(2026, 1, 5),
          itens: [LancamentoItem(numero: 1, categoriaId: 'cat-1', centroCustoId: 'cc-1', valor: 100.0)],
        ),
      )).getOrThrow();

      final l2 = (await createLancamentoUseCase.execute(
        LancamentoDto(
          tipo: LancamentoTipo.receita,
          descricao: 'Salário',
          origem: origemConta,
          data: DateTime(2026, 1, 10),
          itens: [LancamentoItem(numero: 1, categoriaId: 'cat-1', centroCustoId: 'cc-1', valor: 1000.0)],
        ),
      )).getOrThrow();

      // Verificar saldos iniciais/finais de Janeiro/2026
      final extratoJaneiro = (await extratoRepository.searchByPeriodo(
        origemConta,
        2026,
        Mes.janeiro,
      )).getOrThrow().first;
      expect(extratoJaneiro.saldoFinal, 900.0); // +1000 - 100

      // 2. Mover ambos para Fevereiro/2026
      final novaData = DateTime(2026, 2, 15);
      final res = await updateDataUseCase.execute(ids: [l1.id, l2.id], novaData: novaData);
      expect(res.isSuccess(), isTrue);

      // 3. Verificar que as datas foram atualizadas no repositório
      final checkL1 = (await lancamentoRepository.getById(l1.id)).getOrThrow();
      final checkL2 = (await lancamentoRepository.getById(l2.id)).getOrThrow();
      expect(checkL1.data, novaData);
      expect(checkL2.data, novaData);

      // 4. Verificar os saldos recalculados
      final recalcJaneiro = (await extratoRepository.searchByPeriodo(
        origemConta,
        2026,
        Mes.janeiro,
      )).getOrThrow().first;
      final recalcFevereiro = (await extratoRepository.searchByPeriodo(
        origemConta,
        2026,
        Mes.fevereiro,
      )).getOrThrow().first;

      expect(recalcJaneiro.saldoFinal, 0.0); // Zerado pois os lançamentos saíram de janeiro
      expect(recalcFevereiro.saldoFinal, 900.0); // Os lançamentos foram somados em fevereiro
    });

    test('Should return Failure if any ID is not found and make no changes', () async {
      final l1 = (await createLancamentoUseCase.execute(
        LancamentoDto(
          tipo: LancamentoTipo.despesa,
          descricao: 'Padaria',
          origem: origemConta,
          data: DateTime(2026, 1, 5),
          itens: [LancamentoItem(numero: 1, categoriaId: 'cat-1', centroCustoId: 'cc-1', valor: 20.0)],
        ),
      )).getOrThrow();

      final res = await updateDataUseCase.execute(ids: [l1.id, 'id-inexistente'], novaData: DateTime(2026, 1, 20));

      expect(res.isError(), isTrue);
      expect(res.exceptionOrNull()!.toString(), contains('Lançamento com ID id-inexistente não encontrado.'));

      // Garantir que l1 não foi alterado
      final check = (await lancamentoRepository.getById(l1.id)).getOrThrow();
      expect(check.data, DateTime(2026, 1, 5));
    });

    test('Should return Failure if the launch original period is closed', () async {
      final l1 = (await createLancamentoUseCase.execute(
        LancamentoDto(
          tipo: LancamentoTipo.despesa,
          descricao: 'Padaria',
          origem: origemConta,
          data: DateTime(2026, 1, 5),
          itens: [LancamentoItem(numero: 1, categoriaId: 'cat-1', centroCustoId: 'cc-1', valor: 20.0)],
        ),
      )).getOrThrow();

      // Fechar o extrato de Janeiro/2026
      final extratoJaneiro = (await extratoRepository.searchByPeriodo(
        origemConta,
        2026,
        Mes.janeiro,
      )).getOrThrow().first;
      await extratoRepository.update(
        ExtratoFaturaDto(
          id: extratoJaneiro.id,
          origem: extratoJaneiro.origem,
          ano: extratoJaneiro.ano,
          mes: extratoJaneiro.mes,
          dataInicio: extratoJaneiro.dataInicio,
          dataFim: extratoJaneiro.dataFim,
          saldoInicial: extratoJaneiro.saldoInicial,
          saldoFinal: extratoJaneiro.saldoFinal,
          fechado: true,
        ),
      );

      final res = await updateDataUseCase.execute(ids: [l1.id], novaData: DateTime(2026, 1, 20));

      expect(res.isError(), isTrue);
      expect(res.exceptionOrNull()!.toString(), contains('Não é possível editar lançamentos de um período encerrado.'));
    });

    test('Should return Failure if the destination period is closed', () async {
      final l1 = (await createLancamentoUseCase.execute(
        LancamentoDto(
          tipo: LancamentoTipo.despesa,
          descricao: 'Padaria',
          origem: origemConta,
          data: DateTime(2026, 1, 5),
          itens: [LancamentoItem(numero: 1, categoriaId: 'cat-1', centroCustoId: 'cc-1', valor: 20.0)],
        ),
      )).getOrThrow();

      // Criar extrato fechado para Fevereiro/2026
      await extratoRepository.create(
        ExtratoFaturaDto(
          origem: origemConta,
          ano: 2026,
          mes: Mes.fevereiro,
          dataInicio: DateTime(2026, 2, 1),
          dataFim: DateTime(2026, 2, 28, 23, 59, 59, 999),
          saldoInicial: 0.0,
          saldoFinal: 0.0,
          fechado: true,
        ),
      );

      final res = await updateDataUseCase.execute(ids: [l1.id], novaData: DateTime(2026, 2, 15));

      expect(res.isError(), isTrue);
      expect(
        res.exceptionOrNull()!.toString(),
        contains('Não é possível registrar lançamentos em um período encerrado.'),
      );
    });

    test('Should return Failure if new date is before the account/card start date', () async {
      final l1 = (await createLancamentoUseCase.execute(
        LancamentoDto(
          tipo: LancamentoTipo.despesa,
          descricao: 'Padaria',
          origem: origemConta,
          data: DateTime(2026, 1, 5),
          itens: [LancamentoItem(numero: 1, categoriaId: 'cat-1', centroCustoId: 'cc-1', valor: 20.0)],
        ),
      )).getOrThrow();

      // Mover para Dezembro/2025 (data inicial da conta é 01/01/2026)
      final res = await updateDataUseCase.execute(ids: [l1.id], novaData: DateTime(2025, 12, 15));

      expect(res.isError(), isTrue);
      expect(
        res.exceptionOrNull()!.toString(),
        contains('Data do lançamento não pode ser anterior à data inicial do cartão/conta'),
      );
    });

    test('Should return Failure if new date is further than 24 months from today', () async {
      final l1 = (await createLancamentoUseCase.execute(
        LancamentoDto(
          tipo: LancamentoTipo.despesa,
          descricao: 'Padaria',
          origem: origemConta,
          data: DateTime(2026, 1, 5),
          itens: [LancamentoItem(numero: 1, categoriaId: 'cat-1', centroCustoId: 'cc-1', valor: 20.0)],
        ),
      )).getOrThrow();

      // Mover para 3 anos no futuro
      final futureDate = DateTime.now().add(const Duration(days: 3 * 365));
      final res = await updateDataUseCase.execute(ids: [l1.id], novaData: futureDate);

      expect(res.isError(), isTrue);
      expect(res.exceptionOrNull()!.toString(), contains('Data não pode ser superior a 24 meses da data atual'));
    });

    test('Should update the date of both transactions in a transfer by group ID', () async {
      // 1. Criar transferência (Conta Principal -> Conta Secundária)
      final transferRes = await createTransferenciaUseCase.execute(
        CreateTransferenciaDto(
          data: DateTime(2026, 1, 10),
          descricao: 'Transferência Pix',
          valor: 150.0,
          origemSaida: origemConta,
          origemEntrada: origemConta2,
          observacao: 'Pix de teste',
        ),
      );
      expect(transferRes.isSuccess(), isTrue);

      // 2. Localizar as duas transações criadas
      final launches = (await lancamentoStorage.getAll()).getOrThrow();
      expect(launches.length, 2);
      final idSaida = launches.firstWhere((l) => l.origem == origemConta).id;
      final idEntrada = launches.firstWhere((l) => l.origem == origemConta2).id;

      // 3. Chamar updateDataUseCase passando apenas o ID da saída
      final novaData = DateTime(2026, 1, 25);
      final res = await updateDataUseCase.execute(
        ids: [idSaida],
        novaData: novaData,
      );
      expect(res.isSuccess(), isTrue);

      // 4. Verificar que a data de ambas as transações foi atualizada
      final updatedSaida = (await lancamentoRepository.getById(idSaida)).getOrThrow();
      final updatedEntrada = (await lancamentoRepository.getById(idEntrada)).getOrThrow();
      expect(updatedSaida.data, novaData);
      expect(updatedEntrada.data, novaData);
    });
  });
}
