import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:zzuna/domain/entities/lista_compras_entity.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/ui/shared/widgets/cards/app_card.dart';

class ListaComprasSummaryCard extends StatefulWidget {
  final ListaCompras lista;
  final bool? initiallyExpanded;

  const ListaComprasSummaryCard({
    super.key,
    required this.lista,
    this.initiallyExpanded,
  });

  @override
  State<ListaComprasSummaryCard> createState() =>
      _ListaComprasSummaryCardState();
}

class _ListaComprasSummaryCardState extends State<ListaComprasSummaryCard> {
  bool? _isExpanded;

  String _formatCurrency(double value) {
    return UtilBrasilFields.obterReal(value.abs(), moeda: true);
  }

  void _toggleExpanded(bool currentExpanded) {
    setState(() {
      _isExpanded = !currentExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isMobile = MediaQuery.of(context).size.width < 800;
    final isExpanded = _isExpanded ?? (widget.initiallyExpanded ?? !isMobile);

    return AppCard(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header colapsável
            InkWell(
              onTap: () => _toggleExpanded(isExpanded),
              borderRadius: BorderRadius.circular(6),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 2),
                child: Row(
                  children: [
                    const Icon(
                      Icons.analytics_outlined,
                      size: 18,
                      color: AppColors.slate600,
                    ),
                    const SizedBox(width: 8),
                    const Text(
                      'Resumo',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                        color: AppColors.slate700,
                      ),
                    ),
                    if (!isExpanded) ...[
                      const SizedBox(width: 8),
                      Text(
                        '•  ${widget.lista.totalItens} itens',
                        style: const TextStyle(
                          fontSize: 12,
                          color: AppColors.slate500,
                        ),
                      ),
                      const Spacer(),
                      Text(
                        'Total: ${_formatCurrency(widget.lista.valorEstimadoTotal)}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                          color: AppColors.indigo600,
                        ),
                      ),
                      const SizedBox(width: 4),
                    ] else
                      const Spacer(),
                    Icon(
                      isExpanded ? Icons.expand_less : Icons.expand_more,
                      size: 20,
                      color: AppColors.slate600,
                    ),
                  ],
                ),
              ),
            ),

            AnimatedCrossFade(
              duration: const Duration(milliseconds: 200),
              crossFadeState: isExpanded
                  ? CrossFadeState.showFirst
                  : CrossFadeState.showSecond,
              secondChild: const SizedBox.shrink(),
              firstChild: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  // Row 1: Chips de Contadores
                  Wrap(
                    spacing: 6,
                    runSpacing: 6,
                    children: [
                      _buildChip(
                        label: '${widget.lista.totalItens} Itens',
                        color: AppColors.indigo600,
                        icon: Icons.format_list_bulleted,
                        isMobile: isMobile,
                      ),
                      _buildChip(
                        label: '${widget.lista.totalComprados} Comprados',
                        color: AppColors.emerald800,
                        icon: Icons.check_circle_outline,
                        isMobile: isMobile,
                      ),
                      if (widget.lista.totalParcialmenteComprados > 0)
                        _buildChip(
                          label:
                              '${widget.lista.totalParcialmenteComprados} Parciais',
                          color: Colors.orange.shade800,
                          icon: Icons.timelapse,
                          isMobile: isMobile,
                        ),
                      _buildChip(
                        label: '${widget.lista.totalPendentes} Pendentes',
                        color: Colors.blue.shade700,
                        icon: Icons.pending_actions,
                        isMobile: isMobile,
                      ),
                      if (widget.lista.totalCancelados > 0)
                        _buildChip(
                          label: '${widget.lista.totalCancelados} Cancelados',
                          color: AppColors.slate500,
                          icon: Icons.block,
                          isMobile: isMobile,
                        ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  const Divider(height: 1, color: AppColors.border),
                  const SizedBox(height: 10),
                  // Row 2: Financeiro
                  Row(
                    children: [
                      Expanded(
                        child: _buildMetricTile(
                          label: isMobile ? 'Pendente' : 'Estimado Pendente',
                          value: _formatCurrency(
                            widget.lista.valorEstimadoPendente,
                          ),
                          color: Colors.blue.shade800,
                          isMobile: isMobile,
                        ),
                      ),
                      Container(height: 32, width: 1, color: AppColors.border),
                      Expanded(
                        child: _buildMetricTile(
                          label: isMobile ? 'Comprado' : 'Estimado Comprado',
                          value: _formatCurrency(
                            widget.lista.valorEstimadoComprado,
                          ),
                          color: AppColors.emerald800,
                          isMobile: isMobile,
                        ),
                      ),
                      Container(height: 32, width: 1, color: AppColors.border),
                      Expanded(
                        child: _buildMetricTile(
                          label: isMobile ? 'Total' : 'Estimado Total',
                          value: _formatCurrency(
                            widget.lista.valorEstimadoTotal,
                          ),
                          color: AppColors.indigo600,
                          isMobile: isMobile,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
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
    bool isMobile = false,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: isMobile ? 8 : 10,
        vertical: isMobile ? 3 : 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: isMobile ? 12 : 14, color: color),
          const SizedBox(width: 4),
          Text(
            label,
            style: TextStyle(
              fontSize: isMobile ? 11 : 12,
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
    bool isMobile = false,
  }) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: isMobile ? 4 : 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontSize: isMobile ? 11 : 12,
              color: AppColors.slate500,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 2),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              value,
              style: TextStyle(
                fontSize: isMobile ? 14 : 16,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
