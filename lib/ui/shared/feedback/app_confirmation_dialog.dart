import 'package:zzuna/ui/shared/widgets/buttons/app_textbutton.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_form.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_spacing.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';
import 'package:flutter/material.dart';

class AppConfirmationDialog {
  static Future<T?> show<T>({
    required BuildContext context,
    required String title,
    required String message,
    Map<String, String> actions = const {
      'confirm': 'Confirmar', 'cancel': 'Cancelar', //
    },
  }) => showDialog<T>(
    context: context,
    builder: (dialogContext) {
      return Dialog(
        child: AppForm(
          type: AppFormType.modal,
          title: title,
          actionsLayout: AppFormActionsLayout.row,
          actionsSize: AppFormActionsSize.intrinsic,
          actions: [
            for (final action in actions.entries)
              AppTextButton(
                label: action.value,
                onPressed: () {
                  Navigator.of(dialogContext).pop(action.key);
                },
              ),
          ],
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
    },
  );
}
