import 'package:flutter/material.dart';
import 'package:zzuna/ui/lancamentos/orcamento_comparativo/widgets/orcamento_comparativo_modal.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';

class OrcamentoComparativoButton extends StatelessWidget {
  const OrcamentoComparativoButton({super.key});

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.analytics_outlined, size: 20),
      color: AppColors.slate600,
      tooltip: 'Orçamento Previsto vs Real',
      onPressed: () => OrcamentoComparativoModal.show(context),
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      splashRadius: 20,
    );
  }
}
