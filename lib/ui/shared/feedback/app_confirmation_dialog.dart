import 'package:zzuna/ui/shared/widgets/buttons/app_button.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_cancel.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_form.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_spacing.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';
import 'package:zzuna/ui/shared/feedback/app_dialog.dart';
import 'package:flutter/material.dart';

class AppConfirmationDialog {
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required String message,
    Map<String, String> actions = const {
      'cancel': 'Cancelar', 'confirm': 'Confirmar', //
    },
  }) => AppDialog.show<T>(
    context: context,
    maxWidth: 400, // Make it a bit more compact for confirmation dialogs
    child: AppForm(
      type: AppFormType.modal,
      title: title,
      actionsLayout: AppFormActionsLayout.row,
      actionsSize: AppFormActionsSize.intrinsic,
      actions: actions.entries.map((action) {
        final isCancel = action.key == 'cancel';
        final isLast = action.key == actions.keys.last;

        if (isCancel) {
          return ButtonCancel(
            label: action.value,
            autofocus: isLast,
            onPressed: () {
              Navigator.of(context).pop(action.key);
            },
          );
        }

        return AppButton(
          label: action.value,
          autofocus: isLast,
          textStyle: TextStyle(
            color: Theme.of(context).colorScheme.primary,
            fontWeight: FontWeight.bold,
          ),
          icon: Icon(Icons.check, color: Theme.of(context).colorScheme.primary),
          onPressed: () {
            Navigator.of(context).pop(action.key);
          },
        );
      }).toList(),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppText(message, variant: AppTextVariant.body),
          const AppSpacing(),
        ],
      ),
    ),
  );
}
