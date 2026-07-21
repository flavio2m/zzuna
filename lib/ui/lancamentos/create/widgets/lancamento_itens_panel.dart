import 'package:flutter/material.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/domain/entities/centro_custo_entity.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_item.dart';
import 'package:zzuna/ui/lancamentos/create/widgets/lancamento_item_card.dart';
import 'package:zzuna/ui/lancamentos/create/widgets/lancamento_item_form.dart';
import 'package:zzuna/ui/shared/feedback/app_dialog.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_spacing.dart';

class LancamentoItensPanel extends StatelessWidget {
  final List<LancamentoItem> items;
  final double totalValor;
  final List<CategoriaDetails> categorias;
  final List<CentroCusto> centros;
  final bool allowEditItem1;

  final Function(String ccId, String catId, double val) onSaveNewItem;
  final Function(int numero, String ccId, String catId, double val)
  onSaveEditItem;
  final Function(int numero) onDeleteItem;

  final FocusNode? focusDividir;
  final VoidCallback? onDividirEnter;

  const LancamentoItensPanel({
    super.key,
    required this.items,
    required this.totalValor,
    required this.categorias,
    required this.centros,
    required this.onSaveNewItem,
    required this.onSaveEditItem,
    required this.onDeleteItem,
    this.allowEditItem1 = false,
    this.focusDividir,
    this.onDividirEnter,
  });

  Map<String, String> _getCategoriaLabels(
    List<CategoriaDetails> nodes,
    String prefix,
  ) {
    final result = <String, String>{};
    for (final node in nodes) {
      final label = prefix.isEmpty
          ? node.descricao
          : '$prefix > ${node.descricao}';
      result[node.id] = label;
      if (node.subcategorias.isNotEmpty) {
        result.addAll(_getCategoriaLabels(node.subcategorias, label));
      }
    }
    return result;
  }

  String _getCentroCustoLabel(String id, List<CentroCusto> list) {
    final cc =
        list //
            .cast<CentroCusto?>()
            .firstWhere((e) => e?.id == id, orElse: () => null);
    return cc?.descricao ?? '';
  }

  @override
  Widget build(BuildContext context) {
    final catLabels = _getCategoriaLabels(categorias, '');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const AppSpacing(size: AppSpacingSize.sm),

        // Lista de Cards dos Itens
        ...items.map((item) {
          final ccDesc = _getCentroCustoLabel(item.centroCustoId, centros);
          final catDesc = catLabels[item.categoriaId] ?? '';

          return LancamentoItemCard(
            item: item,
            totalValor: totalValor,
            centroCustoDescricao: ccDesc,
            categoriaDescricao: catDesc,
            onDivide: item.numero == 1
                ? () {
                    AppDialog.show(
                      context: context,
                      child: LancamentoItemForm(
                        categorias: categorias,
                        centros: centros,
                        totalValor: totalValor,
                        initialCentroCustoId: item.centroCustoId,
                        onSave: (ccId, catId, val) {
                          onSaveNewItem(ccId, catId, val);
                          Navigator.pop(context);
                        },
                        onCancel: () => Navigator.pop(context),
                      ),
                    );
                  }
                : null,
            focusDividir: item.numero == 1 ? focusDividir : null,
            onDividirEnter: item.numero == 1 ? onDividirEnter : null,
            onEdit: (item.numero == 1 && !allowEditItem1)
                ? null
                : () {
                    AppDialog.show(
                      context: context,
                      child: LancamentoItemForm(
                        categorias: categorias,
                        centros: centros,
                        totalValor: totalValor,
                        initialItem: item,
                        onSave: (ccId, catId, val) {
                          onSaveEditItem(item.numero, ccId, catId, val);
                          Navigator.pop(context);
                        },
                        onCancel: () => Navigator.pop(context),
                      ),
                    );
                  },
            onDelete: item.numero == 1 ? null : () => onDeleteItem(item.numero),
          );
        }),
      ],
    );
  }
}
