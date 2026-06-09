import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/statics/banco/bancos.dart';
import 'package:zzuna/ui/conta/list/widgets/conta_create_modal.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_add.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_text_form_field.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_spacing.dart';

class ContaFilterBar extends ConsumerWidget {
  const ContaFilterBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(contaListViewModelProvider);

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: AppTextFormField(
              label: 'Buscar por descrição',
              onChanged: (value) => viewModel.filterCommand.execute(value),
            ),
          ),
          const AppSpacing(size: AppSpacingSize.md, isHorizontal: true),
          Expanded(
            flex: 2,
            child: DropdownButtonFormField<String>(
              decoration: const InputDecoration(
                labelText: 'Banco',
                border: OutlineInputBorder(),
              ),
              items: [
                const DropdownMenuItem(value: '', child: Text('Todos os Bancos')),
                ...Bancos.items.map(
                  (b) => DropdownMenuItem(value: b.sigla, child: Text(b.descricao)),
                ),
              ],
              onChanged: (value) {
                // Filtro por banco poderia ser adicionado ao filterCommand se necessário
              },
            ),
          ),
          const AppSpacing(size: AppSpacingSize.md, isHorizontal: true),
          Expanded(
            flex: 1,
            child: DropdownButtonFormField<bool?>(
              decoration: const InputDecoration(
                labelText: 'Status',
                border: OutlineInputBorder(),
              ),
              items: const [
                DropdownMenuItem(value: null, child: Text('Todos')),
                DropdownMenuItem(value: true, child: Text('Ativos')),
                DropdownMenuItem(value: false, child: Text('Inativos')),
              ],
              onChanged: (value) {
                // Filtro por status
              },
            ),
          ),
          const AppSpacing(size: AppSpacingSize.md, isHorizontal: true),
          ButtonAdd(
            onPressed: () => ContaCreateModal.show(context),
          ),
        ],
      ),
    );
  }
}
