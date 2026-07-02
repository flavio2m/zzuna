import 'package:flutter/material.dart';
import 'package:brasil_fields/brasil_fields.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_grupo.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_item.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_origem_detail.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';
import 'package:zzuna/ui/shared/widgets/tags/app_tag.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_spacing.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_divider.dart';
import 'package:zzuna/ui/shared/widgets/cards/app_card.dart';
import 'package:zzuna/utils/formatters/date_formatter.dart';

class LancamentoDetailsModal extends StatelessWidget {
  final LancamentoDetails lancamento;

  const LancamentoDetailsModal({super.key, required this.lancamento});

  String _getRelationText() {
    final grupo = lancamento.grupo;
    if (grupo != null) {
      switch (grupo) {
        case LancamentoGrupoParcelamento(:final parcela, :final totalParcelas):
          return 'Parcelado ($parcela de $totalParcelas)';
        case LancamentoGrupoReplicacao(:final parcela, :final totalParcelas):
          return 'Replicado ($parcela de $totalParcelas)';
        case LancamentoGrupoTransferencia():
          return 'Transferência';
        case LancamentoGrupoRecorrencia(:final ativo):
          return ativo ? 'Recorrente (Ativo)' : 'Recorrência Inativa';
      }
    }

    final relationRegExp = RegExp(r'\s\((\d+)/(\d+)\)$');
    final match = relationRegExp.firstMatch(lancamento.descricao);
    if (match != null) {
      final current = match.group(1);
      final total = match.group(2);
      final isReplicado = lancamento.descricao.toLowerCase().contains(
        'replicado',
      );
      final modeStr = isReplicado ? 'Replicado' : 'Parcelado';
      return '$modeStr ($current de $total)';
    }

    return 'Simples';
  }

