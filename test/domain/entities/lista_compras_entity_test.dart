import 'package:flutter_test/flutter_test.dart';
import 'package:zzuna/domain/entities/item_compra_entity.dart';
import 'package:zzuna/domain/entities/lista_compras_entity.dart';
import 'package:zzuna/domain/entities/registro_compra_entity.dart';
import 'package:zzuna/domain/enums/item_compra_situacao.dart';
import 'package:zzuna/domain/enums/mes.dart';

void main() {
  group('ListaCompras Entity Tests', () {
    test(
      'calculates totals correctly for pendente, comprado, parcial, and cancelado',
      () {
        final item1 = ItemCompra(
          id: '1',
          produto: 'Café',
          quantidadePlanejada: 2.0,
          historicoCompras: [
            RegistroCompra(data: DateTime(2026, 9, 10), quantidade: 2.0),
          ],
          precoEstimado: 5.0,
          situacao: ItemCompraSituacao.comprado,
        );

        final item2 = ItemCompra(
          id: '2',
          produto: 'Leite',
          quantidadePlanejada: 4.0,
          historicoCompras: [
            RegistroCompra(data: DateTime(2026, 9, 10), quantidade: 1.0),
          ],
          precoEstimado: 3.0,
          situacao: ItemCompraSituacao.pendente,
        );

        final item3 = const ItemCompra(
          id: '3',
          produto: 'Pão',
          quantidadePlanejada: 1.0,
          historicoCompras: [],
          precoEstimado: 2.0,
          situacao: ItemCompraSituacao.pendente,
        );

        final item4 = const ItemCompra(
          id: '4',
          produto: 'Chocolate',
          quantidadePlanejada: 3.0,
          historicoCompras: [],
          precoEstimado: 4.0,
          situacao: ItemCompraSituacao.cancelado,
        );

        final lista = ListaCompras(
          id: 'l1',
          ano: 2026,
          mes: Mes.setembro,
          periodo: 202609,
          itens: [item1, item2, item3, item4],
        );

        expect(lista.totalItens, 4);
        expect(lista.totalComprados, 1);
        expect(lista.totalParcialmenteComprados, 1);
        expect(lista.totalPendentes, 1);
        expect(lista.totalCancelados, 1);

        // Valor estimado total (exclui cancelados):
        // Café: 2*5 = 10, Leite: 4*3 = 12, Pão: 1*2 = 2. Total = 24.
        expect(lista.valorEstimadoTotal, 24.0);

        // Valor estimado comprado:
        // Café: 2*5 = 10, Leite: 1*3 = 3, Pão: 0*2 = 0. Total = 13.
        expect(lista.valorEstimadoComprado, 13.0);

        // Valor estimado pendente: 24 - 13 = 11.
        expect(lista.valorEstimadoPendente, 11.0);
      },
    );

    test('legacy migration converts quantidadeComprada to RegistroCompra', () {
      final jsonLegacy = {
        'id': 'l1',
        'ano': 2026,
        'mes': 'setembro',
        'periodo': 202609,
        'itens': [
          {
            'id': 'i1',
            'produto': 'Arroz',
            'quantidadePlanejada': 5.0,
            'quantidadeComprada': 3.0,
            'precoEstimado': 25.0,
            'situacao': 'pendente',
            'supermercados': [
              {'nome': 'Supermercado Central', 'ultimoUtilizado': true},
            ],
          },
        ],
      };

      final lista = ListaCompras.fromJson(jsonLegacy).migrarItensLegados();
      expect(lista.itens.first.historicoCompras.length, 1);
      final registro = lista.itens.first.historicoCompras.first;
      expect(registro.quantidade, 3.0);
      expect(registro.precoReal, 25.0);
      expect(registro.supermercadoId, 'Supermercado Central');
      expect(lista.itens.first.quantidadeComprada, 3.0);
    });

    test('computed quantidadeComprada sums all historicoCompras', () {
      final item = ItemCompra(
        id: '1',
        produto: 'Maçã',
        quantidadePlanejada: 10.0,
        historicoCompras: [
          RegistroCompra(data: DateTime(2026, 9, 1), quantidade: 2.0),
          RegistroCompra(data: DateTime(2026, 9, 5), quantidade: 3.5),
        ],
      );

      expect(item.quantidadeComprada, 5.5);
    });
  });
}
