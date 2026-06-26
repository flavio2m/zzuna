import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zzuna/domain/enums/lancamento_tipo.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';
import 'package:zzuna/domain/dtos/conta/create_conta_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_dto.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_item.dart';
import 'package:zzuna/domain/usecases/lancamento/resolve_extrato_fatura_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/create_lancamento_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/reconcile_lancamentos_usecase.dart';
import 'package:zzuna/domain/validators/lancamento_validator.dart';
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
  late ReconcileLancamentosUseCase reconcileUseCase;

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

    resolveUseCase = ResolveExtratoFaturaUseCase(extratoRepository, contaRepository, cartaoRepository);

    createLancamentoUseCase = CreateLancamentoUseCase(resolveUseCase, lancamentoRepository, LancamentoValidator());

    reconcileUseCase = ReconcileLancamentosUseCase(lancamentoRepository);

    dataInicialConta = DateTime(2026, 1, 1);

    final conta = await contaRepository.create(
      CreateContaDto(descricao: 'Conta Principal', bancoSigla: 'BB', ativo: true, dataInicial: dataInicialConta),
    );

    origemConta = LancamentoOrigem.conta(contaId: conta.getOrThrow().id);
  });

  tearDown(() {
    contaRepository.dispose();
    cartaoRepository.dispose();
    extratoRepository.dispose();
    lancamentoRepository.dispose();
  });

  group('ReconcileLancamentosUseCase Tests', () {
    test('Should successfully reconcile a single launch', () async {
      // 1. Criar um lançamento não conciliado
      final createRes = await createLancamentoUseCase.execute(
        LancamentoDto(
          tipo: LancamentoTipo.despesa,
          descricao: 'Mercado',
          origem: origemConta,
          data: DateTime(2026, 1, 5),
          itens: [LancamentoItem(numero: 1, categoriaId: 'cat-1', centroCustoId: 'cc-1', valor: 150.0)],
        ),
      );
      final created = createRes.getOrThrow();
      expect(created.conciliado, isFalse);

      // 2. Conciliar o lançamento
      final reconcileRes = await reconcileUseCase.execute(ids: [created.id], conciliado: true);
      expect(reconcileRes.isSuccess(), isTrue);

      // 3. Verificar no repositório se o status mudou
      final updated = (await lancamentoRepository.getById(created.id)).getOrThrow();
      expect(updated.conciliado, isTrue);
    });

    test('Should successfully desconciliar a single launch', () async {
      // 1. Criar um lançamento
      final createRes = await createLancamentoUseCase.execute(
        LancamentoDto(
          tipo: LancamentoTipo.despesa,
          descricao: 'Mercado',
          origem: origemConta,
          data: DateTime(2026, 1, 5),
          itens: [LancamentoItem(numero: 1, categoriaId: 'cat-1', centroCustoId: 'cc-1', valor: 150.0)],
        ),
      );
      final created = createRes.getOrThrow();

      // 2. Conciliar
      await reconcileUseCase.execute(ids: [created.id], conciliado: true);

      // 3. Desconciliar
      final desconciliarRes = await reconcileUseCase.execute(ids: [created.id], conciliado: false);
      expect(desconciliarRes.isSuccess(), isTrue);

      // 4. Verificar no repositório
      final updated = (await lancamentoRepository.getById(created.id)).getOrThrow();
      expect(updated.conciliado, isFalse);
    });

    test('Should successfully reconcile multiple launches in batch', () async {
      // 1. Criar dois lançamentos
      final l1 = (await createLancamentoUseCase.execute(
        LancamentoDto(
          tipo: LancamentoTipo.receita,
          descricao: 'Receita 1',
          origem: origemConta,
          data: DateTime(2026, 1, 5),
          itens: [LancamentoItem(numero: 1, categoriaId: 'cat-1', centroCustoId: 'cc-1', valor: 100.0)],
        ),
      )).getOrThrow();

      final l2 = (await createLancamentoUseCase.execute(
        LancamentoDto(
          tipo: LancamentoTipo.despesa,
          descricao: 'Despesa 1',
          origem: origemConta,
          data: DateTime(2026, 1, 10),
          itens: [LancamentoItem(numero: 1, categoriaId: 'cat-1', centroCustoId: 'cc-1', valor: 50.0)],
        ),
      )).getOrThrow();

      expect(l1.conciliado, isFalse);
      expect(l2.conciliado, isFalse);

      // 2. Conciliar ambos em lote
      final reconcileRes = await reconcileUseCase.execute(ids: [l1.id, l2.id], conciliado: true);
      expect(reconcileRes.isSuccess(), isTrue);

      // 3. Verificar no repositório
      final updatedL1 = (await lancamentoRepository.getById(l1.id)).getOrThrow();
      final updatedL2 = (await lancamentoRepository.getById(l2.id)).getOrThrow();
      expect(updatedL1.conciliado, isTrue);
      expect(updatedL2.conciliado, isTrue);
    });

    test('Should ignore redundant state changes and return Success', () async {
      // 1. Criar um lançamento
      final l1 = (await createLancamentoUseCase.execute(
        LancamentoDto(
          tipo: LancamentoTipo.receita,
          descricao: 'Receita 1',
          origem: origemConta,
          data: DateTime(2026, 1, 5),
          itens: [LancamentoItem(numero: 1, categoriaId: 'cat-1', centroCustoId: 'cc-1', valor: 100.0)],
        ),
      )).getOrThrow();

      // Já está desconciliado. Chamar execute para desconciliar novamente
      final res = await reconcileUseCase.execute(ids: [l1.id], conciliado: false);

      expect(res.isSuccess(), isTrue);
      final check = (await lancamentoRepository.getById(l1.id)).getOrThrow();
      expect(check.conciliado, isFalse);
    });

    test('Should return Failure and make no changes if any ID is not found', () async {
      // 1. Criar um lançamento
      final l1 = (await createLancamentoUseCase.execute(
        LancamentoDto(
          tipo: LancamentoTipo.receita,
          descricao: 'Receita 1',
          origem: origemConta,
          data: DateTime(2026, 1, 5),
          itens: [LancamentoItem(numero: 1, categoriaId: 'cat-1', centroCustoId: 'cc-1', valor: 100.0)],
        ),
      )).getOrThrow();

      // 2. Chamar execute com ID válido e um ID inexistente
      final res = await reconcileUseCase.execute(ids: [l1.id, 'id-inexistente'], conciliado: true);

      // Deve falhar
      expect(res.isError(), isTrue);
      expect(res.exceptionOrNull()!.toString(), contains('Lançamento com ID id-inexistente não encontrado.'));

      // Verificar que o lançamento original NÃO foi atualizado (garantia de consistência/atomicidade antes do updateAll)
      final check = (await lancamentoRepository.getById(l1.id)).getOrThrow();
      expect(check.conciliado, isFalse);
    });
  });
}
