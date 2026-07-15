import 'package:flutter_test/flutter_test.dart';
import 'package:zzuna/domain/exceptions/domain_exception.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_item.dart';
import 'package:zzuna/domain/usecases/lancamento/lancamento_item_distribution_usecase.dart';

void main() {
  late LancamentoItemDistributionUseCase useCase;

  setUp(() {
    useCase = LancamentoItemDistributionUseCase();
  });

  group('LancamentoItemDistributionUseCase Tests', () {
    test('Should add item and recalculate Item 1 correctly', () {
      final currentItems = [
        const LancamentoItem(
          numero: 1,
          centroCustoId: 'cc-1',
          categoriaId: 'cat-1',
          valor: 100.0, //
        ),
      ];

      final res = useCase.addItem(
        currentItems: currentItems,
        totalValor: 100.0,
        centroCustoId: 'cc-2',
        categoriaId: 'cat-2',
        itemValor: 30.0,
      );

      expect(res.isSuccess(), isTrue);
      final updatedList = res.getOrThrow();
      expect(updatedList, hasLength(2));

      final item1 = updatedList.firstWhere((e) => e.numero == 1);
      final item2 = updatedList.firstWhere((e) => e.numero == 2);

      expect(item1.valor, 70.0);
      expect(item2.valor, 30.0);
      expect(item2.centroCustoId, 'cc-2');
      expect(item2.categoriaId, 'cat-2');
    });

    test('Should edit item and recalculate Item 1 correctly', () {
      final currentItems = [
        const LancamentoItem(
          numero: 1,
          centroCustoId: 'cc-1',
          categoriaId: 'cat-1',
          valor: 70.0, //
        ),
        const LancamentoItem(
          numero: 2,
          centroCustoId: 'cc-2',
          categoriaId: 'cat-2',
          valor: 30.0, //
        ),
      ];

      final res = useCase.editItem(
        currentItems: currentItems,
        totalValor: 100.0,
        numero: 2,
        centroCustoId: 'cc-2-edit',
        categoriaId: 'cat-2-edit',
        itemValor: 45.0,
      );

      expect(res.isSuccess(), isTrue);
      final updatedList = res.getOrThrow();
      expect(updatedList, hasLength(2));

      final item1 = updatedList.firstWhere((e) => e.numero == 1);
      final item2 = updatedList.firstWhere((e) => e.numero == 2);

      expect(item1.valor, 55.0);
      expect(item2.valor, 45.0);
      expect(item2.centroCustoId, 'cc-2-edit');
      expect(item2.categoriaId, 'cat-2-edit');
    });

    test('Should remove item and return value to Item 1', () {
      final currentItems = [
        const LancamentoItem(
          numero: 1,
          centroCustoId: 'cc-1',
          categoriaId: 'cat-1',
          valor: 70.0,
        ),
        const LancamentoItem(
          numero: 2,
          centroCustoId: 'cc-2',
          categoriaId: 'cat-2',
          valor: 30.0,
        ),
      ];

      final res = useCase.removeItem(
        currentItems: currentItems,
        totalValor: 100.0,
        numero: 2,
      );

      expect(res.isSuccess(), isTrue);
      final updatedList = res.getOrThrow();
      expect(updatedList, hasLength(1));

      final item1 = updatedList.firstWhere((e) => e.numero == 1);
      expect(item1.valor, 100.0);
    });

    test(
      'Should return error when Item 1 violates minimum percentage of 1%',
      () {
        final currentItems = [
          const LancamentoItem(
            numero: 1,
            centroCustoId: 'cc-1',
            categoriaId: 'cat-1',
            valor: 1000.0,
          ),
        ];

        final res = useCase.addItem(
          currentItems: currentItems,
          totalValor: 1000.0,
          centroCustoId: 'cc-2',
          categoriaId: 'cat-2',
          itemValor:
              995.0, // Deixa Item 1 com 5.0 (0.5%), o que é >= 1.00 mas < 1%
        );

        expect(res.isError(), isTrue);
        final exception = res.exceptionOrNull() as DomainException;
        expect(
          exception.message,
          contains(
            'O Item 1 (principal) deve ter pelo menos 1% do valor total',
          ),
        );
      },
    );

    test(
      'Should return error when additional item violates maximum percentage of 99%',
      () {
        final currentItems = [
          const LancamentoItem(
            numero: 1,
            centroCustoId: 'cc-1',
            categoriaId: 'cat-1',
            valor: 1000.0,
          ),
        ];

        final res = useCase.addItem(
          currentItems: currentItems,
          totalValor: 1000.0,
          centroCustoId: 'cc-2',
          categoriaId: 'cat-2',
          itemValor: 995.0, // Excede 99% (99.5%) e deixa Item 1 com 5.0 (0.5%)
        );

        expect(res.isError(), isTrue);
        final exception = res.exceptionOrNull() as DomainException;
        expect(
          exception.message,
          contains('O Item 1 (principal) deve ter pelo menos 1%'),
        );
      },
    );

    test('Should distribute cent differences correctly in parcelled mode', () {
      final baseItems = [
        const LancamentoItem(
          numero: 1,
          centroCustoId: 'cc-1',
          categoriaId: 'cat-1',
          valor: 350.02,
        ), // 70%
        const LancamentoItem(
          numero: 2,
          centroCustoId: 'cc-2',
          categoriaId: 'cat-2',
          valor: 150.01,
        ), // 30%
      ];

      final parcelas = useCase.distributeParcelas(
        totalValor: 500.03,
        parcelasCount: 5,
        baseItems: baseItems,
      );

      expect(parcelas, hasLength(5));

      // Parcela 1: 100.03
      // 100.03 * 0.7000 = 70.021 -> 70.02
      // 100.03 * 0.3000 = 30.009 -> 30.01
      // Soma: 100.03. Sem ajuste necessário.
      expect(parcelas[0][0].valor, 70.02);
      expect(parcelas[0][1].valor, 30.01);
      expect(parcelas[0][0].valor + parcelas[0][1].valor, 100.03);

      // Parcela 2: 100.00
      // 100.00 * 0.7000 = 70.00
      // 100.00 * 0.3000 = 30.00
      // Soma: 100.00. Sem ajuste necessário.
      expect(parcelas[1][0].valor, 70.00);
      expect(parcelas[1][1].valor, 30.00);
      expect(parcelas[1][0].valor + parcelas[1][1].valor, 100.00);
    });

    test('Should distribute replicated percentual correctly', () {
      final baseItems = [
        const LancamentoItem(
          numero: 1,
          centroCustoId: 'cc-1',
          categoriaId: 'cat-1',
          valor: 70.0,
        ),
        const LancamentoItem(
          numero: 2,
          centroCustoId: 'cc-2',
          categoriaId: 'cat-2',
          valor: 30.0,
        ),
      ];

      final novosItens = useCase.distributeReplicado(
        valorReplica: 200.0,
        baseItems: baseItems,
        baseTotalValor: 100.0,
      );

      expect(novosItens, hasLength(2));
      expect(novosItens[0].valor, 140.0);
      expect(novosItens[1].valor, 60.0);
    });
  });
}
