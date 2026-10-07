import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/dtos/categoria/categoria_dto.dart';
import 'package:zzuna/domain/enums/categoria_natureza.dart';
import 'package:zzuna/domain/validators/categoria_validator.dart';
import 'package:zzuna/ui/categoria/update/viewmodels/categoria_update_viewmodel.dart';
import 'package:zzuna/ui/shared/feedback/app_dialog.dart';
import 'package:zzuna/ui/shared/feedback/app_snackbar.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_cancel.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_save.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_color_picker_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_dropdown_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_dropdown_menu_item.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_form.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_percent_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_switch_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_text_form_field.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_spacing.dart';
import 'package:zzuna/utils/extensions/command_state_extension.dart';
import 'package:zzuna/utils/extensions/num_extension.dart';

class CategoriaUpdateModal extends ConsumerStatefulWidget {
  final CategoriaDto categoria;
  final bool temSubcategorias;

  const CategoriaUpdateModal({
    super.key,
    required this.categoria,
    this.temSubcategorias = false,
  });

  static void show(
    BuildContext context,
    CategoriaDto categoria, {
    bool temSubcategorias = false,
  }) {
    AppDialog.show(
      context: context,
      child: CategoriaUpdateModal(
        categoria: categoria,
        temSubcategorias: temSubcategorias,
      ),
    );
  }

  @override
  ConsumerState<CategoriaUpdateModal> createState() =>
      _CategoriaUpdateModalState();
}

class _CategoriaUpdateModalState extends ConsumerState<CategoriaUpdateModal> {
  late final CategoriaDto dto;

  final validator = CategoriaValidator<CategoriaDto>();

  late final CategoriaUpdateViewModel viewModel;

  late final TextEditingController _descController;
  late final TextEditingController _percentualController;
  final _descFocus = FocusNode();
  final _naturezaFocus = FocusNode();
  final _paiFocus = FocusNode();
  final _percentualFocus = FocusNode();
  final _ativoFocus = FocusNode();
  final _saveFocus = FocusNode();

  @override
  void initState() {
    super.initState();

    dto = CategoriaDto(
      id: widget.categoria.id,
      descricao: widget.categoria.descricao,
      categoriaPaiId: widget.categoria.categoriaPaiId,
      ativo: widget.categoria.ativo,
      percentualOrcamento: widget.categoria.percentualOrcamento,
      natureza: widget.categoria.natureza,
      cor: widget.categoria.cor,
    );

    viewModel = ref.read(categoriaUpdateViewModelProvider);
    viewModel.updateCommand.addListener(_commandListener);

    _descController = TextEditingController(text: dto.descricao);
    _percentualController = TextEditingController(
      text: dto.percentualOrcamento?.toCleanString() ?? '',
    );

    _descFocus.addListener(() {
      if (_descFocus.hasFocus && _descController.text.isNotEmpty) {
        _descController.selection = TextSelection(
          baseOffset: 0,
          extentOffset: _descController.text.length,
        );
      }
    });
  }

  @override
  void dispose() {
    viewModel.updateCommand.removeListener(_commandListener);

    _descController.dispose();
    _percentualController.dispose();
    _descFocus.dispose();
    _naturezaFocus.dispose();
    _paiFocus.dispose();
    _percentualFocus.dispose();
    _ativoFocus.dispose();
    _saveFocus.dispose();

    super.dispose();
  }

  void _commandListener() {
    final commandValue = viewModel.updateCommand.value;

    commandValue.onSuccess((_) {
      AppSnackBar.showSuccess(context, 'Categoria atualizada com sucesso.');
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
      viewModel.updateCommand.execute(dto);
    }
  }

  @override
  Widget build(BuildContext context) {
    final updateVM = ref.watch(categoriaUpdateViewModelProvider);
    final listVM = ref.watch(categoriaListViewModelProvider);
    // Exclui a própria categoria do dropdown e categorias inativas (a menos que já seja o pai atual)
    final categoriasPai = listVM.categoriasPai
        .where((c) => c.id != dto.id && (c.ativo || c.id == dto.categoriaPaiId))
        .toList();
    final isPai = dto.categoriaPaiId == null;

    return AppForm(
      title: 'Editar Categoria',
      type: AppFormType.modal,
      actions: [
        ButtonCancel(onPressed: () => Navigator.of(context).pop()),
        ListenableBuilder(
          listenable: updateVM.updateCommand,
          builder: (_, _) {
            return ButtonSave(
              focusNode: _saveFocus,
              loading: updateVM.updateCommand.value.isRunning,
              onPressed: updateVM.updateCommand.value.isRunning || !_canSubmit
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
            controller: _descController,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => !widget.temSubcategorias
                ? _paiFocus.requestFocus()
                : (isPai
                      ? _naturezaFocus.requestFocus()
                      : _ativoFocus.requestFocus()),
            onChanged: (value) {
              dto.setDescricao(value);
              setState(() {});
            },
            validator: validator.byField(dto, 'descricao'),
          ),

          const AppSpacing(size: AppSpacingSize.md),

          if (!widget.temSubcategorias) ...[
            AppDropdownFormField<String>(
              label: 'Categoria Pai',
              focusNode: _paiFocus,
              onEnterPressed: () => isPai
                  ? _naturezaFocus.requestFocus()
                  : _ativoFocus.requestFocus(),
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
                  _percentualController.clear();
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
            const AppSpacing(size: AppSpacingSize.md),
          ],

          if (isPai) ...[
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
                    controller: _percentualController,
                    decimalPlaces: 2,
                    textInputAction: TextInputAction.next,
                    onFieldSubmitted: (_) => _ativoFocus.requestFocus(),
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
            const AppSpacing(size: AppSpacingSize.md),
          ],

          AppSwitchField(
            label: 'Ativo',
            focusNode: _ativoFocus,
            onEnterPressed: () => _saveFocus.requestFocus(),
            value: dto.ativo,
            onChanged: (value) {
              dto.setAtivo(value);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
