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
import 'package:zzuna/domain/usecases/lancamento/update_lancamentos_itens_grupo_usecase.dart';
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
  late UpdateLancamentosItensGrupoUseCase updateItensGrupoUseCase;
  late LocalStorage<Lancamento> lancamentoStorage;
  late LocalStorage<ExtratoFatura> extratoStorage;

  late LancamentoOrigem origemConta;
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

    updateItensGrupoUseCase = UpdateLancamentosItensGrupoUseCase(
      recalculateUseCase,
      lancamentoRepository,
      extratoRepository,
    );

    dataInicialConta = DateTime(2026, 1, 1);

    final conta = await contaRepository.create(
      CreateContaDto(
        descricao: 'Conta Principal',
        bancoSigla: 'BB',
        ativo: true,
        dataInicial: dataInicialConta,
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

  group('UpdateLancamentosItensGrupoUseCase Tests', () {
    test(
      'Should update items cascadingly and recalculate balances when total value changes',
      () async {
        // Parcela 1: 05/05/2026 (Value: 10.0)
        final l1 = (await createLancamentoUseCase.execute(
          LancamentoDto(
            tipo: LancamentoTipo.despesa,
            descricao: 'Parcela 1/3',
            origem: origemConta,
            data: DateTime(2026, 5, 5),
            grupo: const LancamentoGrupo.parcelamento(
              grupoId: 'grupo-abc',
              parcela: 1,
              totalParcelas: 3,
            ),
            itens: [
              LancamentoItem(
                numero: 1,
                categoriaId: 'cat-old',
                centroCustoId: 'cc-old',
                valor: 10.0,
              ),
            ],
          ),
        )).getOrThrow();

        // Parcela 2: 05/06/2026 (Value: 10.0) (referência)
        final l2 = (await createLancamentoUseCase.execute(
          LancamentoDto(
            tipo: LancamentoTipo.despesa,
            descricao: 'Parcela 2/3',
            origem: origemConta,
            data: DateTime(2026, 6, 5),
            grupo: const LancamentoGrupo.parcelamento(
              grupoId: 'grupo-abc',
              parcela: 2,
              totalParcelas: 3,
            ),
            itens: [
              LancamentoItem(
                numero: 1,
                categoriaId: 'cat-old',
                centroCustoId: 'cc-old',
                valor: 10.0,
              ),
            ],
          ),
        )).getOrThrow();

        // Parcela 3: 05/07/2026 (Value: 10.0)
        final l3 = (await createLancamentoUseCase.execute(
          LancamentoDto(
            tipo: LancamentoTipo.despesa,
            descricao: 'Parcela 3/3',
            origem: origemConta,
            data: DateTime(2026, 7, 5),
            grupo: const LancamentoGrupo.parcelamento(
              grupoId: 'grupo-abc',
              parcela: 3,
              totalParcelas: 3,
            ),
            itens: [
              LancamentoItem(
                numero: 1,
                categoriaId: 'cat-old',
                centroCustoId: 'cc-old',
                valor: 10.0,
              ),
            ],
          ),
        )).getOrThrow();

        // Novos itens: categoria: cat-new, cc: cc-new, valor total: 25.0
        // Item 1 = 15.0, Item 2 = 10.0
        final novosItens = [
          LancamentoItem(
            numero: 1,
            categoriaId: 'cat-new',
            centroCustoId: 'cc-new',
            valor: 15.0,
          ),
          LancamentoItem(
            numero: 2,
            categoriaId: 'cat-new',
            centroCustoId: 'cc-new',
            valor: 10.0,
          ),
        ];

        final res = await updateItensGrupoUseCase.execute(
          lancamentoId: l2.id,
          novosItens: novosItens,
        );

        expect(res.isSuccess(), isTrue);

        // Parcela 1 não deve ter sido alterada (data anterior a Parcela 2)
        final updatedL1 = (await lancamentoRepository.getById(
          l1.id,
        )).getOrThrow();
        expect(updatedL1.itens.length, 1);
        expect(updatedL1.itens.first.categoriaId, 'cat-old');
        expect(updatedL1.itens.first.valor, 10.0);

        // Parcela 2 deve ter sido alterada
        final updatedL2 = (await lancamentoRepository.getById(
          l2.id,
        )).getOrThrow();
        expect(updatedL2.itens.length, 2);
        expect(updatedL2.itens.first.categoriaId, 'cat-new');
        expect(updatedL2.itens.first.valor, 15.0);
        expect(updatedL2.itens.last.valor, 10.0);
        expect(updatedL2.anoMes, equals(l2.anoMes));

        // Parcela 3 deve ter sido alterada
        final updatedL3 = (await lancamentoRepository.getById(
          l3.id,
        )).getOrThrow();
        expect(updatedL3.itens.length, 2);
        expect(updatedL3.itens.first.categoriaId, 'cat-new');
        expect(updatedL3.itens.first.valor, 15.0);
        expect(updatedL3.itens.last.valor, 10.0);
        expect(updatedL3.anoMes, equals(l3.anoMes));

        // Saldos dos extratos devem ter sido recalculados
        // Mês 05: saldoInicial = 0, despesa = 10.0 => saldoFinal = -10.0
        // Mês 06: saldoInicial = -10.0, despesa = 25.0 => saldoFinal = -35.0
        // Mês 07: saldoInicial = -35.0, despesa = 25.0 => saldoFinal = -60.0
        final extrato5 = (await extratoRepository.getById(
          l1.extratoFaturaId,
        )).getOrThrow();
        expect(extrato5.saldoFinal, -10.0);

        final extrato6 = (await extratoRepository.getById(
          l2.extratoFaturaId,
        )).getOrThrow();
        expect(extrato6.saldoFinal, -35.0);

        final extrato7 = (await extratoRepository.getById(
          l3.extratoFaturaId,
        )).getOrThrow();
        expect(extrato7.saldoFinal, -60.0);
      },
    );

    test('Should fail if any target launch is reconciled', () async {
      // Parcela 1 (referência)
      final l1 = (await createLancamentoUseCase.execute(
        LancamentoDto(
          tipo: LancamentoTipo.despesa,
          descricao: 'Parcela 1/2',
          origem: origemConta,
          data: DateTime(2026, 5, 5),
          grupo: const LancamentoGrupo.parcelamento(
            grupoId: 'grupo-xyz',
            parcela: 1,
            totalParcelas: 2,
          ),
          itens: [
            LancamentoItem(
              numero: 1,
              categoriaId: 'cat-old',
              centroCustoId: 'cc-old',
              valor: 10.0,
            ),
          ],
        ),
      )).getOrThrow();

      // Parcela 2 (conciliada)
      final l2 = (await createLancamentoUseCase.execute(
        LancamentoDto(
          tipo: LancamentoTipo.despesa,
          descricao: 'Parcela 2/2',
          origem: origemConta,
          data: DateTime(2026, 6, 5),
          grupo: const LancamentoGrupo.parcelamento(
            grupoId: 'grupo-xyz',
            parcela: 2,
            totalParcelas: 2,
          ),
          itens: [
            LancamentoItem(
              numero: 1,
              categoriaId: 'cat-old',
              centroCustoId: 'cc-old',
              valor: 10.0,
            ),
          ],
        ),
      )).getOrThrow();

      // Marcar l2 como conciliada
      final dto2 = LancamentoDto.fromEntity(l2)..setConciliado(true);
      await lancamentoRepository.update(dto2);

      final res = await updateItensGrupoUseCase.execute(
        lancamentoId: l1.id,
        novosItens: [
          LancamentoItem(
            numero: 1,
            categoriaId: 'cat-new',
            centroCustoId: 'cc-new',
            valor: 15.0,
          ),
        ],
      );

      expect(res.isError(), isTrue);
      expect(
        res.exceptionOrNull().toString(),
        contains('Não é possível alterar itens de lançamentos conciliados.'),
      );
    });
  });
}
