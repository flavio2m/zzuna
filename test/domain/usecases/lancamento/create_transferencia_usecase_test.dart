import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';
import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import 'package:zzuna/data/repositories/lancamento/extrato_fatura_repository.dart';
import 'package:zzuna/data/repositories/lancamento/lancamento_repository.dart';
import 'package:zzuna/domain/dtos/conta/create_conta_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/create_transferencia_dto.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_item.dart';
import 'package:zzuna/domain/usecases/lancamento/create_lancamentos_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/create_transferencia_usecase.dart';
import 'package:zzuna/domain/usecases/lancamento/resolve_extrato_faturas_usecase.dart';
import 'package:zzuna/domain/validators/lancamento_validator.dart';
import 'package:zzuna/domain/validators/transferencia_validator.dart';

import 'package:zzuna/data/services/storage/local/local_storage.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import '../../../helpers/test_storage.dart';

void main() {
  late ContaRepository contaRepository;
  late ExtratoFaturaRepository extratoRepository;
  late LancamentoRepository lancamentoRepository;
  late ResolveExtratoFaturasUseCase resolveUseCase;
  late CreateLancamentosUseCase createLancamentosUseCase;
  late CreateTransferenciaUseCase createTransferenciaUseCase;

  late LocalStorage<Lancamento> lancamentoStorage;

  late LancamentoOrigem origemA;
  late LancamentoOrigem origemB;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final contaStorage = createTestContaStorage();
    final cartaoStorage = createTestCartaoStorage();
    final extratoStorage = createTestExtratoFaturaStorage();
    lancamentoStorage = createTestLancamentoStorage();

    contaRepository = ContaRepository(contaStorage);
    extratoRepository = ExtratoFaturaRepository(extratoStorage);
    lancamentoRepository = LancamentoRepository(lancamentoStorage);

    resolveUseCase = ResolveExtratoFaturasUseCase(
      extratoRepository,
      contaRepository,
      CartaoRepository(cartaoStorage),
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

    final contaA = await contaRepository.create(
      CreateContaDto(
        descricao: 'Conta A',
        bancoSigla: 'BB',
        ativo: true,
        dataInicial: DateTime(2026, 1, 1),
      ),
    );

    final contaB = await contaRepository.create(
      CreateContaDto(
        descricao: 'Conta B',
        bancoSigla: 'ITAU',
        ativo: true,
        dataInicial: DateTime(2026, 1, 1),
      ),
    );

    origemA = LancamentoOrigem.conta(contaId: contaA.getOrThrow().id);
    origemB = LancamentoOrigem.conta(contaId: contaB.getOrThrow().id);
  });

  tearDown(() {
    contaRepository.dispose();
    extratoRepository.dispose();
    lancamentoRepository.dispose();
  });

  group('CreateTransferenciaUseCase Tests', () {
    test(
      'Should create transfer successfully and adjust balances of both accounts',
      () async {
        final res = await createTransferenciaUseCase.execute(
          CreateTransferenciaDto(
            data: DateTime(2026, 1, 15),
            descricao: 'Transferência Pix',
            valor: 100.0,
            origemSaida: origemA,
            origemEntrada: origemB,
            observacao: 'Obs Pix',
          ),
        );

        expect(res.isSuccess(), isTrue);

        final launchesRes = await lancamentoStorage.getAll();
        final launches = launchesRes.getOrThrow();
        expect(launches.length, 2);

        final launchSaida = launches.firstWhere((l) => l.origem == origemA);
        final launchEntrada = launches.firstWhere((l) => l.origem == origemB);

        // Check common properties
        expect(launchSaida.descricao, 'Transferência Pix');
        expect(launchEntrada.descricao, 'Transferência Pix');
        expect(launchSaida.tipo, LancamentoTipo.transferencia);
        expect(launchEntrada.tipo, LancamentoTipo.transferencia);
        expect(launchSaida.grupo, isNotNull);
        expect(launchEntrada.grupo, isNotNull);
        expect(launchSaida.grupo!.grupoId, launchEntrada.grupo!.grupoId);
        expect(launchSaida.grupo!.grupoId.isNotEmpty, isTrue);

        // Check items structure
        expect(launchSaida.itens.length, 1);
        final itemSaida = launchSaida.itens.first;
        switch (itemSaida) {
          case LancamentoItemTransferencia(
            :final numero,
            :final origemSaida,
            :final origemEntrada,
            :final valor,
          ):
            expect(numero, 1);
            expect(origemSaida, origemA);
            expect(origemEntrada, origemB);
            expect(valor, 100.0);
          default:
            fail('Should be a transfer item');
        }

        // Verify resolved extrato balances
        final extratoARes = await extratoRepository.searchByPeriodo(
          origemA,
          2026,
          Mes.janeiro,
        );
        final extratoBRes = await extratoRepository.searchByPeriodo(
          origemB,
          2026,
          Mes.janeiro,
        );

        final extratoA = extratoARes.getOrThrow().first;
        final extratoB = extratoBRes.getOrThrow().first;

        // Account A had a transfer out, so saldoFinal should be negative (saldoInicial is 0.0)
        expect(extratoA.saldoFinal, -100.0);

        // Account B had a transfer in, so saldoFinal should be positive
        expect(extratoB.saldoFinal, 100.0);
      },
    );

    test('Should fail if origin equals destination', () async {
      final res = await createTransferenciaUseCase.execute(
        CreateTransferenciaDto(
          data: DateTime(2026, 1, 15),
          descricao: 'Transferência Pix',
          valor: 100.0,
          origemSaida: origemA,
          origemEntrada: origemA,
        ),
      );

      expect(res.isError(), isTrue);
      expect(
        res.exceptionOrNull().toString(),
        contains('A conta/cartão de origem deve ser diferente do destino'),
      );
    });

    test('Should fail if value is less than or equal to zero', () async {
      final res = await createTransferenciaUseCase.execute(
        CreateTransferenciaDto(
          data: DateTime(2026, 1, 15),
          descricao: 'Transferência Pix',
          valor: 0.0,
          origemSaida: origemA,
          origemEntrada: origemB,
        ),
      );

      expect(res.isError(), isTrue);
      expect(
        res.exceptionOrNull().toString(),
        contains('O valor deve ser maior que zero'),
      );
    });
  });
}
