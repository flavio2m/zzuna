import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';

class ToggleOcultarLancamentosButton extends ConsumerWidget {
  const ToggleOcultarLancamentosButton({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final filterState = ref.watch(lancamentoFilterProvider);
    final ocultar = filterState.ocultarLancamentos;

    return IconButton(
      icon: Icon(ocultar ? Icons.unfold_more : Icons.unfold_less, size: 20),
      color: AppColors.slate600,
      tooltip: ocultar ? 'Exibir Lançamentos' : 'Ocultar Lançamentos',
      onPressed: () {
        ref.read(lancamentoFilterProvider.notifier).toggleOcultarLancamentos();
      },
      padding: EdgeInsets.zero,
      constraints: const BoxConstraints(),
      splashRadius: 20,
    );
  }
}
