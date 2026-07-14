import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';
import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import 'package:zzuna/data/repositories/lancamento/extrato_fatura_repository.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/domain/dtos/conta/create_conta_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/extrato_fatura_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_dto.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_item.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_grupo.dart';
import 'package:zzuna/domain/usecases/lancamento/create_lancamento_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/recalculate_extrato_fatura_balance_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/resolve_extrato_fatura_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/update_lancamentos_data_grupo_usecase.dart';
import 'package:zzuna/domain/validators/lancamento_validator.dart';

import 'package:zzuna/data/services/storage/local/local_storage.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/entities/lancamento/extrato_fatura_entity.dart';
import 'package:zzuna/domain/dtos/cartao/cartao_dto.dart';

import '../../../helpers/test_storage.dart';

void main() {
  late ContaRepository contaRepository;
  late CartaoRepository cartaoRepository;
  late ExtratoFaturaRepository extratoRepository;
  late LancamentoRepository lancamentoRepository;
  late ResolveExtratoFaturaUseCase resolveUseCase;
  late RecalculateExtratoFaturaBalanceUseCase recalculateUseCase;
  late CreateLancamentoUseCase createLancamentoUseCase;
  late UpdateLancamentosDataGrupoUseCase updateDataGrupoUseCase;
  late LocalStorage<Lancamento> lancamentoStorage;
  late LocalStorage<ExtratoFatura> extratoStorage;

  late LancamentoOrigem origemConta;
  late LancamentoOrigem origemCartaoTest;
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

    updateDataGrupoUseCase = UpdateLancamentosDataGrupoUseCase(
      resolveUseCase,
      recalculateUseCase,
      lancamentoRepository,
      extratoRepository,
      contaRepository,
      cartaoRepository,
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

    final cartaoResult = await cartaoRepository.create(
      CartaoDto(
        descricao: 'Cartão 1',
        limite: 1000,
        bancoSigla: 'NUB',
        diaFechamento: 12,
        ativo: true,
        dataInicial: DateTime(2026, 1, 1),
      ),
    );
    origemCartaoTest = LancamentoOrigem.cartao(
      cartaoId: cartaoResult.getOrThrow().id,
    );
  });

  tearDown(() {
    contaRepository.dispose();
    cartaoRepository.dispose();
    extratoRepository.dispose();
    lancamentoRepository.dispose();
  });

  group('UpdateLancamentosDataGrupoUseCase Tests', () {
    test('Should shift dates cascadingly and preserve monthly spacing', () async {
      // Parcela 1: 05/05/2026
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
              categoriaId: 'cat-1',
              centroCustoId: 'cc-1',
              valor: 10.0,
            ),
          ],
        ),
      )).getOrThrow();

      // Parcela 2: 05/06/2026 (referência)
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
              categoriaId: 'cat-1',
              centroCustoId: 'cc-1',
              valor: 10.0,
            ),
          ],
        ),
      )).getOrThrow();

      // Parcela 3: 05/07/2026
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
              categoriaId: 'cat-1',
              centroCustoId: 'cc-1',
              valor: 10.0,
            ),
          ],
        ),
      )).getOrThrow();

      // Mudar a data do l2 para 25/07/2026 (avança 1 mês e muda dia para 25)
      final res = await updateDataGrupoUseCase.execute(
        lancamentoId: l2.id,
        novaData: DateTime(2026, 7, 25),
      );
      expect(res.isSuccess(), isTrue);

      final check1 = (await lancamentoRepository.getById(l1.id)).getOrThrow();
      final check2 = (await lancamentoRepository.getById(l2.id)).getOrThrow();
      final check3 = (await lancamentoRepository.getById(l3.id)).getOrThrow();

      // Parcela 1: 05/05/2026 (desconsiderado porque é anterior a l2)
      expect(check1.data, DateTime(2026, 5, 5));

      // Parcela 2: 25/07/2026 (atualizado)
      expect(check2.data, DateTime(2026, 7, 25));

      // Parcela 3: 25/08/2026 (atualizado mantendo espaçamento de +1 mês de l2)
      expect(check3.data, DateTime(2026, 8, 25));
    });

    test(
      'Should handle moving reference launch to an earlier month than its original month',
      () async {
        // A: 05/07/2026
        final la = (await createLancamentoUseCase.execute(
          LancamentoDto(
            tipo: LancamentoTipo.despesa,
            descricao: 'Lancamento A',
            origem: origemConta,
            data: DateTime(2026, 7, 5),
            grupo: const LancamentoGrupo.replicacao(
              grupoId: 'grupo-replicado',
              parcela: 1,
              totalParcelas: 5,
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

        // B: 05/08/2026 (ref)
        final lb = (await createLancamentoUseCase.execute(
          LancamentoDto(
            tipo: LancamentoTipo.despesa,
            descricao: 'Lancamento B',
            origem: origemConta,
            data: DateTime(2026, 8, 5),
            grupo: const LancamentoGrupo.replicacao(
              grupoId: 'grupo-replicado',
              parcela: 2,
              totalParcelas: 5,
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

        // C: 05/09/2026
        final lc = (await createLancamentoUseCase.execute(
          LancamentoDto(
            tipo: LancamentoTipo.despesa,
            descricao: 'Lancamento C',
            origem: origemConta,
            data: DateTime(2026, 9, 5),
            grupo: const LancamentoGrupo.replicacao(
              grupoId: 'grupo-replicado',
              parcela: 3,
              totalParcelas: 5,
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

        // D: 05/10/2026
        final ld = (await createLancamentoUseCase.execute(
          LancamentoDto(
            tipo: LancamentoTipo.despesa,
            descricao: 'Lancamento D',
            origem: origemConta,
            data: DateTime(2026, 10, 5),
            grupo: const LancamentoGrupo.replicacao(
              grupoId: 'grupo-replicado',
              parcela: 4,
              totalParcelas: 5,
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

        // E: 05/11/2026
        final le = (await createLancamentoUseCase.execute(
          LancamentoDto(
            tipo: LancamentoTipo.despesa,
            descricao: 'Lancamento E',
            origem: origemConta,
            data: DateTime(2026, 11, 5),
            grupo: const LancamentoGrupo.replicacao(
              grupoId: 'grupo-replicado',
              parcela: 5,
              totalParcelas: 5,
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

        // Mudar a data do lb (B) para 29/07/2026
        final res = await updateDataGrupoUseCase.execute(
          lancamentoId: lb.id,
          novaData: DateTime(2026, 7, 29),
        );
        expect(res.isSuccess(), isTrue);

        final checkA = (await lancamentoRepository.getById(la.id)).getOrThrow();
        final checkB = (await lancamentoRepository.getById(lb.id)).getOrThrow();
        final checkC = (await lancamentoRepository.getById(lc.id)).getOrThrow();
        final checkD = (await lancamentoRepository.getById(ld.id)).getOrThrow();
        final checkE = (await lancamentoRepository.getById(le.id)).getOrThrow();

        // A: deve continuar 05/07 (não alterada pois é anterior à data do ref B)
        expect(checkA.data, DateTime(2026, 7, 5));

        // B: deve ser 29/07
        expect(checkB.data, DateTime(2026, 7, 29));

        // C: deve ser 29/08 (B + 1 mês)
        expect(checkC.data, DateTime(2026, 8, 29));

        // D: deve ser 29/09 (B + 2 meses)
        expect(checkD.data, DateTime(2026, 9, 29));

        // E: deve ser 29/10 (B + 3 meses)
        expect(checkE.data, DateTime(2026, 10, 29));
      },
    );

    test(
      'Should clamp days to last day of month if the target day does not exist',
      () async {
        // Parcela 1 (referência): 31/07/2026
        final l1 = (await createLancamentoUseCase.execute(
          LancamentoDto(
            tipo: LancamentoTipo.despesa,
            descricao: 'Parcela 1/2',
            origem: origemConta,
            data: DateTime(2026, 7, 31),
            grupo: const LancamentoGrupo.parcelamento(
              grupoId: 'grupo-clamp',
              parcela: 1,
              totalParcelas: 2,
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

        // Parcela 2: 31/08/2026
        final l2 = (await createLancamentoUseCase.execute(
          LancamentoDto(
            tipo: LancamentoTipo.despesa,
            descricao: 'Parcela 2/2',
            origem: origemConta,
            data: DateTime(2026, 8, 31),
            grupo: const LancamentoGrupo.parcelamento(
              grupoId: 'grupo-clamp',
              parcela: 2,
              totalParcelas: 2,
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

        // Mudar a data do l1 para 31/10/2026 (avança 3 meses)
        // O l2 (Parcela 2) avançará para Novembro (mês 11), que só tem 30 dias.
        // Deve ficar: Parcela 1 em 31/10/2026 e Parcela 2 em 30/11/2026.
        final res = await updateDataGrupoUseCase.execute(
          lancamentoId: l1.id,
          novaData: DateTime(2026, 10, 31),
        );
        expect(res.isSuccess(), isTrue);

        final check1 = (await lancamentoRepository.getById(l1.id)).getOrThrow();
        final check2 = (await lancamentoRepository.getById(l2.id)).getOrThrow();

        expect(check1.data, DateTime(2026, 10, 31));
        expect(check2.data, DateTime(2026, 11, 30));
      },
    );

    test(
      'Should return Failure if any of the target launches resides in a closed period',
      () async {
        final l1 = (await createLancamentoUseCase.execute(
          LancamentoDto(
            tipo: LancamentoTipo.despesa,
            descricao: 'Parcela 1',
            origem: origemConta,
            data: DateTime(2026, 5, 5),
            grupo: const LancamentoGrupo.parcelamento(
              grupoId: 'grupo-closed',
              parcela: 1,
              totalParcelas: 2,
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

        final l2 = (await createLancamentoUseCase.execute(
          LancamentoDto(
            tipo: LancamentoTipo.despesa,
            descricao: 'Parcela 2',
            origem: origemConta,
            data: DateTime(2026, 6, 5),
            grupo: const LancamentoGrupo.parcelamento(
              grupoId: 'grupo-closed',
              parcela: 2,
              totalParcelas: 2,
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

        // Fechar o extrato do l2
        final l2Extrato = (await extratoRepository.getById(
          l2.extratoFaturaId,
        )).getOrThrow();
        final dto = ExtratoFaturaDto(
          id: l2Extrato.id,
          origem: l2Extrato.origem,
          ano: l2Extrato.ano,
          mes: l2Extrato.mes,
          dataInicio: l2Extrato.dataInicio,
          dataFim: l2Extrato.dataFim,
          saldoInicial: l2Extrato.saldoInicial,
          saldoFinal: l2Extrato.saldoFinal,
          fechado: true,
        );
        await extratoRepository.update(dto);

        // Tentar atualizar a data do grupo a partir de l1 (deverá falhar porque l2 está em período fechado)
        final res = await updateDataGrupoUseCase.execute(
          lancamentoId: l1.id,
          novaData: DateTime(2026, 5, 25),
        );

        expect(res.isError(), isTrue);
        expect(
          res.exceptionOrNull()!.toString(),
          contains(
            'Não é possível editar lançamentos de um período encerrado.',
          ),
        );
      },
    );
    test(
      'Should change extratoFaturaIds properly when moving cartao dates across diaFechamento boundaries in a group',
      () async {
        final origemCartao = origemCartaoTest;

        // P1: 15/07/2026 (Falls on 07/2026 invoice)
        final l1 = (await createLancamentoUseCase.execute(
          LancamentoDto(
            tipo: LancamentoTipo.despesa,
            descricao: 'Parcela 1/2 CC',
            origem: origemCartao,
            data: DateTime(2026, 7, 15),
            grupo: const LancamentoGrupo.parcelamento(
              grupoId: 'grupo-cc',
              parcela: 1,
              totalParcelas: 2,
            ),
            itens: [
              LancamentoItem(
                numero: 1,
                categoriaId: 'cat-1',
                centroCustoId: 'cc-1',
                valor: 100.0,
              ),
            ],
          ),
        )).getOrThrow();

        // P2: 15/08/2026 (Falls on 08/2026 invoice)
        final l2 = (await createLancamentoUseCase.execute(
          LancamentoDto(
            tipo: LancamentoTipo.despesa,
            descricao: 'Parcela 2/2 CC',
            origem: origemCartao,
            data: DateTime(2026, 8, 15),
            grupo: const LancamentoGrupo.parcelamento(
              grupoId: 'grupo-cc',
              parcela: 2,
              totalParcelas: 2,
            ),
            itens: [
              LancamentoItem(
                numero: 1,
                categoriaId: 'cat-1',
                centroCustoId: 'cc-1',
                valor: 100.0,
              ),
            ],
          ),
        )).getOrThrow();

        // Let's verify initial invoices
        final e1Initial = (await extratoRepository.getById(
          l1.extratoFaturaId,
        )).getOrThrow();
        expect(e1Initial.mes.numero, 7);
        final e2Initial = (await extratoRepository.getById(
          l2.extratoFaturaId,
        )).getOrThrow();
        expect(e2Initial.mes.numero, 8);

        // Update P1 to 11/07/2026.
        // 11 < 12 (diaFechamento). Therefore P1 moves to 06/2026.
        // P2 should cascade to 11/08/2026. 11 < 12. P2 moves to 07/2026.
        final res = await updateDataGrupoUseCase.execute(
          lancamentoId: l1.id,
          novaData: DateTime(2026, 7, 11),
        );
        expect(res.isSuccess(), isTrue);

        final updatedL1 = (await lancamentoRepository.getById(
          l1.id,
        )).getOrThrow();
        final updatedL2 = (await lancamentoRepository.getById(
          l2.id,
        )).getOrThrow();

        // Retrieve new extratos
        final e1New = (await extratoRepository.getById(
          updatedL1.extratoFaturaId,
        )).getOrThrow();
        final e2New = (await extratoRepository.getById(
          updatedL2.extratoFaturaId,
        )).getOrThrow();

        // Assert they moved to June and July invoices respectively
        expect(e1New.mes.numero, 6);
        expect(e1New.ano, 2026);

        expect(e2New.mes.numero, 7);
        expect(e2New.ano, 2026);
      },
    );
  });
}
