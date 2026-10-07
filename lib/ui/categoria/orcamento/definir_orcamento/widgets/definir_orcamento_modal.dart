import 'package:brasil_fields/brasil_fields.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/entities/user_entity.dart';
import 'package:zzuna/ui/categoria/orcamento/definir_orcamento/viewmodels/definir_orcamento_viewmodel.dart';
import 'package:zzuna/ui/shared/feedback/app_dialog.dart';
import 'package:zzuna/ui/shared/feedback/app_snackbar.dart';
import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_cancel.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_save.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_currency_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_form.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_spacing.dart';
import 'package:zzuna/ui/shared/widgets/texts/app_text.dart';
import 'package:zzuna/utils/extensions/command_state_extension.dart';

class DefinirOrcamentoModal extends ConsumerStatefulWidget {
  final User user;
  final double orcamentoAtual;

  const DefinirOrcamentoModal({
    super.key,
    required this.user,
    required this.orcamentoAtual,
  });

  static void show(BuildContext context, User user, double orcamentoAtual) {
    AppDialog.show(
      context: context,
      child: DefinirOrcamentoModal(user: user, orcamentoAtual: orcamentoAtual),
    );
  }

  @override
  ConsumerState<DefinirOrcamentoModal> createState() =>
      _DefinirOrcamentoModalState();
}

class _DefinirOrcamentoModalState extends ConsumerState<DefinirOrcamentoModal> {
  late final TextEditingController _controller;
  late final DefinirOrcamentoViewModel viewModel;
  final _focusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(
      text: widget.orcamentoAtual > 0
          ? UtilBrasilFields.obterReal(widget.orcamentoAtual, moeda: false)
          : '',
    );
    viewModel = ref.read(definirOrcamentoViewModelProvider);
    viewModel.updateOrcamentoCommand.addListener(_commandListener);
  }

  @override
  void dispose() {
    viewModel.updateOrcamentoCommand.removeListener(_commandListener);
    _controller.dispose();
    _focusNode.dispose();
    super.dispose();
  }

  void _commandListener() {
    final commandValue = viewModel.updateOrcamentoCommand.value;

    commandValue.onSuccess((_) {
      AppSnackBar.showSuccess(context, 'Orçamento atualizado com sucesso.');
      Navigator.pop(context);
    });

    commandValue.onFailure((exception) {
      AppSnackBar.showError(context, exception.toString());
    });
  }

  void _handleSubmit() {
    final text = _controller.text;
    final valor = UtilBrasilFields.converterMoedaParaDouble(text);
    viewModel.updateOrcamentoCommand.execute((
      user: widget.user,
      orcamento: valor,
    ));
  }

  @override
  Widget build(BuildContext context) {
    final isRunning = viewModel.updateOrcamentoCommand.value.isRunning;

    return AppForm(
      title: widget.orcamentoAtual > 0
          ? 'Editar Orçamento'
          : 'Definir Orçamento',
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
          const AppText(
            'Informe o valor total mensal usado como base para cálculo das '
            'categorias:',
            variant: AppTextVariant.body,
            color: AppColors.slate600,
          ),
          const AppSpacing(size: AppSpacingSize.md),
          AppCurrencyFormField(
            label: 'Valor do Orçamento Mensal',
            controller: _controller,
            focusNode: _focusNode,
            autofocus: true,
            onFieldSubmitted: (_) => _handleSubmit(),
          ),
        ],
      ),
    );
  }
}
