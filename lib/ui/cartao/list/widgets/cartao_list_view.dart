import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/ui/cartao/list/widgets/cartao_list_item.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_divider.dart';
import 'package:zzuna/utils/extensions/command_state_extension.dart';

class CartaoListView extends ConsumerWidget {
  const CartaoListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(cartaoListViewModelProvider);

    return ListenableBuilder(
      listenable: viewModel.loadCommand,
      builder: (context, _) {
        final state = viewModel.loadCommand.value;

        if (state.isRunning) {
          return const Center(child: CircularProgressIndicator());
        }

        if (state.isFailure) {
          return Center(child: Text('Erro ao carregar cartões: ${state.getExceptionOrNull()}'));
        }

        final cartoes = state.getValueOrNull() ?? [];

        if (cartoes.isEmpty) {
          return const Center(child: Text('Nenhum cartão encontrado.'));
        }

        return ListView.separated(
          itemCount: cartoes.length,
          separatorBuilder: (context, index) => const AppDivider(),
          itemBuilder: (context, index) {
            return CartaoListItem(cartao: cartoes[index]);
          },
        );
      },
    );
  }
}
