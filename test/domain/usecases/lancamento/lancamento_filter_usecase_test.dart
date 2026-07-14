import 'package:flutter_test/flutter_test.dart';
import 'package:zzuna/domain/dtos/lancamento/lancamento_filter_dto.dart';
import 'package:zzuna/domain/entities/cartao_entity.dart';
import 'package:zzuna/domain/entities/conta_entity.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/entities/lancamento/extrato_fatura_entity.dart';
import 'package:zzuna/domain/enums/mes.dart';
import 'package:zzuna/domain/statics/banco/banco.dart';
import 'package:zzuna/domain/statics/banco/banco_regiao.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem_detail.dart';
import 'package:zzuna/domain/usecases/lancamento/lancamento_filter_usecase.dart';

void main() {
  group('LancamentoFilterUseCase Tests', () {
    late LancamentoFilterUseCase filterUseCase;

    setUp(() {
      filterUseCase = LancamentoFilterUseCase();
    });

    final conta1 = ContaDetails(
      id: 'conta-1',
      descricao: 'Conta 1',
      ativo: true,
      banco: const Banco(
        descricao: 'Banco 1',
        sigla: 'B1',
        icon: BancoIcon.outros,
        regiao: RegiaoBanco.brasil,
      ),
      dataInicial: DateTime(2026, 1, 1),
    );

    final conta2 = ContaDetails(
      id: 'conta-2',
      descricao: 'Conta 2',
      ativo: true,
      banco: const Banco(
        descricao: 'Banco 2',
        sigla: 'B2',
        icon: BancoIcon.outros,
        regiao: RegiaoBanco.brasil,
      ),
      dataInicial: DateTime(2026, 1, 1),
    );

    final cartao1 = CartaoDetails(
      id: 'cartao-1',
      descricao: 'Cartao 1',
      ativo: true,
      limite: 1000.0,
      banco: const Banco(
        descricao: 'Banco 1',
        sigla: 'B1',
        icon: BancoIcon.outros,
        regiao: RegiaoBanco.brasil,
      ),
      diaFechamento: 5,
      dataInicial: DateTime(2026, 1, 1),
    );

    final extratoFake = ExtratoFaturaDetails(
      id: 'ef-1',
      origem: LancamentoOrigemContaDetail(conta: conta1),
      ano: 2026,
      mes: Mes.junho,
      dataInicio: DateTime(2026, 6, 1),
      dataFim: DateTime(2026, 6, 30),
      saldoInicial: 0.0,
      saldoFinal: 0.0,
      fechado: false,
    );

    LancamentoDetails buildLancamento({
      required String id,
      required LancamentoOrigemDetail origem,
    }) {
      return LancamentoDetails(
        id: id,
        tipo: LancamentoTipo.despesa,
        data: DateTime(2026, 6, 15),
        descricao: 'Lancamento $id',
        extratoFatura: extratoFake,
        origem: origem,
        itens: const [],
        conciliado: true,
        anoMes: 202606,
      );
    }

    test('should filter by conta only', () {
      final list = [
        buildLancamento(
          id: '1',
          origem: LancamentoOrigemContaDetail(conta: conta1),
        ),
        buildLancamento(
          id: '2',
          origem: LancamentoOrigemContaDetail(conta: conta2),
        ),
        buildLancamento(
          id: '3',
          origem: LancamentoOrigemCartaoDetail(cartao: cartao1),
        ),
      ];

      final filter = LancamentoFilterDto(
        mes: Mes.junho,
        ano: 2026,
        contasSelecionadas: {'conta-1'},
      );

      final result = filterUseCase.execute(list, filter);

      expect(result, hasLength(1));
      expect(result.first.id, '1');
    });

    test('should filter by cartao only', () {
      final list = [
        buildLancamento(
          id: '1',
          origem: LancamentoOrigemContaDetail(conta: conta1),
        ),
        buildLancamento(
          id: '2',
          origem: LancamentoOrigemContaDetail(conta: conta2),
        ),
        buildLancamento(
          id: '3',
          origem: LancamentoOrigemCartaoDetail(cartao: cartao1),
        ),
      ];

      final filter = LancamentoFilterDto(
        mes: Mes.junho,
        ano: 2026,
        cartoesSelecionados: {'cartao-1'},
      );

      final result = filterUseCase.execute(list, filter);

      expect(result, hasLength(1));
      expect(result.first.id, '3');
    });

    test(
      'should filter by both accounts and cards additively (OR condition)',
      () {
        final list = [
          buildLancamento(
            id: '1',
            origem: LancamentoOrigemContaDetail(conta: conta1),
          ),
          buildLancamento(
            id: '2',
            origem: LancamentoOrigemContaDetail(conta: conta2),
          ),
          buildLancamento(
            id: '3',
            origem: LancamentoOrigemCartaoDetail(cartao: cartao1),
          ),
        ];

        final filter = LancamentoFilterDto(
          mes: Mes.junho,
          ano: 2026,
          contasSelecionadas: {'conta-1'},
          cartoesSelecionados: {'cartao-1'},
        );

        final result = filterUseCase.execute(list, filter);

        // Should return both Lancamento 1 (Conta 1) and Lancamento 3 (Cartao 1)
        expect(result, hasLength(2));
        expect(result.any((item) => item.id == '1'), isTrue);
        expect(result.any((item) => item.id == '3'), isTrue);
        expect(result.any((item) => item.id == '2'), isFalse);
      },
    );
  });
}
