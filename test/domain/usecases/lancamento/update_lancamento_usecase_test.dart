import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';
import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import 'package:zzuna/data/repositories/lancamento/extrato_fatura_repository.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/domain/dtos/conta/create_conta_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/resolve_extrato_fatura_dto.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_item.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';
import 'package:zzuna/domain/dtos/lancamento/extrato_fatura_dto.dart';
import 'package:zzuna/domain/usecases/lancamento/resolve_extrato_fatura_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/recalculate_extrato_fatura_balance_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/update_lancamento_usecase.dart';
import 'package:zzuna/domain/validators/lancamento_validator.dart';

import 'package:zzuna/data/services/storage/local/local_storage.dart';
import 'package:zzuna/domain/entities/lancamento/extrato_fatura_entity.dart';
import '../../../helpers/test_storage.dart';

void main() {
  late ContaRepository contaRepository;
  late CartaoRepository cartaoRepository;
  late ExtratoFaturaRepository extratoRepository;
  late LancamentoRepository lancamentoRepository;
  late ResolveExtratoFaturaUseCase resolveUseCase;
  late RecalculateExtratoFaturaBalanceUseCase recalculateUseCase;
  late UpdateLancamentoUseCase useCase;
  late LocalStorage<ExtratoFatura> extratoStorage;

  late LancamentoOrigem origemConta;
  late LancamentoOrigem origemConta2;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});

    final contaStorage = createTestContaStorage();
    final cartaoStorage = createTestCartaoStorage();
    extratoStorage = createTestExtratoFaturaStorage();
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

    useCase = UpdateLancamentoUseCase(
      resolveUseCase,
      recalculateUseCase,
      lancamentoRepository,
      extratoRepository,
      LancamentoValidator(),
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

  group('UpdateLancamentoUseCase tests', () {
    test('Should return failure when ID is missing', () async {
      final dto = LancamentoDto(
        descricao: 'Teste',
        origem: origemConta,
        itens: [
          LancamentoItem(
            numero: 1,
            categoriaId: 'cat-1',
            centroCustoId: 'cc-1',
            valor: 100,
          ),
        ],
      );
      final result = await useCase.execute(dto);
      expect(result.isError(), isTrue);
      expect(
        result.exceptionOrNull().toString(),
        contains('ID do lançamento é obrigatório'),
      );
    });

    test('Should return failure when item value is <= 0', () async {
      // 1. Create a launch first
      final createDto = LancamentoDto(
        descricao: 'Original',
        origem: origemConta,
        data: DateTime(2026, 6, 10),
        itens: [
          LancamentoItem(
            numero: 1,
            categoriaId: 'cat-1',
            centroCustoId: 'cc-1',
            valor: 100,
          ),
        ],
      );

      // Resolve extrato manually so it can create the extrato
      final extrato = await resolveUseCase.execute(
        ResolveExtratoFaturaDto(
          origem: origemConta,
          data: createDto.data,
          valor: 100,
          tipo: createDto.tipo,
        ),
      );
      createDto.setExtratoFaturaId(extrato.getOrThrow().id);

      final original = await lancamentoRepository.create(createDto);
      final originalId = original.getOrThrow().id;

      // 2. Try to update with a zero-value item
      final updateDto = LancamentoDto(
        id: originalId,
        descricao: 'Original',
        origem: origemConta,
        data: DateTime(2026, 6, 10),
        itens: [
          LancamentoItem(
            numero: 1,
            categoriaId: 'cat-1',
            centroCustoId: 'cc-1',
            valor: 0,
          ),
        ],
      );

      final result = await useCase.execute(updateDto);
      expect(result.isError(), isTrue);
      expect(
        result.exceptionOrNull().toString(),
        contains('valor maior que zero'),
      );
    });

    test(
      'Should return failure if original extrato period is closed',
      () async {
        // 1. Create launch
        final createDto = LancamentoDto(
          descricao: 'Original',
          origem: origemConta,
          data: DateTime(2026, 6, 10),
          itens: [
            LancamentoItem(
              numero: 1,
              categoriaId: 'cat-1',
              centroCustoId: 'cc-1',
              valor: 100,
            ),
          ],
        );
        final extrato = await resolveUseCase.execute(
          ResolveExtratoFaturaDto(
            origem: origemConta,
            data: createDto.data,
            valor: 100,
            tipo: createDto.tipo,
          ),
        );
        final extratoEntity = extrato.getOrThrow();
        createDto.setExtratoFaturaId(extratoEntity.id);
        final original = await lancamentoRepository.create(createDto);

        // Close the extrato
        final updatedExtrato = extratoEntity.copyWith(fechado: true);
        await extratoRepository.update(
          ExtratoFaturaDto(
            id: updatedExtrato.id,
            origem: updatedExtrato.origem,
            ano: updatedExtrato.ano,
            mes: updatedExtrato.mes,
            dataInicio: updatedExtrato.dataInicio,
            dataFim: updatedExtrato.dataFim,
            saldoInicial: updatedExtrato.saldoInicial,
            saldoFinal: updatedExtrato.saldoFinal,
            fechado: updatedExtrato.fechado,
          ),
        );

        // 2. Try to edit
        final updateDto = LancamentoDto(
          id: original.getOrThrow().id,
          descricao: 'Editado',
          origem: origemConta,
          data: DateTime(2026, 6, 10),
          itens: [
            LancamentoItem(
              numero: 1,
              categoriaId: 'cat-1',
              centroCustoId: 'cc-1',
              valor: 150,
            ),
          ],
        );

        final result = await useCase.execute(updateDto);
        expect(result.isError(), isTrue);
        expect(
          result.exceptionOrNull().toString(),
          contains('Não é possível editar lançamentos de um período encerrado'),
        );
      },
    );

    test(
      'Should succeed when DTO is valid, and recalculate balances for old and new origins',
      () async {
        // 1. Create original launch in Conta 1
        final createDto = LancamentoDto(
          descricao: 'Original',
          origem: origemConta,
          data: DateTime(2026, 6, 10),
          itens: [
            LancamentoItem(
              numero: 1,
              categoriaId: 'cat-1',
              centroCustoId: 'cc-1',
              valor: 100,
            ),
          ],
        );
        final extrato = await resolveUseCase.execute(
          ResolveExtratoFaturaDto(
            origem: origemConta,
            data: createDto.data,
            valor: 100,
            tipo: createDto.tipo,
          ),
        );
        final extratoEntity = extrato.getOrThrow();
        createDto.setExtratoFaturaId(extratoEntity.id);
        final original = await lancamentoRepository.create(createDto);
        final originalId = original.getOrThrow().id;

        // 2. Update launch to Conta 2 and change value to 150
        final updateDto = LancamentoDto(
          id: originalId,
          descricao: 'Alterado',
          origem: origemConta2,
          data: DateTime(2026, 6, 15),
          itens: [
            LancamentoItem(
              numero: 1,
              categoriaId: 'cat-1',
              centroCustoId: 'cc-1',
              valor: 150,
            ),
          ],
        );

        final result = await useCase.execute(updateDto);
        expect(result.isSuccess(), isTrue);

        final updatedEntity = result.getOrThrow();
        expect(updatedEntity.descricao, equals('Alterado'));
        expect(updatedEntity.origem, equals(origemConta2));

        // 3. Verify balance recalculation in storages
        final allExtratosRes = await extratoStorage.getAll();
        final allExtratos = allExtratosRes.getOrThrow();

        // Old extrato (Conta 1) should have saldoFinal = 0.0 (since launch was moved out)
        final oldExtratoInDb = allExtratos.firstWhere(
          (e) => e.origem == origemConta,
        );
        expect(oldExtratoInDb.saldoFinal, equals(0.0));

        // New extrato (Conta 2) should have saldoFinal = -150.0 (since it was Despesa of 150)
        final newExtratoInDb = allExtratos.firstWhere(
          (e) => e.origem == origemConta2,
        );
        expect(newExtratoInDb.saldoFinal, equals(-150.0));
      },
    );
  });
}
