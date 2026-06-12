// lib/ui/centro_custo/list/widgets/centro_custo_list_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_divider.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/ui/centro_custo/list/widgets/centro_custo_list_item.dart';
import 'package:zzuna/utils/extensions/command_state_extension.dart';

class CentroCustoListView extends ConsumerWidget {
  const CentroCustoListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(centroCustoListViewModelProvider);

    return ListenableBuilder(
      listenable: viewModel.loadCommand,
      builder: (context, _) {
        final state = viewModel.loadCommand.value;
        if (state.isRunning) {
          return const Center(child: CircularProgressIndicator());
        }
        if (state.isFailure) {
          return Center(
            child: AppText('Erro ao carregar centros de custo: ${state.getExceptionOrNull()}', color: AppColors.danger),
          );
        }
        final centros = state.getValueOrNull() ?? [];
        if (centros.isEmpty) {
          return const Center(child: AppText('Nenhum centro de custo encontrado.'));
        }
        return Stack(
          children: [
            ListView.separated(
              itemCount: centros.length,
              separatorBuilder: (_, _) => const AppDivider(),
              itemBuilder: (context, index) => CentroCustoListItem(centroCusto: centros[index]),
            ),
            if (state.isRunning) const Positioned(top: 0, left: 0, right: 0, child: LinearProgressIndicator()),
          ],
        );
      },
    );
  }
}
