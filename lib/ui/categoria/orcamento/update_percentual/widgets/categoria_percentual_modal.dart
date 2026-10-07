import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/entities/categoria_entity.dart';
import 'package:zzuna/ui/categoria/orcamento/update_percentual/viewmodels/categoria_percentual_viewmodel.dart';
import 'package:zzuna/ui/shared/feedback/app_dialog.dart';
import 'package:zzuna/ui/shared/feedback/app_snackbar.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_cancel.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_save.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_form.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_percent_form_field.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_spacing.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';
import 'package:zzuna/utils/extensions/command_state_extension.dart';
import 'package:zzuna/utils/extensions/num_extension.dart';

class CategoriaPercentualModal extends ConsumerStatefulWidget {
  final Categoria categoria;

  const CategoriaPercentualModal({super.key, required this.categoria});

  static Future<double?> show(BuildContext context, Categoria categoria) {
    return AppDialog.show<double>(
      context: context,
      child: CategoriaPercentualModal(categoria: categoria),
    );
  }

  @override
  ConsumerState<CategoriaPercentualModal> createState() =>
      _CategoriaPercentualModalState();
}

class _CategoriaPercentualModalState
    extends ConsumerState<CategoriaPercentualModal> {
  late final TextEditingController _controller;
  late final CategoriaPercentualViewModel viewModel;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    final p = widget.categoria.percentualOrcamento;
    _controller = TextEditingController(text: p?.toCleanString() ?? '0');
    viewModel = ref.read(categoriaPercentualViewModelProvider);
    viewModel.updatePercentualCommand.addListener(_commandListener);
  }

  @override
  void dispose() {
    viewModel.updatePercentualCommand.removeListener(_commandListener);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _commandListener() {
    final commandValue = viewModel.updatePercentualCommand.value;

    commandValue.onSuccess((result) {
      AppSnackBar.showSuccess(
        context,
        'Percentual de ${widget.categoria.descricao} atualizado.',
      );
      Navigator.pop(context, result.percentualOrcamento);
    });

    commandValue.onFailure((exception) {
      AppSnackBar.showError(context, exception.toString());
    });
  }

  void _handleSubmit() {
    final clean = _controller.text.replaceAll(',', '.');
    final parsed = double.tryParse(clean);
    if (parsed != null && parsed >= 0 && parsed <= 100) {
      viewModel.updatePercentualCommand.execute((
        categoria: widget.categoria,
        percentual: parsed,
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    final isRunning = viewModel.updatePercentualCommand.value.isRunning;

    return AppForm(
      title: 'Editar Percentual',
      type: AppFormType.modal,
      actions: [
        ButtonCancel(onPressed: () => Navigator.pop(context)),
        ButtonSave(
          loading: isRunning,
          onPressed: isRunning ? null : _handleSubmit,
        ),
      ],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          AppText(
            'Defina o percentual destinado a '
            '${widget.categoria.descricao} (entre 0 e 100%):',
            variant: AppTextVariant.body,
            color: AppColors.slate600,
          ),
          const AppSpacing(size: AppSpacingSize.md),
          AppPercentFormField(
            label: 'Percentual',
            controller: _controller,
            focusNode: _focusNode,
            autofocus: true,
            min: 0,
            max: 100,
            decimalPlaces: 2,
            onFieldSubmitted: (_) => _handleSubmit(),
          ),
        ],
      ),
    );
  }
}
