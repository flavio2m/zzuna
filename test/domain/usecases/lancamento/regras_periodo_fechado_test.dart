import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';
import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import 'package:zzuna/data/repositories/lancamento/extrato_fatura_repository.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/domain/dtos/conta/create_conta_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_dto.dart';
import 'package:zzuna/domain/enums/lancamento_tipo.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/usecases/lancamento/create_lancamento_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/fechar_mes_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/reconcile_lancamentos_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/resolve_extrato_fatura_usecase.dart';
import 'package:zzuna/domain/validators/lancamento_validator.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_item.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';

import '../../../helpers/test_storage.dart';

void main() {
  late ContaRepository contaRepository;
  late CartaoRepository cartaoRepository;
  late ExtratoFaturaRepository extratoRepository;
  late LancamentoRepository lancamentoRepository;
  late ResolveExtratoFaturaUseCase resolveUseCase;
  late CreateLancamentoUseCase createLancamentoUseCase;
  late FecharMesUseCase fecharMesUseCase;
  late ReconcileLancamentosUseCase reconcileUseCase;

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
      LancamentoValidator(),
    );

    fecharMesUseCase = FecharMesUseCase(
      contaRepository,
      cartaoRepository,
      extratoRepository,
      lancamentoRepository,
    );

    reconcileUseCase = ReconcileLancamentosUseCase(
      lancamentoRepository,
      extratoRepository,
    );
  });

  test('Regras de período fechado para conciliação e novos lançamentos', () async {
    // Passo 1: Criar Conta A e um lançamento no mês 05/2026
    final dataInicialContaA = DateTime(2026, 5, 1);
    final contaARes = await contaRepository.create(
      CreateContaDto(
        descricao: 'Conta A',
        bancoSigla: 'BB',
        ativo: true,
        dataInicial: dataInicialContaA,
      ),
    );
    final contaA = contaARes.getOrThrow();
    final origemContaA = LancamentoOrigem.conta(contaId: contaA.id);

    final dataLancamento = DateTime(2026, 5, 15);
    final createRes = await createLancamentoUseCase.execute(
      LancamentoDto(
        tipo: LancamentoTipo.despesa,
        data: dataLancamento,
        descricao: 'Lançamento Teste Fechamento',
        origem: origemContaA,
        itens: [
          const LancamentoItem(
            numero: 1,
            centroCustoId: 'cc1',
            categoriaId: 'cat1',
            valor: 100.0,
          ),
        ],
        conciliado: false,
      ),
    );
    expect(createRes.isSuccess(), isTrue);
    final lancamento = createRes.getOrThrow();

    // Passo 2: Marcar o lançamento como conciliado
    final reconcileRes = await reconcileUseCase.execute(
      ids: [lancamento.id],
      conciliado: true,
    );
    expect(reconcileRes.isSuccess(), isTrue);

    // Passo 3: Fechar o mês 05/2026 (deve fechar com sucesso)
    final fecharRes = await fecharMesUseCase.execute(Mes.maio, 2026);
    expect(fecharRes.isSuccess(), isTrue);

    // Teste 1: Tentar alterar o status do lançamento de Conciliado para Não Conciliado
    final unconcileRes = await reconcileUseCase.execute(
      ids: [lancamento.id],
      conciliado: false,
    );
    expect(unconcileRes.isError(), isTrue);
    expect(
      unconcileRes.exceptionOrNull().toString(),
      contains('encerrado'),
    );

    // Teste 2: Criar uma nova conta B com data inicial em 01/05/2026 e fazer um novo lançamento nela
    final contaBRes = await contaRepository.create(
      CreateContaDto(
        descricao: 'Conta B',
        bancoSigla: 'NU',
        ativo: true,
        dataInicial: DateTime(2026, 5, 1),
      ),
    );
    final contaB = contaBRes.getOrThrow();
    final origemContaB = LancamentoOrigem.conta(contaId: contaB.id);

    final createContaBRes = await createLancamentoUseCase.execute(
      LancamentoDto(
        tipo: LancamentoTipo.despesa,
        data: DateTime(2026, 5, 20),
        descricao: 'Lançamento em nova conta em mês fechado',
        origem: origemContaB,
        itens: [
          const LancamentoItem(
            numero: 1,
            centroCustoId: 'cc1',
            categoriaId: 'cat1',
            valor: 50.0,
          ),
        ],
        conciliado: false,
      ),
    );
    expect(createContaBRes.isError(), isTrue);
    expect(
      createContaBRes.exceptionOrNull().toString(),
      contains('encerrado'),
    );
  });
}