  @override
  Widget build(BuildContext context) {
    final valorStr = UtilBrasilFields.obterReal(lancamento.valor, moeda: true);
    final relationText = _getRelationText();

    final isIncome = lancamento.tipo == LancamentoTipo.receita;
    final isTransfer = lancamento.tipo == LancamentoTipo.transferencia;
    final valorColor = //
    isIncome
        ? AppColors.primary
        : (isTransfer ? AppColors.indigo600 : AppColors.danger);

    final statusText = lancamento.conciliado ? 'CONCILIADO' : 'PENDENTE';
    final statusVariant = //
    lancamento.conciliado
        ? AppTagVariant.success
        : AppTagVariant.warning;

    final accountName = switch (lancamento.origem) {
      LancamentoOrigemContaDetail(conta: final c) => c.descricao,
      LancamentoOrigemCartaoDetail(cartao: final c) => c.descricao,
    };

    final dateStr = DateFormatter.fullDate(lancamento.data);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Cabeçalho com Título e Fechar
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: AppText(
                'Detalhes do Lançamento',
                variant: AppTextVariant.title,
                color: AppColors.slate500, //
              ),
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 20),
              onPressed: () => Navigator.pop(context),
              color: AppColors.slate400,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
            ),
          ],
        ),
        const AppSpacing(size: AppSpacingSize.sm),
        const AppDivider(variant: AppDividerVariant.normal),
        const AppSpacing(size: AppSpacingSize.md),

        // Descrição e Valor lado a lado
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const AppText(
                    'Descrição', //
                    variant: AppTextVariant.caption,
                    color: AppColors.slate500,
                  ),
                  const AppSpacing(size: AppSpacingSize.xs),
                  AppText(
                    lancamento.descricao,
                    variant: AppTextVariant.subtitle,
                    color: AppColors.slate800, //
                    fontWeight: FontWeight.bold,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 16),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const AppText(
                  'Valor', //
                  variant: AppTextVariant.caption,
                  color: AppColors.slate500,
                ),
                const AppSpacing(size: AppSpacingSize.xs),
                AppText(
                  valorStr,
                  variant: AppTextVariant.subtitle,
                  color: valorColor,
                  fontWeight: FontWeight.w900, //
                ),
              ],
            ),
          ],
        ),

        const AppSpacing(size: AppSpacingSize.md),
        const AppDivider(variant: AppDividerVariant.normal),
        const AppSpacing(size: AppSpacingSize.md),

        // Informações Gerais
        AppText(
          'Informações Gerais',
          variant: AppTextVariant.subtitle,
          color: AppColors.slate600, //
        ),
        const AppSpacing(size: AppSpacingSize.sm),

        AppCard(
          variant: AppCardVariant.flat,
          padding: const EdgeInsets.all(12),
          margin: EdgeInsets.zero,
          child: Column(
            children: [
              _buildInfoRow(label: 'Conta Origem/Destino', value: accountName),
              const AppDivider(variant: AppDividerVariant.subtle),
              _buildInfoRow(label: 'Data', value: dateStr),
              const AppDivider(variant: AppDividerVariant.subtle),
              _buildInfoRow(
                label: 'Tipo',
                value: isIncome
                    ? 'Receita'
                    : (isTransfer
                          ? 'Transferência'
                          : 'Despesa' //
                            ),
              ),
              const AppDivider(variant: AppDividerVariant.subtle),
              _buildInfoRow(
                label: 'Situação',
                widget: AppTag(statusText, variant: statusVariant), //
              ),
              const AppDivider(variant: AppDividerVariant.subtle),
              _buildInfoRow(label: 'Modo de Lançamento', value: relationText),
            ],
          ),
        ),

        const AppSpacing(size: AppSpacingSize.md),
        const AppDivider(variant: AppDividerVariant.normal),
        const AppSpacing(size: AppSpacingSize.md),

        // Distribuição dos Itens
        AppText(
          'Itens de Distribuição (${lancamento.itens.length})',
          variant: AppTextVariant.subtitle,
          color: AppColors.slate600,
        ),
        const AppSpacing(size: AppSpacingSize.sm),

        ...lancamento.itens.map((item) {
          final pct = //
          lancamento.valor > 0
              ? (item.valor / lancamento.valor) * 100
              : 0.0;
          return _buildItemCard(context, item, pct);
        }),

        // Se houver observações
        if (lancamento.observacao != null &&
            lancamento.observacao!.trim().isNotEmpty) ...[
          const AppSpacing(size: AppSpacingSize.md),
          const AppDivider(variant: AppDividerVariant.normal),
          const AppSpacing(size: AppSpacingSize.md),
          AppText(
            'Observações',
            variant: AppTextVariant.subtitle,
            color: AppColors.slate600, //
          ),
          const AppSpacing(size: AppSpacingSize.sm),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.slate50,
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: AppColors.slate200),
            ),
            child: AppText(
              lancamento.observacao!,
              variant: AppTextVariant.body,
              color: AppColors.slate700,
              fontWeight: FontWeight.normal,
            ),
          ),
        ],

        const AppSpacing(size: AppSpacingSize.xl),

        // Botão Fechar
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.slate200,
            foregroundColor: AppColors.slate700,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14),
          ),
          child: const AppText(
            'Fechar',
            variant: AppTextVariant.body,
            fontWeight: FontWeight.bold, //
          ),
        ),
      ],
    );
  }

  Widget _buildInfoRow({required String label, String? value, Widget? widget}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppText(
          label,
          variant: AppTextVariant.body,
          color: AppColors.slate500,
          fontWeight: FontWeight.w500, //
        ),
        Flexible(
          child: value != null
              ? AppText(
                  value,
                  variant: AppTextVariant.body,
                  color: AppColors.slate800,
                  fontWeight: FontWeight.bold,
                  textAlign: TextAlign.right,
                )
              : widget ?? Container(),
        ),
      ],
    );
  }

  Widget _buildItemCard(
    BuildContext context,
    LancamentoItemDetails item,
    double pct, //
  ) {
    // Formatar percentual
    String pctStr = pct.toStringAsFixed(3);
    if (pctStr.contains('.')) {
      while (pctStr.endsWith('0')) {
        pctStr = pctStr.substring(0, pctStr.length - 1);
      }
      if (pctStr.endsWith('.')) {
        pctStr = pctStr.substring(0, pctStr.length - 1);
      }
    }
    pctStr = pctStr.replaceAll('.', ',');

    final formattedValor = UtilBrasilFields.obterReal(item.valor);

    // Caminho da categoria (incluindo categoria pai)
    String categoryPath(CategoriaDetails cat) {
      if (cat.categoriaPai != null) {
        return '${categoryPath(cat.categoriaPai!)} > ${cat.descricao}';
      }
      return cat.descricao;
    }

    final catDesc = switch (item) {
      LancamentoItemDetailsStandard(:final categoria) => categoryPath(
        categoria,
      ),
      LancamentoItemDetailsTransferencia(:final origemSaida) =>
        'Origem: ${origemSaida.map(
          conta: (c) => c.conta.descricao,
          cartao: (c) => c.cartao.descricao, //
        )}',
    };
    final ccDesc = switch (item) {
      LancamentoItemDetailsStandard(:final centroCusto) =>
        centroCusto.descricao,
      LancamentoItemDetailsTransferencia(:final origemEntrada) =>
        'Destino: ${origemEntrada.map(
          conta: (c) => c.conta.descricao,
          cartao: (c) => c.cartao.descricao, //
        )}',
    };

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Theme.of(context).cardColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: AppColors.border.withValues(alpha: 0.5), //
        ),
      ),
      child: Row(
        children: [
          // Número do item
          Container(
            width: 24,
            height: 24,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.slate200,
              shape: BoxShape.circle, //
            ),
            child: AppText(
              '${item.numero}',
              variant: AppTextVariant.caption,
              fontWeight: FontWeight.bold, //
            ),
          ),
          const SizedBox(width: 12),

          // Categoria e Centro de custo
          Expanded(
            child: Wrap(
              spacing: 6,
              runSpacing: 4,
              children: [
                if (ccDesc.isNotEmpty)
                  AppTag(ccDesc, variant: AppTagVariant.neutral)
                else
                  const AppTag(
                    'Sem Centro de Custo', //
                    variant: AppTagVariant.error,
                  ),
                if (catDesc.isNotEmpty)
                  AppTag(catDesc, variant: AppTagVariant.info)
                else
                  const AppTag(
                    'Sem Categoria', //
                    variant: AppTagVariant.error,
                  ),
              ],
            ),
          ),

          // Valor e porcentagem
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              AppTag('$pctStr%', variant: AppTagVariant.neutral),
              const SizedBox(width: 8),
              AppText(
                formattedValor,
                variant: AppTextVariant.body,
                fontWeight: FontWeight.bold, //
              ),
            ],
          ),
        ],
      ),
    );
  }
}
