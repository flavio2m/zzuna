import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:zzuna/domain/statics/categoria/categoria_cores.dart';
import 'package:zzuna/ui/shared/feedback/app_dialog.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_cancel.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_save.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_form.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_text_form_field.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_spacing.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';

class AppColorPickerField extends StatelessWidget {
  final String label;
  final String? selectedColor;
  final ValueChanged<String?> onChanged;
  final FocusNode? focusNode;

  const AppColorPickerField({
    super.key,
    this.label = 'Cor',
    required this.selectedColor,
    required this.onChanged,
    this.focusNode,
  });

  void _abrirDialogCorPersonalizada(BuildContext context) {
    final controller = TextEditingController(
      text: selectedColor?.replaceAll('#', '') ?? '',
    );
    String hexDigitado = controller.text;

    AppDialog.show(
      context: context,
      child: StatefulBuilder(
        builder: (ctx, setDialogState) {
          Color? previewColor;
          if (hexDigitado.length == 6 || hexDigitado.length == 8) {
            try {
              previewColor = CategoriaCores.parseHex('#$hexDigitado');
            } catch (_) {}
          }

          void confirmar() {
            if (previewColor != null) {
              onChanged('#${hexDigitado.toUpperCase()}');
              Navigator.pop(ctx);
            }
          }

          return AppForm(
            title: 'Cor Personalizada',
            type: AppFormType.modal,
            actions: [
              ButtonCancel(onPressed: () => Navigator.pop(ctx)),
              ButtonSave(
                label: 'Selecionar',
                onPressed: previewColor != null ? confirmar : null,
              ),
            ],
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const AppText(
                  'Digite o código Hexadecimal da cor (ex: FF5722 ou 7C6DF2):',
                  variant: AppTextVariant.body,
                  color: AppColors.slate600,
                ),
                const AppSpacing(size: AppSpacingSize.md),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: previewColor ?? AppColors.slate100,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: previewColor != null
                              ? AppColors.border
                              : AppColors.slate300,
                          width: 1.5,
                        ),
                      ),
                      child: previewColor == null
                          ? const Icon(
                              Icons.help_outline,
                              color: AppColors.slate400,
                              size: 20,
                            )
                          : null,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: AppTextFormField(
                        label: 'Hexadecimal',
                        hintText: 'FF5722',
                        prefixText: '# ',
                        prefixStyle: const TextStyle(
                          color: AppColors.slate500,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                        controller: controller,
                        autofocus: true,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(
                            RegExp(r'[0-9a-fA-F]'),
                          ),
                          LengthLimitingTextInputFormatter(8),
                        ],
                        onChanged: (val) {
                          setDialogState(() {
                            hexDigitado = val;
                          });
                        },
                        onFieldSubmitted: (_) => confirmar(),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final cores = CategoriaCores.padrao;
    final isCustom =
        selectedColor != null &&
        !cores.any((c) => c.toLowerCase() == selectedColor!.toLowerCase());

    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            label,
            variant: AppTextVariant.caption,
            color: AppColors.slate400,
          ),
          const AppSpacing(size: AppSpacingSize.xs),
          Align(
            alignment: Alignment.centerLeft,
            child: Wrap(
              alignment: WrapAlignment.start,
              runAlignment: WrapAlignment.start,
              spacing: 10,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                // 10 cores padrão
                ...cores.map((hex) {
                  final color = CategoriaCores.parseHex(hex);
                  final isSelected =
                      selectedColor?.toLowerCase() == hex.toLowerCase();

                  return InkWell(
                    canRequestFocus: false,
                    onTap: () => onChanged(isSelected ? null : hex),
                    borderRadius: BorderRadius.circular(20),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: color,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: isSelected
                              ? Colors.white
                              : Colors.white.withValues(alpha: 0.15),
                          width: isSelected ? 2.5 : 1,
                        ),
                        boxShadow: isSelected
                            ? [
                                BoxShadow(
                                  color: color.withValues(alpha: 0.6),
                                  blurRadius: 8,
                                  spreadRadius: 1,
                                ),
                              ]
                            : null,
                      ),
                      child: isSelected
                          ? const Icon(
                              Icons.check,
                              color: Colors.white,
                              size: 18,
                            )
                          : null,
                    ),
                  );
                }),

                // Cor personalizada (se selecionada) ou botão para escolher
                if (isCustom)
                  InkWell(
                    canRequestFocus: false,
                    onTap: () => _abrirDialogCorPersonalizada(context),
                    borderRadius: BorderRadius.circular(20),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: CategoriaCores.parseHex(selectedColor),
                        shape: BoxShape.circle,
                        border: Border.all(color: Colors.white, width: 2.5),
                        boxShadow: [
                          BoxShadow(
                            color: CategoriaCores.parseHex(
                              selectedColor,
                            ).withValues(alpha: 0.6),
                            blurRadius: 8,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 18,
                      ),
                    ),
                  ),

                // Botão para selecionar outra cor
                Tooltip(
                  message: 'Outra cor...',
                  child: InkWell(
                    canRequestFocus: false,
                    onTap: () => _abrirDialogCorPersonalizada(context),
                    borderRadius: BorderRadius.circular(20),
                    child: Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: AppColors.slate100,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.border),
                      ),
                      child: const Icon(
                        Icons.colorize_outlined,
                        color: AppColors.slate600,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
