import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_text_form_field.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_menu_text.dart';

class SidebarSearch extends ConsumerWidget {
  const SidebarSearch({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AppMenuText(
            'FILTRAR OPCOES',
            variant: AppMenuTextVariant.section,
          ),
          const SizedBox(height: 7),
          SizedBox(
            child: AppTextFormField(
              label: 'Filtrar contas, cartões ...',
              onChanged: (value) {
                ref //
                    .read(lancamentosSidebarStateProvider.notifier)
                    .setFiltro(value);
              },
            ),
          ),
        ],
      ),
    );
  }
}
