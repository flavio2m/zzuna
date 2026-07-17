import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/entities/lancamento/lancamento_entity.dart';
import 'package:zzuna/ui/lancamentos/shared/fields/icon_acoes_button.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/ui/shared/widgets/buttons/app_button.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_cancel.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_form.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_spacing.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';
import 'package:zzuna/ui/shared/feedback/app_dialog.dart';
import 'package:zzuna/domain/value_objects/lancamento/lancamento_grupo.dart';

class LancamentosExcluirMenuItem extends PopupMenuItem<TipoAcoes> {
  LancamentosExcluirMenuItem({
    super.key,
    required BuildContext context,
    required WidgetRef ref,
    required LancamentoDetails lancamento,
  }) : super(
         value: TipoAcoes.excluir,
         height: 36,
         child: Row(
           children: [
             const Icon(
               Icons.delete_outline_rounded,
               size: 16,
               color: AppColors.danger,
             ),
             const SizedBox(width: 8),
             const Text(
               'Excluir',
               style: TextStyle(
                 color: AppColors.danger,
                 fontSize: 13,
                 fontWeight: FontWeight.w600,
               ),
             ),
           ],
         ),
         onTap: () {
           Future.delayed(Duration.zero, () {
             if (!context.mounted) return;
             _showDeleteDialog(context, ref, lancamento);
           });
         },
       );

  static Future<void> _showDeleteDialog(
    BuildContext context,
    WidgetRef ref,
    LancamentoDetails lancamento,
  ) async {
    final grupo = lancamento.grupo;
    final isTransferencia = grupo is LancamentoGrupoTransferencia;
    // Mostra "Excluir todos" somente para grupos que não são transferência
    final showExcluirTodos = grupo != null && !isTransferencia;

    final result = await AppDialog.show<String>(
      context: context,
      maxWidth: 420,
      child: _DeleteDialog(showExcluirTodos: showExcluirTodos),
    );

    if (result == null || result == 'cancel') return;
    if (!context.mounted) return;

    final excluirTodos = result == 'excluir_todos';
    final useCase = ref.read(deleteLancamentoUseCaseProvider);
    final deleteResult = await useCase.execute(
      lancamento.id,
      excluirTodos: excluirTodos,
    );

    if (!context.mounted) return;

    if (deleteResult.isError()) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(deleteResult.exceptionOrNull()!.toString()),
          backgroundColor: Theme.of(context).colorScheme.error,
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lançamento excluído com sucesso.'),
          backgroundColor: Colors.green,
        ),
      );
    }
  }
}

class _DeleteDialog extends StatelessWidget {
  final bool showExcluirTodos;

  const _DeleteDialog({required this.showExcluirTodos});

  @override
  Widget build(BuildContext context) {
    final obsTodos = showExcluirTodos
        ? ' ou todos os lançamentos relacionados'
        : '';
    return AppForm(
      type: AppFormType.modal,
      title: 'Excluir lançamento',
      actionsLayout: AppFormActionsLayout.row,
      actionsSize: AppFormActionsSize.intrinsic,
      actions: [
        ButtonCancel(
          label: 'Cancelar',
          onPressed: () => Navigator.of(context).pop('cancel'),
        ),
        AppButton(
          label: 'Excluir',
          autofocus: true,
          textStyle: const TextStyle(
            color: AppColors.danger,
            fontWeight: FontWeight.bold,
          ),
          icon: const Icon(Icons.delete_rounded, color: AppColors.danger),
          onPressed: () => Navigator.of(context).pop('excluir_este'),
        ),
        if (showExcluirTodos)
          AppButton(
            label: 'Excluir todos',
            textStyle: const TextStyle(
              color: AppColors.danger,
              fontWeight: FontWeight.bold,
            ),
            icon: const Icon(
              Icons.delete_sweep_rounded,
              color: AppColors.danger,
            ),
            onPressed: () => Navigator.of(context).pop('excluir_todos'),
          ),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(
            'Tem certeza que deseja excluir este lançamento$obsTodos? Esta '
            'ação não pode ser desfeita.',
            variant: AppTextVariant.body,
          ),
          AppSpacing(),
        ],
      ),
    );
  }
}
