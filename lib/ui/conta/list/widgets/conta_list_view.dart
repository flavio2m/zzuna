import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/ui/conta/list/widgets/conta_list_item.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_divider.dart';
import 'package:zzuna/utils/extensions/command_state_extension.dart';

class ContaListView extends ConsumerWidget {
  const ContaListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(contaListViewModelProvider);

    return ListenableBuilder(
      listenable: viewModel.loadCommand,
      builder: (context, _) {
        final state = viewModel.loadCommand.value;
        final contas = viewModel.contas;

        if (state.isRunning && contas.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.isFailure) {
          return Center(
            child: Text(
              'Erro ao carregar contas: ${state.getExceptionOrNull()}', //
            ),
          );
        }

        if (contas.isEmpty) {
          return const Center(child: Text('Nenhuma conta encontrada.'));
        }

        return Stack(
          children: [
            ListView.separated(
              itemCount: contas.length,
              separatorBuilder: (context, index) => const AppDivider(),
              itemBuilder: (context, index) {
                return ContaListItem(contaDetails: contas[index]);
              },
            ),
            if (state.isRunning)
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicator(),
              ),
          ],
        );
      },
    );
  }
}
