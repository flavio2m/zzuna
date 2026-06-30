import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/enums/lancamento_tipo.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem.dart';
import 'package:zzuna/domain/dtos/conta/create_conta_dto.dart';
import 'package:zzuna/domain/dtos/conta/loaded_conta_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/extrato_fatura_dto.dart';
import 'package:zzuna/domain/dtos/lancamento/resolve_extrato_fatura_lote_dto.dart';
import 'package:zzuna/domain/usecases/lancamento/resolve_extrato_faturas_usecase.dart';
import 'package:zzuna/data/repositories/conta/conta_repository.dart';
import 'package:zzuna/data/repositories/cartao/cartao_repository.dart';
import 'package:zzuna/data/repositories/lancamento/extrato_fatura_repository.dart';

import 'package:zzuna/data/services/storage/local/local_storage.dart';
import 'package:zzuna/domain/entities/lancamento/extrato_fatura_entity.dart';
import '../../../helpers/test_storage.dart';

void main() {
  late ContaRepository contaRepository;
  late CartaoRepository cartaoRepository;
  late ExtratoFaturaRepository extratoRepository;
  late ResolveExtratoFaturasUseCase resolveUseCase;
  late LocalStorage<ExtratoFatura> extratoStorage;

  late LancamentoOrigem origemConta;
  late DateTime dataInicialConta;

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
    final contaStorage = createTestContaStorage();
    final cartaoStorage = createTestCartaoStorage();
    extratoStorage = createTestExtratoFaturaStorage();

    contaRepository = ContaRepository(contaStorage);
    cartaoRepository = CartaoRepository(cartaoStorage);
    extratoRepository = ExtratoFaturaRepository(extratoStorage);

    resolveUseCase = ResolveExtratoFaturasUseCase(extratoRepository, contaRepository, cartaoRepository);

    dataInicialConta = DateTime(2026, 1, 1); // Conta criada em Janeiro 2026

    final conta = await contaRepository.create(
      CreateContaDto(descricao: 'Conta Principal', bancoSigla: 'BB', ativo: true, dataInicial: dataInicialConta),
    );

    origemConta = LancamentoOrigem.conta(contaId: conta.getOrThrow().id);
  });

  tearDown(() {
    contaRepository.dispose();
    cartaoRepository.dispose();
    extratoRepository.dispose();
  });

  group('ResolveExtratoFaturasUseCase Tests', () {
    test('Should throw error when resolving a period before dataInicial', () async {
      final dto = ResolveExtratoFaturaLoteDto(
        itens: [
          ResolveExtratoFaturaItemDto(
            origem: origemConta,
            data: DateTime(2025, 12, 31), // Antes de 01/01/2026
            valor: 100.0,
            tipo: LancamentoTipo.despesa,
          ),
        ],
      );

      final res = await resolveUseCase.execute(dto);
      expect(res.isError(), isTrue);
      expect(res.exceptionOrNull()!.toString(), contains('não pode ser anterior à data inicial'));
    });

    test('Should group deltas for the same period correctly', () async {
      final dto = ResolveExtratoFaturaLoteDto(
        itens: [
          ResolveExtratoFaturaItemDto(
            origem: origemConta,
            data: DateTime(2026, 1, 15),
            valor: 100.0,
            tipo: LancamentoTipo.receita, // +100
          ),
          ResolveExtratoFaturaItemDto(
            origem: origemConta,
            data: DateTime(2026, 1, 20),
            valor: 40.0,
            tipo: LancamentoTipo.despesa, // -40
          ),
        ],
      );

      final res = await resolveUseCase.execute(dto);
      expect(res.isSuccess(), isTrue);

      final list = res.getOrThrow();
      expect(list, hasLength(1));

      final extrato = list.first;
      expect(extrato.mes, Mes.janeiro);
      expect(extrato.saldoInicial, 0.0);
      expect(extrato.saldoFinal, 60.0); // +100 - 40 = 60
    });

    test('Should inherit saldoFinal of previous statement and propagate delta future-wards', () async {
      // 1. Criar extrato para Janeiro de 2026
      await extratoRepository.create(
        ExtratoFaturaDto(
          origem: origemConta,
          ano: 2026,
          mes: Mes.janeiro,
          dataInicio: DateTime(2026, 1, 1),
          dataFim: DateTime(2026, 1, 31),
          saldoInicial: 50.0,
          saldoFinal: 100.0,
          fechado: false,
        ),
      );

      // 2. Criar extrato para Março de 2026
      await extratoRepository.create(
        ExtratoFaturaDto(
          origem: origemConta,
          ano: 2026,
          mes: Mes.marco,
          dataInicio: DateTime(2026, 3, 1),
          dataFim: DateTime(2026, 3, 31),
          saldoInicial: 100.0,
          saldoFinal: 150.0,
          fechado: false,
        ),
      );

      // 3. Novo lote: item em Fevereiro 2026 (não existe extrato no DB ainda) e em Março 2026
      final lote = ResolveExtratoFaturaLoteDto(
        itens: [
          ResolveExtratoFaturaItemDto(
            origem: origemConta,
            data: DateTime(2026, 2, 15),
            valor: 30.0,
            tipo: LancamentoTipo.receita, // +30 em Fev
          ),
          ResolveExtratoFaturaItemDto(
            origem: origemConta,
            data: DateTime(2026, 3, 10),
            valor: 20.0,
            tipo: LancamentoTipo.despesa, // -20 em Mar
          ),
        ],
      );

      final res = await resolveUseCase.execute(lote);
      expect(res.isSuccess(), isTrue);

      final list = res.getOrThrow();
      // Retorna Fev e Mar resolvidos (ou propagados)
      expect(list.length, greaterThanOrEqualTo(2));

      // Buscar do repositório para validar o estado final persistido
      final all = (await extratoStorage.getAll()).getOrThrow()..sort((a, b) => a.periodo.compareTo(b.periodo));

      expect(all, hasLength(3)); // Jan, Fev, Mar

      // Jan: inalterado
      expect(all[0].mes, Mes.janeiro);
      expect(all[0].saldoInicial, 50.0);
      expect(all[0].saldoFinal, 100.0);

      // Fev: herdou saldoInicial de Jan (100.0). Aplicou delta +30. saldoFinal = 130.0
      expect(all[1].mes, Mes.fevereiro);
      expect(all[1].saldoInicial, 100.0);
      expect(all[1].saldoFinal, 130.0);

      // Mar: herdou saldoInicial acumulado propagado de Fev (130.0). Aplicou seu delta -20. saldoFinal = 110.0 (anteriormente era 150 - 20 = 130?)
      // Espera: saldoInicial de Mar original era 100. Propagou +30 de Fev -> saldoInicial de Mar vira 130.
      // Em seguida, aplicou delta -20 de Mar -> saldoFinal vira 110 (original era 150 + 30 - 20 = 160).
      // Espera: saldoFinal de Mar = original 150 + 30 (propagate de Fev) - 20 (delta de Mar) = 160.
      // Vamos verificar:
      expect(all[2].mes, Mes.marco);
      expect(all[2].saldoInicial, 130.0);
      expect(all[2].saldoFinal, 160.0);
    });

    test('Should return failure when the resolved extrato is closed', () async {
      // 1. Criar um extrato fechado para Janeiro de 2026
      await extratoRepository.create(
        ExtratoFaturaDto(
          origem: origemConta,
          ano: 2026,
          mes: Mes.janeiro,
          dataInicio: DateTime(2026, 1, 1),
          dataFim: DateTime(2026, 1, 31),
          saldoInicial: 1000.0,
          saldoFinal: 1000.0,
          fechado: true, // fechado!
        ),
      );

      // Ajustar dataInicial para permitir esse mês
      final conta = (await contaRepository.getAll()).getOrThrow().first;
      await contaRepository.update(
        LoadedContaDto(
          id: conta.id,
          descricao: conta.descricao,
          bancoSigla: conta.bancoSigla,
          ativo: conta.ativo,
          dataInicial: DateTime(2026, 1, 1),
        ),
      );

      final dto = ResolveExtratoFaturaLoteDto(
        itens: [
          ResolveExtratoFaturaItemDto(
            origem: origemConta,
            data: DateTime(2026, 1, 15),
            valor: 100.0,
            tipo: LancamentoTipo.despesa,
          ),
        ],
      );

      final res = await resolveUseCase.execute(dto);
      expect(res.isError(), isTrue);
      expect(
        res.exceptionOrNull()!.toString(),
        contains('Não é possível registrar lançamentos em um período encerrado.'),
      );
    });

    test('Should return failure when any future period in the timeline is closed', () async {
      // 1. Criar extrato aberto para Janeiro de 2026
      await extratoRepository.create(
        ExtratoFaturaDto(
          origem: origemConta,
          ano: 2026,
          mes: Mes.janeiro,
          dataInicio: DateTime(2026, 1, 1),
          dataFim: DateTime(2026, 1, 31),
          saldoInicial: 1000.0,
          saldoFinal: 1000.0,
          fechado: false,
        ),
      );

      // 2. Criar extrato FECHADO para Fevereiro de 2026 (período futuro)
      await extratoRepository.create(
        ExtratoFaturaDto(
          origem: origemConta,
          ano: 2026,
          mes: Mes.fevereiro,
          dataInicio: DateTime(2026, 2, 1),
          dataFim: DateTime(2026, 2, 28),
          saldoInicial: 1000.0,
          saldoFinal: 1000.0,
          fechado: true, // FECHADO!
        ),
      );

      // Ajustar dataInicial para permitir esses meses
      final conta = (await contaRepository.getAll()).getOrThrow().first;
      await contaRepository.update(
        LoadedContaDto(
          id: conta.id,
          descricao: conta.descricao,
          bancoSigla: conta.bancoSigla,
          ativo: conta.ativo,
          dataInicial: DateTime(2026, 1, 1),
        ),
      );

      // Lançamento em Janeiro de 2026 (deve propagar para Fevereiro que está fechado)
      final dto = ResolveExtratoFaturaLoteDto(
        itens: [
          ResolveExtratoFaturaItemDto(
            origem: origemConta,
            data: DateTime(2026, 1, 15),
            valor: 100.0,
            tipo: LancamentoTipo.despesa,
          ),
        ],
      );

      final res = await resolveUseCase.execute(dto);
      expect(res.isError(), isTrue);
      expect(
        res.exceptionOrNull()!.toString(),
        contains('Não é possível registrar lançamentos em um período encerrado.'),
      );
    });
  });
}
