import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/dtos/categoria/categoria_dto.dart';
import 'package:zzuna/domain/enums/categoria_natureza.dart';
import 'package:zzuna/domain/validators/categoria_validator.dart';
import 'package:zzuna/ui/categoria/create/viewModels/categoria_create_viewmodel.dart';
import 'package:zzuna/ui/shared/feedback/app_dialog.dart';
import 'package:zzuna/ui/shared/feedback/app_snackbar.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_cancel.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_save.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_color_picker_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_dropdown_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_dropdown_menu_item.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_form.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_percent_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_text_form_field.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_spacing.dart';
import 'package:zzuna/utils/extensions/command_state_extension.dart';
import 'package:zzuna/utils/extensions/num_extension.dart';

class CategoriaCreateModal extends ConsumerStatefulWidget {
  const CategoriaCreateModal({super.key});

  static void show(BuildContext context) {
    AppDialog.show(context: context, child: const CategoriaCreateModal());
  }

  @override
  ConsumerState<CategoriaCreateModal> createState() =>
      _CategoriaCreateModalState();
}

class _CategoriaCreateModalState extends ConsumerState<CategoriaCreateModal> {
  final dto = CategoriaDto();

  final validator = CategoriaValidator<CategoriaDto>();

  late final CategoriaCreateViewModel viewModel;

  final _descFocus = FocusNode();
  final _naturezaFocus = FocusNode();
  final _paiFocus = FocusNode();
  final _percentualFocus = FocusNode();
  final _saveFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    viewModel = ref.read(categoriaCreateViewModelProvider);
    viewModel.createCommand.addListener(_commandListener);
  }

  @override
  void dispose() {
    viewModel.createCommand.removeListener(_commandListener);

    _descFocus.dispose();
    _naturezaFocus.dispose();
    _paiFocus.dispose();
    _percentualFocus.dispose();
    _saveFocus.dispose();

    super.dispose();
  }

  void _commandListener() {
    final commandValue = viewModel.createCommand.value;

    commandValue.onSuccess((_) {
      AppSnackBar.showSuccess(context, 'Categoria criada com sucesso.');
      Navigator.pop(context);
    });

    commandValue.onFailure((exception) {
      AppSnackBar.showError(context, exception.toString());
    });
  }

  bool get _canSubmit {
    return validator.validate(dto).isValid;
  }

  void _handleSubmit() {
    if (_canSubmit) {
      viewModel.createCommand.execute(dto);
    }
  }

  @override
  Widget build(BuildContext context) {
    final createVM = ref.watch(categoriaCreateViewModelProvider);
    final listVM = ref.watch(categoriaListViewModelProvider);
    final categoriasPai = listVM.categoriasPaiAtivas;
    final isPai = dto.categoriaPaiId == null;

    return AppForm(
      title: 'Nova Categoria',
      type: AppFormType.modal,
      actions: [
        ButtonCancel(onPressed: () => Navigator.of(context).pop()),
        ListenableBuilder(
          listenable: createVM.createCommand,
          builder: (_, _) {
            return ButtonSave(
              focusNode: _saveFocus,
              loading: createVM.createCommand.value.isRunning,
              onPressed: createVM.createCommand.value.isRunning || !_canSubmit
                  ? null
                  : _handleSubmit,
            );
          },
        ),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          AppTextFormField(
            label: 'Descrição',
            autofocus: true,
            focusNode: _descFocus,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => _paiFocus.requestFocus(),
            onChanged: (value) {
              dto.setDescricao(value);
              setState(() {});
            },
            validator: validator.byField(dto, 'descricao'),
          ),

          const AppSpacing(size: AppSpacingSize.md),

          AppDropdownFormField<String>(
            label: 'Categoria Pai',
            focusNode: _paiFocus,
            onEnterPressed: () => isPai
                ? _naturezaFocus.requestFocus()
                : _saveFocus.requestFocus(),
            value: dto.categoriaPaiId,
            items: [
              AppDropdownMenuItem<String>(
                value: '',
                label: 'Nenhuma (Categoria Pai)',
              ),
              ...categoriasPai.map(
                (cat) => AppDropdownMenuItem<String>(
                  value: cat.id,
                  label: cat.descricao,
                ),
              ),
            ],
            onChanged: (value) {
              dto.setCategoriaPaiId(
                value == null || value.isEmpty ? null : value,
              );
              if (dto.categoriaPaiId != null) {
                dto.setPercentualOrcamento(null);
                dto.setCor(null);
                // Se tem pai, sugere a mesma natureza do pai
                final pai = categoriasPai
                    .where((c) => c.id == dto.categoriaPaiId)
                    .firstOrNull;
                if (pai != null) {
                  dto.setNatureza(pai.natureza);
                }
              }
              setState(() {});
            },
          ),

          if (isPai) ...[
            const AppSpacing(size: AppSpacingSize.md),
            Row(
              children: [
                Expanded(
                  child: AppDropdownFormField<CategoriaNatureza>(
                    label: 'Natureza',
                    focusNode: _naturezaFocus,
                    value: dto.natureza,
                    onEnterPressed: () => _percentualFocus.requestFocus(),
                    items: CategoriaNatureza.values
                        .map(
                          (nat) => AppDropdownMenuItem<CategoriaNatureza>(
                            value: nat,
                            label: nat.descricao,
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      if (value != null) {
                        dto.setNatureza(value);
                        setState(() {});
                      }
                    },
                  ),
                ),
                const AppSpacing(
                  size: AppSpacingSize.md,
                  axis: Axis.horizontal,
                ),
                Expanded(
                  child: AppPercentFormField(
                    label: 'Percentual do Orçamento (% - Opcional)',
                    focusNode: _percentualFocus,
                    decimalPlaces: 2,
                    textInputAction: TextInputAction.next,
                    initialValue: dto.percentualOrcamento?.toCleanString(),
                    onFieldSubmitted: (_) => _saveFocus.requestFocus(),
                    onChanged: (value) {
                      if (value.trim().isEmpty) {
                        dto.setPercentualOrcamento(null);
                      } else {
                        final clean = value.replaceAll(',', '.');
                        final parsed = double.tryParse(clean);
                        dto.setPercentualOrcamento(parsed);
                      }
                      setState(() {});
                    },
                    validator: validator.byField(dto, 'percentualOrcamento'),
                  ),
                ),
              ],
            ),
            const AppSpacing(size: AppSpacingSize.md),
            AppColorPickerField(
              selectedColor: dto.cor,
              onChanged: (cor) {
                dto.setCor(cor);
                setState(() {});
              },
            ),
          ],
        ],
      ),
    );
  }
}
