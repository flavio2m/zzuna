import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:zzuna/domain/entities/lista_compras_entity.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/ui/shared/widgets/cards/app_card.dart';

class ListaComprasSummaryCard extends StatelessWidget {
  final ListaCompras lista;

  const ListaComprasSummaryCard({
    super.key,
    required this.lista,
  });

  String _formatCurrency(double value) {
    return UtilBrasilFields.obterReal(value.abs(), moeda: true);
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 700;

    return AppCard(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Row 1: Chips de Contadores
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: [
                _buildChip(
                  label: '${lista.totalItens} Itens',
                  color: AppColors.indigo600,
                  icon: Icons.format_list_bulleted,
                ),
                _buildChip(
                  label: '${lista.totalComprados} Comprados',
                  color: AppColors.emerald800,
                  icon: Icons.check_circle_outline,
                ),
                if (lista.totalParcialmenteComprados > 0)
                  _buildChip(
                    label: '${lista.totalParcialmenteComprados} Parciais',
                    color: Colors.orange.shade800,
                    icon: Icons.timelapse,
                  ),
                _buildChip(
                  label: '${lista.totalPendentes} Pendentes',
                  color: Colors.blue.shade700,
                  icon: Icons.pending_actions,
                ),
                if (lista.totalCancelados > 0)
                  _buildChip(
                    label: '${lista.totalCancelados} Cancelados',
                    color: AppColors.slate500,
                    icon: Icons.block,
                  ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(height: 1, color: AppColors.border),
            const SizedBox(height: 12),
            // Row 2: Financeiro
            isMobile
                ? Column(
                    children: [
                      _buildMetricTile(
                        label: 'Valor Estimado Pendente',
                        value: _formatCurrency(lista.valorEstimadoPendente),
                        color: Colors.blue.shade800,
                      ),
                      const SizedBox(height: 8),
                      _buildMetricTile(
                        label: 'Valor Estimado Comprado',
                        value: _formatCurrency(lista.valorEstimadoComprado),
                        color: AppColors.emerald800,
                      ),
                      const SizedBox(height: 8),
                      _buildMetricTile(
                        label: 'Valor Estimado Total',
                        value: _formatCurrency(lista.valorEstimadoTotal),
                        color: AppColors.indigo600,
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: _buildMetricTile(
                          label: 'Estimado Pendente',
                          value: _formatCurrency(lista.valorEstimadoPendente),
                          color: Colors.blue.shade800,
                        ),
                      ),
                      Container(
                        height: 36,
                        width: 1,
                        color: AppColors.border,
                      ),
                      Expanded(
                        child: _buildMetricTile(
                          label: 'Estimado Comprado',
                          value: _formatCurrency(lista.valorEstimadoComprado),
                          color: AppColors.emerald800,
                        ),
                      ),
                      Container(
                        height: 36,
                        width: 1,
                        color: AppColors.border,
                      ),
                      Expanded(
                        child: _buildMetricTile(
                          label: 'Estimado Total',
                          value: _formatCurrency(lista.valorEstimadoTotal),
                          color: AppColors.indigo600,
                        ),
                      ),
                    ],
                  ),
          ],
        ),
      ),
    );
  }

  Widget _buildChip({
    required String label,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required String label,
    required String value,
    required Color color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: AppColors.slate500,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            value,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}
