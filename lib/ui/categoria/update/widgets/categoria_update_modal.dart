import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/dtos/categoria/categoria_dto.dart';

import 'package:zzuna/domain/validators/categoria_validator.dart';
import 'package:zzuna/ui/categoria/update/viewmodels/categoria_update_viewmodel.dart';
import 'package:zzuna/ui/shared/feedback/app_dialog.dart';
import 'package:zzuna/ui/shared/feedback/app_snackbar.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_cancel.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_save.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_dropdown_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_dropdown_menu_item.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_form.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_switch_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_text_form_field.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_spacing.dart';
import 'package:zzuna/utils/extensions/command_state_extension.dart';

class CategoriaUpdateModal extends ConsumerStatefulWidget {
  final CategoriaDto categoria;
  final bool temSubcategorias;

  const CategoriaUpdateModal({
    super.key,
    required this.categoria,
    this.temSubcategorias = false, //
  });

  static void show(
    BuildContext context,
    CategoriaDto categoria, {
    bool temSubcategorias = false, //
  }) {
    AppDialog.show(
      context: context,
      child: CategoriaUpdateModal(
        categoria: categoria,
        temSubcategorias: temSubcategorias, //
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
  final _descFocus = FocusNode();
  final _paiFocus = FocusNode();
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
    );

    viewModel = ref.read(categoriaUpdateViewModelProvider);
    viewModel.updateCommand.addListener(_commandListener);

    _descController = TextEditingController(text: dto.descricao);
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
    _descFocus.dispose();
    _paiFocus.dispose();
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
    // Exclui a própria categoria do dropdown para não criar ciclo
    final categoriasPai = listVM.categoriasPai
        .where((c) => c.id != dto.id)
        .toList();

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
        children: [
          AppTextFormField(
            label: 'Descrição',
            autofocus: true,
            focusNode: _descFocus,
            controller: _descController,
            textInputAction: TextInputAction.next,
            onFieldSubmitted: (_) => widget.temSubcategorias
                ? _ativoFocus.requestFocus()
                : _paiFocus.requestFocus(),
            onChanged: (value) {
              dto.setDescricao(value);
              setState(() {});
            },
            validator: validator.byField(dto, 'descricao'),
          ),

          const AppSpacing(size: AppSpacingSize.md),

          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              if (!widget.temSubcategorias) ...[
                Expanded(
                  flex: 2,
                  child: AppDropdownFormField<String>(
                    label: 'Categoria Pai',
                    focusNode: _paiFocus,
                    onEnterPressed: () => _ativoFocus.requestFocus(),
                    value: dto.categoriaPaiId,
                    items: [
                      AppDropdownMenuItem<String>(
                        value: '',
                        label: 'Selecione...',
                      ),
                      ...categoriasPai.map(
                        (cat) => AppDropdownMenuItem<String>(
                          value: cat.id,
                          label: cat.descricao, //
                        ),
                      ),
                    ],
                    onChanged: (value) {
                      dto.setCategoriaPaiId(
                        value == null || value.isEmpty ? null : value,
                      );
                      setState(() {});
                    },
                  ),
                ),
                const AppSpacing(
                  size: AppSpacingSize.md,
                  axis: Axis.horizontal,
                ),
              ],
              Expanded(
                flex: 1,
                child: AppSwitchField(
                  label: 'Ativo',
                  focusNode: _ativoFocus,
                  onEnterPressed: () => _saveFocus.requestFocus(),
                  value: dto.ativo,
                  onChanged: (value) {
                    dto.setAtivo(value);
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
