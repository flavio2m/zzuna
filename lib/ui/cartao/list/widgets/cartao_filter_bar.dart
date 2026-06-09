import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/ui/cartao/create/widgets/cartao_create_modal.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_add.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_banco_dropdown.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_status_dropdown.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_text_form_field.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_action_bar.dart';

class CartaoFilterBar extends ConsumerWidget {
  const CartaoFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(cartaoListViewModelProvider);

    return AppActionBar(
      children: [
        Expanded(
          flex: 3,
          child: AppTextFormField(
            label: 'Buscar por descrição',
            onChanged: (value) => viewModel.filterCommand.execute(value),
          ),
        ),
        Expanded(
          flex: 2,
          child: AppBancoDropdown(
            showAllOption: true,
            onChanged: (value) {
              // Filtro por banco
            },
          ),
        ),
        Expanded(
          flex: 1,
          child: AppStatusDropdown(
            onChanged: (value) {
              // Filtro por status
            },
          ),
        ),
        ButtonAdd(
          onPressed: () => CartaoCreateModal.show(context),
        ),
      ],
    );
  }
}
