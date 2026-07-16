import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';
import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import 'package:zzuna/data/repositories/lancamento/extrato_fatura_repository.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/domain/dtos/conta/create_conta_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/extrato_fatura_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/resolve_extrato_fatura_dto.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/usecases/lancamento/delete_lancamento_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/recalculate_extrato_fatura_balance_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/resolve_extrato_fatura_usecase.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_grupo.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_item.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';
import '../../../helpers/test_storage.dart';

void main() {
  late ContaRepository contaRepository;
  late CartaoRepository cartaoRepository;
  late ExtratoFaturaRepository extratoRepository;
  late LancamentoRepository lancamentoRepository;
  late ResolveExtratoFaturaUseCase resolveUseCase;
  late RecalculateExtratoFaturaBalanceUseCase recalculateUseCase;
  late DeleteLancamentoUseCase useCase;

  late LancamentoOrigem origemConta;
  late LancamentoOrigem origemConta2;

  // Helper: cria um lançamento simples já com extrato resolvido
  Future<Lancamento> criarLancamento({
    required LancamentoOrigem origem,
    required DateTime data,
    double valor = 100.0,
    LancamentoTipo tipo = LancamentoTipo.despesa,
    LancamentoGrupo? grupo,
  }) async {
    final dto = LancamentoDto(
      descricao: 'Teste',
      origem: origem,
      data: data,
      tipo: tipo,
      grupo: grupo,
      itens: [
        LancamentoItem(
          numero: 1,
          categoriaId: 'cat-1',
          centroCustoId: 'cc-1',
          valor: valor,
        ),
      ],
    );
    final extrato = await resolveUseCase.execute(
      ResolveExtratoFaturaDto(
        origem: origem,
        data: data,
        valor: valor,
        tipo: tipo,
      ),
    );
    dto.setExtratoFaturaId(extrato.getOrThrow().id);
    final result = await lancamentoRepository.create(dto);
    return result.getOrThrow();
  }

  // Helper: fecha extrato por id
  Future<void> fecharExtrato(String extratoFaturaId) async {
    final e = (await extratoRepository.getById(extratoFaturaId)).getOrThrow();
    await extratoRepository.update(
      ExtratoFaturaDto(
        id: e.id,
        origem: e.origem,
        ano: e.ano,
        mes: e.mes,
        dataInicio: e.dataInicio,
        dataFim: e.dataFim,
        saldoInicial: e.saldoInicial,
        saldoFinal: e.saldoFinal,
        fechado: true,
      ),
    );
  }

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

    recalculateUseCase = RecalculateExtratoFaturaBalanceUseCase(
      extratoRepository,
      lancamentoRepository,
    );

    useCase = DeleteLancamentoUseCase(
      lancamentoRepository,
      extratoRepository,
      recalculateUseCase,
    );

    final c1 = await contaRepository.create(
      CreateContaDto(
        descricao: 'Conta 1',
        bancoSigla: 'BB',
        ativo: true,
        dataInicial: DateTime(2026, 1, 1),
      ),
    );
    origemConta = LancamentoOrigem.conta(contaId: c1.getOrThrow().id);

    final c2 = await contaRepository.create(
      CreateContaDto(
        descricao: 'Conta 2',
        bancoSigla: 'NU',
        ativo: true,
        dataInicial: DateTime(2026, 1, 1),
      ),
    );
    origemConta2 = LancamentoOrigem.conta(contaId: c2.getOrThrow().id);
  });

  tearDown(() {
    contaRepository.dispose();
    cartaoRepository.dispose();
    extratoRepository.dispose();
    lancamentoRepository.dispose();
  });

  group('DeleteLancamentoUseCase', () {
    test(
      'Deve excluir lançamento simples e recalcular saldo para zero',
      () async {
        // Cria lançamento de R$100 de despesa
        final lancamento = await criarLancamento(
          origem: origemConta,
          data: DateTime(2026, 6, 10),
          valor: 100,
        );

        // Saldo final antes = -100
        final extratoAntes = (await extratoRepository.getById(
          lancamento.extratoFaturaId,
        )).getOrThrow();
        expect(extratoAntes.saldoFinal, equals(-100.0));

        // Exclui
        final result = await useCase.execute(lancamento.id);
        expect(result.isSuccess(), isTrue);

        // Lançamento não existe mais
        final busca = await lancamentoRepository.getById(lancamento.id);
        expect(busca.isError(), isTrue);

        // Saldo deve ter voltado para 0
        final extratoDepois = (await extratoRepository.getById(
          lancamento.extratoFaturaId,
        )).getOrThrow();
        expect(extratoDepois.saldoFinal, equals(0.0));
      },
    );

    test('Deve falhar ao excluir lançamento de período fechado', () async {
      final lancamento = await criarLancamento(
        origem: origemConta,
        data: DateTime(2026, 6, 10),
      );

      await fecharExtrato(lancamento.extratoFaturaId);

      final result = await useCase.execute(lancamento.id);
      expect(result.isError(), isTrue);
      expect(
        result.exceptionOrNull().toString(),
        contains('período encerrado'),
      );
    });

    test(
      'Deve propagar delta para meses futuros ao excluir lançamento',
      () async {
        // Cria lançamento em junho/2026 com valor 200 (despesa)
        final lancamentoJunho = await criarLancamento(
          origem: origemConta,
          data: DateTime(2026, 6, 10),
          valor: 200,
        );

        // Saldo extrato junho antes: saldoInicial(0) - 200 = -200
        final extratoJunhoAntes = (await extratoRepository.getById(
          lancamentoJunho.extratoFaturaId,
        )).getOrThrow();
        expect(extratoJunhoAntes.saldoFinal, closeTo(-200.0, 0.001));

        // Cria lançamento em julho para gerar extrato futuro
        final lancamentoJulho = await criarLancamento(
          origem: origemConta,
          data: DateTime(2026, 7, 10),
          valor: 50,
        );

        // Valida que o saldo inicial de julho reflete o final de junho
        final extratoJulhoAntes = (await extratoRepository.getById(
          lancamentoJulho.extratoFaturaId,
        )).getOrThrow();
        expect(extratoJulhoAntes.saldoInicial, closeTo(-200.0, 0.001));

        // Exclui lançamento de junho
        final result = await useCase.execute(lancamentoJunho.id);
        expect(result.isSuccess(), isTrue);

        // Saldo de junho após exclusão: 0
        final extratoJunhoDepois = (await extratoRepository.getById(
          lancamentoJunho.extratoFaturaId,
        )).getOrThrow();
        expect(extratoJunhoDepois.saldoFinal, closeTo(0.0, 0.001));

        // O delta (+200) deve ter se propagado para julho
        final extratoJulhoDepois = (await extratoRepository.getById(
          lancamentoJulho.extratoFaturaId,
        )).getOrThrow();
        expect(extratoJulhoDepois.saldoInicial, closeTo(0.0, 0.001));
      },
    );

    test(
      'Deve excluir as duas pontas de uma transferência ao excluir "este"',
      () async {
        const grupoId = 'grupo-transf-1';
        final grupo = LancamentoGrupo.transferencia(grupoId: grupoId);

        // Ponta 1: saída da Conta 1
        final saidaConta1 = await criarLancamento(
          origem: origemConta,
          data: DateTime(2026, 6, 15),
          valor: 300,
          tipo: LancamentoTipo.transferencia,
          grupo: grupo,
        );

        // Ponta 2: entrada na Conta 2
        final entradaConta2 = await criarLancamento(
          origem: origemConta2,
          data: DateTime(2026, 6, 15),
          valor: 300,
          tipo: LancamentoTipo.transferencia,
          grupo: grupo,
        );

        // Exclui apenas um dos dois (deve deletar ambos)
        final result = await useCase.execute(saidaConta1.id);
        expect(result.isSuccess(), isTrue);

        // Ambos devem ter sido excluídos
        final busca1 = await lancamentoRepository.getById(saidaConta1.id);
        final busca2 = await lancamentoRepository.getById(entradaConta2.id);
        expect(busca1.isError(), isTrue);
        expect(busca2.isError(), isTrue);
      },
    );

    test(
      'excluirTodos = true deve excluir o lançamento atual e futuros do grupo, mas não o passado',
      () async {
        const grupoId = 'grupo-parcela-1';
        final grupo = LancamentoGrupo.parcelamento(
          grupoId: grupoId,
          parcela: 1,
          totalParcelas: 3,
        );
        final grupo2 = LancamentoGrupo.parcelamento(
          grupoId: grupoId,
          parcela: 2,
          totalParcelas: 3,
        );
        final grupo3 = LancamentoGrupo.parcelamento(
          grupoId: grupoId,
          parcela: 3,
          totalParcelas: 3,
        );

        // Parcela 1 – maio (passado)
        final parcela1 = await criarLancamento(
          origem: origemConta,
          data: DateTime(2026, 5, 10),
          valor: 100,
          grupo: grupo,
        );

        // Parcela 2 – junho (presente — será o ponto de exclusão)
        final parcela2 = await criarLancamento(
          origem: origemConta,
          data: DateTime(2026, 6, 10),
          valor: 100,
          grupo: grupo2,
        );

        // Parcela 3 – julho (futuro)
        final parcela3 = await criarLancamento(
          origem: origemConta,
          data: DateTime(2026, 7, 10),
          valor: 100,
          grupo: grupo3,
        );

        // Exclui todos a partir da parcela 2
        final result = await useCase.execute(parcela2.id, excluirTodos: true);
        expect(result.isSuccess(), isTrue);

        // Parcela 1 (maio) deve sobreviver
        final busca1 = await lancamentoRepository.getById(parcela1.id);
        expect(busca1.isSuccess(), isTrue);

        // Parcela 2 e 3 devem ter sido excluídas
        final busca2 = await lancamentoRepository.getById(parcela2.id);
        final busca3 = await lancamentoRepository.getById(parcela3.id);
        expect(busca2.isError(), isTrue);
        expect(busca3.isError(), isTrue);
      },
    );

    test(
      'excluirTodos = true deve falhar se algum lançamento futuro do grupo estiver em período fechado',
      () async {
        const grupoId = 'grupo-bloqueado-1';
        final grupo1 = LancamentoGrupo.parcelamento(
          grupoId: grupoId,
          parcela: 1,
          totalParcelas: 2,
        );
        final grupo2 = LancamentoGrupo.parcelamento(
          grupoId: grupoId,
          parcela: 2,
          totalParcelas: 2,
        );

        // Parcela 1 – junho (aberta)
        final parcela1 = await criarLancamento(
          origem: origemConta,
          data: DateTime(2026, 6, 10),
          valor: 100,
          grupo: grupo1,
        );

        // Parcela 2 – julho (fechada)
        final parcela2 = await criarLancamento(
          origem: origemConta,
          data: DateTime(2026, 7, 10),
          valor: 100,
          grupo: grupo2,
        );
        await fecharExtrato(parcela2.extratoFaturaId);

        // Tenta excluir todos a partir da parcela 1
        final result = await useCase.execute(parcela1.id, excluirTodos: true);
        expect(result.isError(), isTrue);
        expect(
          result.exceptionOrNull().toString(),
          contains('período encerrado'),
        );
      },
    );
  });
}
