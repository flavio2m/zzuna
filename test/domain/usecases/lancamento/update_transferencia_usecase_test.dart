import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';
import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import 'package:zzuna/data/repositories/lancamento/extrato_fatura_repository.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/domain/dtos/cartao/cartao_dto.dart';
import 'package:zzuna/domain/dtos/conta/create_conta_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/create_transferencia_dto.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';
import 'package:zzuna/domain/usecases/lancamento/create_lancamentos_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/create_transferencia_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/update_transferencia_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/resolve_extrato_faturas_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/recalculate_extrato_fatura_balance_usecase.dart';
import 'package:zzuna/domain/validators/lancamento_validator.dart';
import 'package:zzuna/domain/validators/transferencia_validator.dart';

import 'package:zzuna/data/services/storage/local/local_storage.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import '../../../helpers/test_storage.dart';

void main() {
  late ContaRepository contaRepository;
  late CartaoRepository cartaoRepository;
  late ExtratoFaturaRepository extratoRepository;
  late LancamentoRepository lancamentoRepository;
  late ResolveExtratoFaturasUseCase resolveUseCase;
  late RecalculateExtratoFaturaBalanceUseCase recalculateUseCase;
  late CreateLancamentosUseCase createLancamentosUseCase;
  late CreateTransferenciaUseCase createTransferenciaUseCase;
  late UpdateTransferenciaUseCase updateTransferenciaUseCase;
  late LocalStorage<Lancamento> lancamentoStorage;

  late LancamentoOrigem contaA;
  late LancamentoOrigem contaB;
  late LancamentoOrigem cartaoC;
  late LancamentoOrigem cartaoD;

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

    resolveUseCase = ResolveExtratoFaturasUseCase(
      extratoRepository,
      contaRepository,
      cartaoRepository,
    );

    recalculateUseCase = RecalculateExtratoFaturaBalanceUseCase(
      extratoStorage,
      lancamentoStorage,
    );

    createLancamentosUseCase = CreateLancamentosUseCase(
      resolveUseCase,
      lancamentoRepository,
      LancamentoValidator(),
    );

    createTransferenciaUseCase = CreateTransferenciaUseCase(
      createLancamentosUseCase,
      TransferenciaValidator(),
    );

    updateTransferenciaUseCase = UpdateTransferenciaUseCase(
      resolveUseCase,
      recalculateUseCase,
      lancamentoRepository,
      extratoRepository,
      TransferenciaValidator(),
    );

    // Criar Contas
    final cA = await contaRepository.create(
      CreateContaDto(
        descricao: 'Conta A',
        bancoSigla: 'BB',
        ativo: true,
        dataInicial: DateTime(2026, 1, 1),
      ),
    );
    final cB = await contaRepository.create(
      CreateContaDto(
        descricao: 'Conta B',
        bancoSigla: 'ITAU',
        ativo: true,
        dataInicial: DateTime(2026, 1, 1),
      ),
    );

    // Criar Cartões
    final cC = await cartaoRepository.create(
      CartaoDto(
        descricao: 'Cartão C',
        bancoSigla: 'NUBANK',
        limite: 1000.0,
        ativo: true,
        diaFechamento: 10,
        dataInicial: DateTime(2026, 1, 1),
      ),
    );
    final cD = await cartaoRepository.create(
      CartaoDto(
        descricao: 'Cartão D',
        bancoSigla: 'BRADESCO',
        limite: 2000.0,
        ativo: true,
        diaFechamento: 15,
        dataInicial: DateTime(2026, 1, 1),
      ),
    );

    contaA = LancamentoOrigem.conta(contaId: cA.getOrThrow().id);
    contaB = LancamentoOrigem.conta(contaId: cB.getOrThrow().id);
    cartaoC = LancamentoOrigem.cartao(cartaoId: cC.getOrThrow().id);
    cartaoD = LancamentoOrigem.cartao(cartaoId: cD.getOrThrow().id);
  });

  tearDown(() {
    contaRepository.dispose();
    cartaoRepository.dispose();
    extratoRepository.dispose();
    lancamentoRepository.dispose();
  });

  group('UpdateTransferenciaUseCase Tests', () {
    test('Should edit only description and observation successfully', () async {
      // 1. Criar transferência original
      final createRes = await createTransferenciaUseCase.execute(
        CreateTransferenciaDto(
          data: DateTime(2026, 1, 15),
          descricao: 'Transferência Pix',
          valor: 100.0,
          origemSaida: contaA,
          origemEntrada: contaB,
          observacao: 'Original Obs',
        ),
      );
      expect(createRes.isSuccess(), isTrue);

      final launches = (await lancamentoStorage.getAll()).getOrThrow();
      final originalGrupoId = launches.first.grupo!.grupoId;
      final originalSaidaId = launches.firstWhere((l) => l.origem == contaA).id;
      final originalEntradaId = launches
          .firstWhere((l) => l.origem == contaB)
          .id;

      // 2. Editar descrição e observação
      final updateRes = await updateTransferenciaUseCase.execute(
        originalGrupoId,
        CreateTransferenciaDto(
          data: DateTime(2026, 1, 15),
          descricao: 'Pix Alterado',
          valor: 100.0,
          origemSaida: contaA,
          origemEntrada: contaB,
          observacao: 'Nova Obs',
        ),
      );
      expect(updateRes.isSuccess(), isTrue);

      // 3. Verificar atualizações
      final updatedLaunches = (await lancamentoStorage.getAll())
          .getOrThrow();
      expect(updatedLaunches.length, 2);

      final saida = updatedLaunches.firstWhere((l) => l.id == originalSaidaId);
      final entrada = updatedLaunches.firstWhere(
        (l) => l.id == originalEntradaId,
      );

      expect(saida.descricao, 'Pix Alterado');
      expect(saida.observacao, 'Nova Obs');
      expect(saida.grupo!.grupoId, originalGrupoId);

      expect(entrada.descricao, 'Pix Alterado');
      expect(entrada.observacao, 'Nova Obs');
      expect(entrada.grupo!.grupoId, originalGrupoId);
    });

    test('Should change date and update faturas/extratos correctly', () async {
      // 1. Criar transferência em Janeiro
      final createRes = await createTransferenciaUseCase.execute(
        CreateTransferenciaDto(
          data: DateTime(2026, 1, 15),
          descricao: 'Transferência',
          valor: 100.0,
          origemSaida: contaA,
          origemEntrada: contaB,
        ),
      );
      expect(createRes.isSuccess(), isTrue);

      final launches = (await lancamentoStorage.getAll()).getOrThrow();
      final originalGrupoId = launches.first.grupo!.grupoId;

      // 2. Mudar data para Fevereiro
      final updateRes = await updateTransferenciaUseCase.execute(
        originalGrupoId,
        CreateTransferenciaDto(
          data: DateTime(2026, 2, 20),
          descricao: 'Transferência',
          valor: 100.0,
          origemSaida: contaA,
          origemEntrada: contaB,
        ),
      );
      expect(updateRes.isSuccess(), isTrue);

      // 3. Verificar saldos de Janeiro (deve retornar a 0.0) e Fevereiro (deve refletir 100.0)
      final janSaidaRes = await extratoRepository.searchByPeriodo(
        contaA,
        2026,
        Mes.janeiro,
      );
      final febSaidaRes = await extratoRepository.searchByPeriodo(
        contaA,
        2026,
        Mes.fevereiro,
      );
      expect(janSaidaRes.getOrThrow().first.saldoFinal, 0.0);
      expect(febSaidaRes.getOrThrow().first.saldoFinal, -100.0);

      final janEntradaRes = await extratoRepository.searchByPeriodo(
        contaB,
        2026,
        Mes.janeiro,
      );
      final febEntradaRes = await extratoRepository.searchByPeriodo(
        contaB,
        2026,
        Mes.fevereiro,
      );
      expect(janEntradaRes.getOrThrow().first.saldoFinal, 0.0);
      expect(febEntradaRes.getOrThrow().first.saldoFinal, 100.0);
    });

    test('Should change value and recalculate balances correctly', () async {
      final createRes = await createTransferenciaUseCase.execute(
        CreateTransferenciaDto(
          data: DateTime(2026, 1, 15),
          descricao: 'Transferência',
          valor: 100.0,
          origemSaida: contaA,
          origemEntrada: contaB,
        ),
      );
      expect(createRes.isSuccess(), isTrue);

      final originalGrupoId = (await lancamentoStorage.getAll())
          .getOrThrow()
          .first
          .grupo!
          .grupoId;

      // Mudar valor para 250.0
      final updateRes = await updateTransferenciaUseCase.execute(
        originalGrupoId,
        CreateTransferenciaDto(
          data: DateTime(2026, 1, 15),
          descricao: 'Transferência',
          valor: 250.0,
          origemSaida: contaA,
          origemEntrada: contaB,
        ),
      );
      expect(updateRes.isSuccess(), isTrue);

      final extratoA = (await extratoRepository.searchByPeriodo(
        contaA,
        2026,
        Mes.janeiro,
      )).getOrThrow().first;
      final extratoB = (await extratoRepository.searchByPeriodo(
        contaB,
        2026,
        Mes.janeiro,
      )).getOrThrow().first;

      expect(extratoA.saldoFinal, -250.0);
      expect(extratoB.saldoFinal, 250.0);
    });

    test(
      'Should change origin and destination accounts and adjust all 4 balances',
      () async {
        // 1. Transferência original: Conta A -> Conta B (100.0)
        final createRes = await createTransferenciaUseCase.execute(
          CreateTransferenciaDto(
            data: DateTime(2026, 1, 15),
            descricao: 'Transferência',
            valor: 100.0,
            origemSaida: contaA,
            origemEntrada: contaB,
          ),
        );
        expect(createRes.isSuccess(), isTrue);

        final originalGrupoId = (await lancamentoStorage.getAll())
            .getOrThrow()
            .first
            .grupo!
            .grupoId;

        // 2. Editar transferência para: Cartão C -> Cartão D (150.0)
        final updateRes = await updateTransferenciaUseCase.execute(
          originalGrupoId,
          CreateTransferenciaDto(
            data: DateTime(2026, 1, 15),
            descricao: 'Transferência',
            valor: 150.0,
            origemSaida: cartaoC,
            origemEntrada: cartaoD,
          ),
        );
        expect(updateRes.isSuccess(), isTrue);

        // 3. Verificar saldos das 4 contas/cartões envolvidos
        // Conta A e Conta B devem retornar a 0.0
        final extratoA = (await extratoRepository.searchByPeriodo(
          contaA,
          2026,
          Mes.janeiro,
        )).getOrThrow().first;
        final extratoB = (await extratoRepository.searchByPeriodo(
          contaB,
          2026,
          Mes.janeiro,
        )).getOrThrow().first;
        expect(extratoA.saldoFinal, 0.0);
        expect(extratoB.saldoFinal, 0.0);

        // Cartão C (-150.0) e Cartão D (150.0)
        final extratoC = (await extratoRepository.searchByPeriodo(
          cartaoC,
          2026,
          Mes.janeiro,
        )).getOrThrow().first;
        final extratoD = (await extratoRepository.searchByPeriodo(
          cartaoD,
          2026,
          Mes.janeiro,
        )).getOrThrow().first;
        expect(extratoC.saldoFinal, -150.0);
        expect(extratoD.saldoFinal, 150.0);
      },
    );

    test(
      'Should fail if using same origin and destination in update',
      () async {
        final createRes = await createTransferenciaUseCase.execute(
          CreateTransferenciaDto(
            data: DateTime(2026, 1, 15),
            descricao: 'Transferência',
            valor: 100.0,
            origemSaida: contaA,
            origemEntrada: contaB,
          ),
        );
        expect(createRes.isSuccess(), isTrue);

        final originalGrupoId = (await lancamentoStorage.getAll())
            .getOrThrow()
            .first
            .grupo!
            .grupoId;

        final updateRes = await updateTransferenciaUseCase.execute(
          originalGrupoId,
          CreateTransferenciaDto(
            data: DateTime(2026, 1, 15),
            descricao: 'Transferência',
            valor: 100.0,
            origemSaida: contaA,
            origemEntrada: contaA,
          ),
        );
        expect(updateRes.isError(), isTrue);
        expect(
          updateRes.exceptionOrNull().toString(),
          contains('A conta/cartão de origem deve ser diferente do destino'),
        );
      },
    );

    test(
      'Should support all combinations of origins: Cartao -> Conta',
      () async {
        final createRes = await createTransferenciaUseCase.execute(
          CreateTransferenciaDto(
            data: DateTime(2026, 1, 15),
            descricao: 'Transferência',
            valor: 100.0,
            origemSaida: contaA,
            origemEntrada: contaB,
          ),
        );
        expect(createRes.isSuccess(), isTrue);

        final originalGrupoId = (await lancamentoStorage.getAll())
            .getOrThrow()
            .first
            .grupo!
            .grupoId;

        // Cartão C -> Conta B (Cartão -> Conta)
        final updateRes = await updateTransferenciaUseCase.execute(
          originalGrupoId,
          CreateTransferenciaDto(
            data: DateTime(2026, 1, 15),
            descricao: 'Transferência',
            valor: 100.0,
            origemSaida: cartaoC,
            origemEntrada: contaB,
          ),
        );
        expect(updateRes.isSuccess(), isTrue);

        final extratoC = (await extratoRepository.searchByPeriodo(
          cartaoC,
          2026,
          Mes.janeiro,
        )).getOrThrow().first;
        final extratoB = (await extratoRepository.searchByPeriodo(
          contaB,
          2026,
          Mes.janeiro,
        )).getOrThrow().first;
        expect(extratoC.saldoFinal, -100.0);
        expect(extratoB.saldoFinal, 100.0);
      },
    );
  });
}
