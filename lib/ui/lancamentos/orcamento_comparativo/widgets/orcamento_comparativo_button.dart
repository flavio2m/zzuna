import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/ui/lancamentos/orcamento_comparativo/widgets/orcamento_comparativo_modal.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';

class OrcamentoComparativoButton extends ConsumerWidget {
  const OrcamentoComparativoButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return IconButton(
      icon: const Icon(Icons.analytics_outlined, size: 20),
      color: AppColors.slate600,
      tooltip: 'Orçamento Previsto vs Real',
      onPressed: () {
        ref.read(orcamentoComparativoViewModelProvider).loadCategorias();
        OrcamentoComparativoModal.show(context);
      },
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      splashRadius: 20,
    );
  }
}
