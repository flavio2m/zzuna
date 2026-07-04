import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';
import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import 'package:zzuna/data/repositories/lancamento/extrato_fatura_repository.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/domain/dtos/conta/create_conta_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_dto.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_item.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';
import 'package:zzuna/domain/usecases/lancamento/create_lancamento_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/recalculate_extrato_fatura_balance_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/resolve_extrato_fatura_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/update_lancamentos_origem_usecase.dart';
import 'package:zzuna/domain/validators/lancamento_validator.dart';

import 'package:zzuna/data/services/storage/local/local_storage.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/entities/lancamento/extrato_fatura_entity.dart';

import '../../../helpers/test_storage.dart';

void main() {
  late ContaRepository contaRepository;
  late CartaoRepository cartaoRepository;
  late ExtratoFaturaRepository extratoRepository;
  late LancamentoRepository lancamentoRepository;
  late ResolveExtratoFaturaUseCase resolveUseCase;
  late RecalculateExtratoFaturaBalanceUseCase recalculateUseCase;
  late CreateLancamentoUseCase createLancamentoUseCase;
  late UpdateLancamentosOrigemUseCase updateOrigemUseCase;
  late LocalStorage<Lancamento> lancamentoStorage;
  late LocalStorage<ExtratoFatura> extratoStorage;

  late LancamentoOrigem origemContaA;
  late LancamentoOrigem origemContaB;
  late LancamentoOrigem origemContaC;
  late DateTime dataInicialConta;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final contaStorage = createTestContaStorage();
    final cartaoStorage = createTestCartaoStorage();
    extratoStorage = createTestExtratoFaturaStorage();
    lancamentoStorage = createTestLancamentoStorage();

    contaRepository = ContaRepository(contaStorage);
    cartaoRepository = CartaoRepository(cartaoStorage);
    extratoRepository = ExtratoFaturaRepository(extratoStorage);
    lancamentoRepository = LancamentoRepository(lancamentoStorage);

    resolveUseCase = ResolveExtratoFaturaUseCase(
      extratoRepository,
      contaRepository,
      cartaoRepository,
    );

    recalculateUseCase = RecalculateExtratoFaturaBalanceUseCase(
      extratoRepository,
      lancamentoRepository,
    );

    createLancamentoUseCase = CreateLancamentoUseCase(
      resolveUseCase,
      lancamentoRepository,
      LancamentoValidator(),
    );

    updateOrigemUseCase = UpdateLancamentosOrigemUseCase(
      resolveUseCase,
      recalculateUseCase,
      lancamentoRepository,
      extratoRepository,
    );

    dataInicialConta = DateTime(2026, 1, 1);

    final contaA = await contaRepository.create(
      CreateContaDto(
        descricao: 'Conta A',
        bancoSigla: 'BB',
        ativo: true,
        dataInicial: dataInicialConta,
      ),
    );
    origemContaA = LancamentoOrigem.conta(contaId: contaA.getOrThrow().id);

    final contaB = await contaRepository.create(
      CreateContaDto(
        descricao: 'Conta B',
        bancoSigla: 'C6',
        ativo: true,
        dataInicial: dataInicialConta,
      ),
    );
    origemContaB = LancamentoOrigem.conta(contaId: contaB.getOrThrow().id);

    final contaC = await contaRepository.create(
      CreateContaDto(
        descricao: 'Conta C',
        bancoSigla: 'NUBANK',
        ativo: true,
        dataInicial: dataInicialConta,
      ),
    );
    origemContaC = LancamentoOrigem.conta(contaId: contaC.getOrThrow().id);
  });

  tearDown(() {
    contaRepository.dispose();
    cartaoRepository.dispose();
    extratoRepository.dispose();
    lancamentoRepository.dispose();
  });

  group('UpdateLancamentosOrigemUseCase Tests', () {
    test(
      'Should move selected launches to destination origin and recalculate balances for all affected origins',
      () async {
        // Lancamento 1: 05/05/2026 (Conta A, 10.0) - Selecionado
        final l1 = (await createLancamentoUseCase.execute(
          LancamentoDto(
            tipo: LancamentoTipo.despesa,
            descricao: 'Lançamento 1',
            origem: origemContaA,
            data: DateTime(2026, 5, 5),
            itens: [
              LancamentoItem(
                numero: 1,
                categoriaId: 'cat-1',
                centroCustoId: 'cc-1',
                valor: 10.0,
              ),
            ],
          ),
        )).getOrThrow();

        // Lancamento 2: 05/06/2026 (Conta A, 20.0) - Nao Selecionado
        final l2 = (await createLancamentoUseCase.execute(
          LancamentoDto(
            tipo: LancamentoTipo.despesa,
            descricao: 'Lançamento 2',
            origem: origemContaA,
            data: DateTime(2026, 6, 5),
            itens: [
              LancamentoItem(
                numero: 1,
                categoriaId: 'cat-1',
                centroCustoId: 'cc-1',
                valor: 20.0,
              ),
            ],
          ),
        )).getOrThrow();

        // Lancamento 3: 05/05/2026 (Conta B, 15.0) - Selecionado
        final l3 = (await createLancamentoUseCase.execute(
          LancamentoDto(
            tipo: LancamentoTipo.despesa,
            descricao: 'Lançamento 3',
            origem: origemContaB,
            data: DateTime(2026, 5, 5),
            itens: [
              LancamentoItem(
                numero: 1,
                categoriaId: 'cat-1',
                centroCustoId: 'cc-1',
                valor: 15.0,
              ),
            ],
          ),
        )).getOrThrow();

        // Mover l1 e l3 para Conta C
        final res = await updateOrigemUseCase.execute(
          lancamentoIds: [l1.id, l3.id],
          novaOrigem: origemContaC,
        );

        expect(res.isSuccess(), isTrue);

        // l1 deve ter sido movido para Conta C
        final updatedL1 = (await lancamentoRepository.getById(
          l1.id,
        )).getOrThrow();
        expect(updatedL1.origem, origemContaC);

        // l2 deve continuar na Conta A
        final updatedL2 = (await lancamentoRepository.getById(
          l2.id,
        )).getOrThrow();
        expect(updatedL2.origem, origemContaA);

        // l3 deve ter sido movido para Conta C
        final updatedL3 = (await lancamentoRepository.getById(
          l3.id,
        )).getOrThrow();
        expect(updatedL3.origem, origemContaC);

        // Recalculos:
        // Conta A: L1 removido (mes 5), L2 preservado (mes 6)
        // Mês 5: saldoFinal = 0
        // Mês 6: saldoFinal = -20.0
        final extrato5A = (await extratoRepository.getById(
          l1.extratoFaturaId,
        )).getOrThrow();
        expect(extrato5A.saldoFinal, 0.0);

        final extrato6A = (await extratoRepository.getById(
          l2.extratoFaturaId,
        )).getOrThrow();
        expect(extrato6A.saldoFinal, -20.0);

        // Conta B: L3 removido (mes 5)
        // Mês 5: saldoFinal = 0
        final extrato5B = (await extratoRepository.getById(
          l3.extratoFaturaId,
        )).getOrThrow();
        expect(extrato5B.saldoFinal, 0.0);

        // Conta C: L1 e L3 recebidos no mes 5 (soma = 25.0)
        // Mês 5: saldoFinal = -25.0
        final extrato5C = (await extratoRepository.getById(
          updatedL1.extratoFaturaId,
        )).getOrThrow();
        expect(extrato5C.saldoFinal, -25.0);
      },
    );

    test('Should fail if any selected launch is reconciled', () async {
      final l1 = (await createLancamentoUseCase.execute(
        LancamentoDto(
          tipo: LancamentoTipo.despesa,
          descricao: 'Lançamento Reconciled',
          origem: origemContaA,
          data: DateTime(2026, 5, 5),
          itens: [
            LancamentoItem(
              numero: 1,
              categoriaId: 'cat-1',
              centroCustoId: 'cc-1',
              valor: 10.0,
            ),
          ],
        ),
      )).getOrThrow();

      // Marcar como conciliado
      final dto1 = LancamentoDto.fromEntity(l1)..setConciliado(true);
      await lancamentoRepository.update(dto1);

      final res = await updateOrigemUseCase.execute(
        lancamentoIds: [l1.id],
        novaOrigem: origemContaB,
      );

      expect(res.isError(), isTrue);
      expect(
        res.exceptionOrNull().toString(),
        contains('Não é possível alterar a origem de lançamentos conciliados.'),
      );
    });
  });
}
