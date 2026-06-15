import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/dtos/categoria/categoria_dto.dart';

import 'package:zzuna/domain/validators/categoria_validator.dart';
import 'package:zzuna/ui/categoria/create/viewModels/categoria_create_viewmodel.dart';
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

class CategoriaCreateModal extends ConsumerStatefulWidget {
  const CategoriaCreateModal({super.key});

  static void show(BuildContext context) {
    AppDialog.show(context: context, child: const CategoriaCreateModal());
  }

  @override
  ConsumerState<CategoriaCreateModal> createState() => _CategoriaCreateModalState();
}

class _CategoriaCreateModalState extends ConsumerState<CategoriaCreateModal> {
  final dto = CategoriaDto();

  final validator = CategoriaValidator<CategoriaDto>();

  late final CategoriaCreateViewModel viewModel;

  @override
  void initState() {
    super.initState();

    viewModel = ref.read(categoriaCreateViewModelProvider);

    viewModel.createCommand.addListener(_commandListener);
  }

  @override
  void dispose() {
    viewModel.createCommand.removeListener(_commandListener);

    super.dispose();
  }

  void _commandListener() {
    final commandValue = viewModel.createCommand.value;

    commandValue.onSuccess((_) {
      AppSnackBar.showSuccess(context, 'Categoria criada com sucesso');

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
    final categoriasPai = listVM.categoriasPai;

    return AppForm(
      title: 'Nova Categoria',
      type: AppFormType.modal,
      actions: [
        ButtonCancel(onPressed: () => Navigator.of(context).pop()),

        ListenableBuilder(
          listenable: createVM.createCommand,
          builder: (_, _) {
            return ButtonSave(
              onPressed: createVM.createCommand.value.isRunning || !_canSubmit ? null : _handleSubmit,
            );
          },
        ),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextFormField(
            label: 'Descrição',
            onChanged: (value) {
              dto.setDescricao(value);
              setState(() {});
            },
            validator: validator.byField(dto, 'descricao'),
          ),

          const AppSpacing(size: AppSpacingSize.md),

          AppDropdownFormField<String>(
            label: 'Categoria Pai',
            value: dto.categoriaPaiId,
            items: [
              AppDropdownMenuItem<String>(value: '', label: 'Selecione...'),
              ...categoriasPai.map(
                (cat) => AppDropdownMenuItem<String>(
                  value: cat.id,
                  label: cat.descricao,
                ),
              ),
            ],
            onChanged: (value) {
              dto.setCategoriaPaiId(value == null || value.isEmpty ? null : value);
              setState(() {});
            },
          ),

          const AppSpacing(size: AppSpacingSize.md),

          AppSwitchField(
            label: 'Ativo',
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
