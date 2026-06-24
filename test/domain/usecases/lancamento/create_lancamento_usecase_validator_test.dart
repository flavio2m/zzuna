import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';
import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import 'package:zzuna/data/repositories/lancamento/extrato_fatura_repository.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/domain/dtos/conta/create_conta_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_dto.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_item_entity.dart';
import 'package:zzuna/domain/usecases/lancamento/create_lancamento_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/resolve_extrato_fatura_usecase.dart';
import 'package:zzuna/domain/validators/lancamento_validator.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';

import '../../../helpers/test_storage.dart';

void main() {
  late ContaRepository contaRepository;
  late CartaoRepository cartaoRepository;
  late ExtratoFaturaRepository extratoRepository;
  late LancamentoRepository lancamentoRepository;
  late CreateLancamentoUseCase useCase;

  late LancamentoOrigem origemConta;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});

    contaRepository = ContaRepository(createTestContaStorage());
    cartaoRepository = CartaoRepository(createTestCartaoStorage());
    extratoRepository = ExtratoFaturaRepository(createTestExtratoFaturaStorage());
    lancamentoRepository = LancamentoRepository(createTestLancamentoStorage());

    final resolveUseCase = ResolveExtratoFaturaUseCase(
      extratoRepository,
      contaRepository,
      cartaoRepository,
    );

    useCase = CreateLancamentoUseCase(
      resolveUseCase,
      lancamentoRepository,
      LancamentoValidator(),
    );

    final contaResult = await contaRepository.create(
      CreateContaDto(
        descricao: 'Conta Principal',
        bancoSigla: 'BB',
        ativo: true,
        dataInicial: DateTime(2026, 1, 1),
      ),
    );
    origemConta = LancamentoOrigem.conta(contaId: contaResult.getOrThrow().id);
  });

  tearDown(() {
    contaRepository.dispose();
    cartaoRepository.dispose();
    extratoRepository.dispose();
    lancamentoRepository.dispose();
  });

  group('CreateLancamentoUseCase – validação', () {
    test('DTO com descrição vazia retorna Failure antes de resolver extrato', () async {
      final dto = LancamentoDto(
        tipo: LancamentoTipo.despesa,
        descricao: '',
        origem: origemConta,
        data: DateTime(2026, 6, 10),
        itens: [
          LancamentoItem(id: 'item-1', categoriaId: 'cat-1', centroCustoId: 'cc-1', valor: 100),
        ],
      );

      final result = await useCase.execute(dto);
      expect(result.isError(), isTrue);
    });

    test('DTO sem itens retorna Failure antes de resolver extrato', () async {
      final dto = LancamentoDto(
        tipo: LancamentoTipo.despesa,
        descricao: 'Supermercado',
        origem: origemConta,
        data: DateTime(2026, 6, 10),
        itens: [],
      );

      final result = await useCase.execute(dto);
      expect(result.isError(), isTrue);
    });

    test('DTO com item de valor 0 retorna Failure', () async {
      final dto = LancamentoDto(
        tipo: LancamentoTipo.despesa,
        descricao: 'Supermercado',
        origem: origemConta,
        data: DateTime(2026, 6, 10),
        itens: [
          LancamentoItem(id: 'item-1', categoriaId: 'cat-1', centroCustoId: 'cc-1', valor: 0),
        ],
      );

      final result = await useCase.execute(dto);
      expect(result.isError(), isTrue);
    });

    test('DTO válido persiste o lançamento com extrato criado automaticamente', () async {
      // ResolveExtratoFaturaUseCase cria o extrato automaticamente quando não existe.
      // Portanto um DTO válido deve resultar em Success.
      final dto = LancamentoDto(
        tipo: LancamentoTipo.despesa,
        descricao: 'Supermercado',
        origem: origemConta,
        data: DateTime(2026, 6, 10),
        itens: [
          LancamentoItem(id: 'item-1', categoriaId: 'cat-1', centroCustoId: 'cc-1', valor: 150),
        ],
      );

      final result = await useCase.execute(dto);
      expect(result.isSuccess(), isTrue);
      expect(result.getOrThrow().extratoFaturaId, isNotEmpty);
    });
  });
}
