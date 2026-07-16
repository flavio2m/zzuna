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
import 'package:zzuna/domain/value_objects/lancamento/lancamento_grupo.dart';
import 'package:zzuna/domain/usecases/lancamento/create_lancamento_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/recalculate_extrato_fatura_balance_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/resolve_extrato_fatura_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/update_lancamentos_origem_grupo_usecase.dart';
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
  late UpdateLancamentosOrigemGrupoUseCase updateOrigemGrupoUseCase;
  late LocalStorage<Lancamento> lancamentoStorage;
  late LocalStorage<ExtratoFatura> extratoStorage;

  late LancamentoOrigem origemContaA;
  late LancamentoOrigem origemContaB;
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

    updateOrigemGrupoUseCase = UpdateLancamentosOrigemGrupoUseCase(
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
  });

  tearDown(() {
    contaRepository.dispose();
    cartaoRepository.dispose();
    extratoRepository.dispose();
    lancamentoRepository.dispose();
  });

  group('UpdateLancamentosOrigemGrupoUseCase Tests', () {
    test(
      'Should move origins cascadingly and recalculate balances for both origins',
      () async {
        // Parcela 1: 05/05/2026 (Conta A)
        final l1 = (await createLancamentoUseCase.execute(
          LancamentoDto(
            tipo: LancamentoTipo.despesa,
            descricao: 'Parcela 1/3',
            origem: origemContaA,
            data: DateTime(2026, 5, 5),
            grupo: const LancamentoGrupo.parcelamento(
              grupoId: 'grupo-abc',
              parcela: 1,
              totalParcelas: 3,
            ),
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

        // Parcela 2: 05/06/2026 (Conta A) (referência)
        final l2 = (await createLancamentoUseCase.execute(
          LancamentoDto(
            tipo: LancamentoTipo.despesa,
            descricao: 'Parcela 2/3',
            origem: origemContaA,
            data: DateTime(2026, 6, 5),
            grupo: const LancamentoGrupo.parcelamento(
              grupoId: 'grupo-abc',
              parcela: 2,
              totalParcelas: 3,
            ),
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

        // Parcela 3: 05/07/2026 (Conta A)
        final l3 = (await createLancamentoUseCase.execute(
          LancamentoDto(
            tipo: LancamentoTipo.despesa,
            descricao: 'Parcela 3/3',
            origem: origemContaA,
            data: DateTime(2026, 7, 5),
            grupo: const LancamentoGrupo.parcelamento(
              grupoId: 'grupo-abc',
              parcela: 3,
              totalParcelas: 3,
            ),
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

        // Mudar a partir da Parcela 2 para Conta B
        final res = await updateOrigemGrupoUseCase.execute(
          lancamentoId: l2.id,
          novaOrigem: origemContaB,
        );

        expect(res.isSuccess(), isTrue);

        // Parcela 1 deve continuar na Conta A
        final updatedL1 = (await lancamentoRepository.getById(
          l1.id,
        )).getOrThrow();
        expect(updatedL1.origem, origemContaA);

        // Parcela 2 deve ter sido movida para Conta B
        final updatedL2 = (await lancamentoRepository.getById(
          l2.id,
        )).getOrThrow();
        expect(updatedL2.origem, origemContaB);
        final extrato6B_l2 = (await extratoRepository.getById(
          updatedL2.extratoFaturaId,
        )).getOrThrow();
        expect(updatedL2.anoMes, equals(extrato6B_l2.periodo));

        // Parcela 3 deve ter sido movida para Conta B
        final updatedL3 = (await lancamentoRepository.getById(
          l3.id,
        )).getOrThrow();
        expect(updatedL3.origem, origemContaB);
        final extrato7B_l3 = (await extratoRepository.getById(
          updatedL3.extratoFaturaId,
        )).getOrThrow();
        expect(updatedL3.anoMes, equals(extrato7B_l3.periodo));

        // Saldos de Conta A devem refletir apenas Parcela 1
        // Mês 5: saldoFinal = -10.0
        // Mês 6: saldoFinal = -10.0 (sem Parcela 2)
        // Mês 7: saldoFinal = -10.0 (sem Parcela 3)
        final extrato5A = (await extratoRepository.getById(
          l1.extratoFaturaId,
        )).getOrThrow();
        expect(extrato5A.saldoFinal, -10.0);

        final extrato6A = (await extratoRepository.getById(
          l2.extratoFaturaId,
        )).getOrThrow();
        expect(extrato6A.saldoFinal, -10.0);

        // Saldos de Conta B devem refletir Parcela 2 e 3
        // Mês 6: saldoFinal = -10.0
        // Mês 7: saldoFinal = -20.0
        final extrato6B = (await extratoRepository.getById(
          updatedL2.extratoFaturaId,
        )).getOrThrow();
        expect(extrato6B.saldoFinal, -10.0);

        final extrato7B = (await extratoRepository.getById(
          updatedL3.extratoFaturaId,
        )).getOrThrow();
        expect(extrato7B.saldoFinal, -20.0);
      },
    );

    test(
      'Should fail if destination account initial date is after target launch date',
      () async {
        // Parcela 1: 05/05/2026
        final l1 = (await createLancamentoUseCase.execute(
          LancamentoDto(
            tipo: LancamentoTipo.despesa,
            descricao: 'Parcela 1/1',
            origem: origemContaA,
            data: DateTime(2026, 5, 5),
            grupo: const LancamentoGrupo.parcelamento(
              grupoId: 'grupo-xyz',
              parcela: 1,
              totalParcelas: 1,
            ),
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

        // Conta C criada com data inicial em 01/06/2026 (posterior ao lançamento de 05/05/2026)
        final contaC = await contaRepository.create(
          CreateContaDto(
            descricao: 'Conta C',
            bancoSigla: 'C6',
            ativo: true,
            dataInicial: DateTime(2026, 6, 1),
          ),
        );
        final origemContaC = LancamentoOrigem.conta(
          contaId: contaC.getOrThrow().id,
        );

        final res = await updateOrigemGrupoUseCase.execute(
          lancamentoId: l1.id,
          novaOrigem: origemContaC,
        );

        expect(res.isError(), isTrue);
        expect(
          res.exceptionOrNull().toString(),
          contains('anterior à data inicial'),
        );
      },
    );
  });
}
