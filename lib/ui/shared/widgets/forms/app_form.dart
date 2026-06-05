import 'package:zzuna/ui/shared/widgets/layout/app_divider.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_spacing.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';
import 'package:flutter/material.dart';

enum AppFormType { page, modal }

enum AppFormActionsLayout { row, column }

enum AppFormActionsSize { expanded, intrinsic }

class AppForm extends StatelessWidget {
  final GlobalKey<FormState>? formKey;
  final AppFormType type;

  /// Título exibido apenas em modal
  final String? title;

  /// Conteúdo principal do formulário
  final Widget child;

  /// Botões de ação
  final List<Widget> actions;

  // Exibe a lista de actions com row ou column
  final AppFormActionsLayout actionsLayout;

  // Define se os botões de ação devem ocupar toda a largura disponível ou
  //apenas o necessário
  final AppFormActionsSize actionsSize;

  const AppForm({
    super.key,
    required this.child,
    this.formKey,
    this.type = AppFormType.page,
    this.title,
    this.actions = const [],
    this.actionsLayout = AppFormActionsLayout.row,
    this.actionsSize = AppFormActionsSize.expanded,
  });

  bool get _isModal => type == AppFormType.modal;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (_isModal) ...[
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                AppText(title ?? '', variant: AppTextVariant.title),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.of(context).pop(), //
                ),
              ],
            ),
            AppSpacing(size: AppSpacingSize.sm),
          ],

          child,

          if (actions.isNotEmpty) ...[
            AppSpacing(size: AppSpacingSize.xs),
            AppDivider(variant: AppDividerVariant.subtle),
            AppSpacing(size: AppSpacingSize.xs),

            if (actionsLayout == AppFormActionsLayout.column)
              Column(
                crossAxisAlignment: actionsSize == AppFormActionsSize.expanded
                    ? CrossAxisAlignment.stretch
                    : CrossAxisAlignment.center,
                children: [
                  for (int i = 0; i < actions.length; i++) ...[
                    actions[i],
                    if (i < actions.length - 1) AppSpacing(size: AppSpacingSize.md),
                  ],
                ],
              )
            else
              Row(
                mainAxisAlignment: actionsSize == AppFormActionsSize.expanded
                    ? MainAxisAlignment.spaceBetween
                    : MainAxisAlignment.center,
                children: [
                  for (int i = 0; i < actions.length; i++) ...[
                    actionsSize == AppFormActionsSize.expanded
                        ? Expanded(
                            child: actions[i], //
                          )
                        : actions[i],

                    if (i < actions.length - 1)
                      AppSpacing(
                        size: AppSpacingSize.md,
                        axis: Axis.horizontal, //
                      ),
                  ],
                ],
              ),
          ],
        ],
      ),
    );
  }
}
