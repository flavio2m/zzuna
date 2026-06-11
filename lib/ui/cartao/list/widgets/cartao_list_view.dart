import 'package:flutter/material.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';
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
          return Center(
            child: AppText(
              'Erro ao carregar cartões: ${state.getExceptionOrNull()}',
              color: AppColors.danger, //
            ),
          );
        }

        final cartoes = state.getValueOrNull() ?? [];

        if (cartoes.isEmpty) {
          return const Center(child: AppText('Nenhum cartão encontrado.'));
        }

        return Stack(
          children: [
            ListView.separated(
              itemCount: cartoes.length,
              separatorBuilder: (context, index) => const AppDivider(),
              itemBuilder: (context, index) {
                return CartaoListItem(cartaoDetails: cartoes[index]);
              },
            ),

            if (state.isRunning)
              const Positioned(
                top: 0,
                left: 0,
                right: 0,
                child: LinearProgressIndicator(), //
              ),
          ],
        );
      },
    );
  }
}
