import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/dtos/cartao_dto.dart';
import 'package:zzuna/ui/shared/feedback/app_dialog.dart';
import 'package:zzuna/ui/shared/feedback/app_snackbar.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_save.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_banco_dropdown.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_form.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_status_dropdown.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_text_form_field.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_spacing.dart';
import 'package:zzuna/utils/extensions/command_state_extension.dart';

class CartaoUpdateModal extends ConsumerStatefulWidget {
  final CartaoDto cartao;

  const CartaoUpdateModal({super.key, required this.cartao});

  static void show(BuildContext context, CartaoDto cartao) {
    AppDialog.show(
      context,
      child: CartaoUpdateModal(cartao: cartao),
    );
  }

  @override
  ConsumerState<CartaoUpdateModal> createState() => _CartaoUpdateModalState();
}

class _CartaoUpdateModalState extends ConsumerState<CartaoUpdateModal> {
  late final CartaoDto dto;

  @override
  void initState() {
    super.initState();
    dto = CartaoDto(
      id: widget.cartao.id,
      descricao: widget.cartao.descricao,
      limite: widget.cartao.limite,
      bancoSigla: widget.cartao.bancoSigla,
      ativo: widget.cartao.ativo,
      diaFechamento: widget.cartao.diaFechamento,
    );
    final viewModel = ref.read(cartaoUpdateViewModelProvider);
    viewModel.updateCommand.addListener(_commandListener);
  }

  @override
  void dispose() {
    final viewModel = ref.read(cartaoUpdateViewModelProvider);
    viewModel.updateCommand.removeListener(_commandListener);
    super.dispose();
  }

  void _commandListener() {
    final viewModel = ref.read(cartaoUpdateViewModelProvider);
    final commandValue = viewModel.updateCommand.value;

    commandValue.onSuccess((_) {
      AppSnackBar.showSuccess(context, 'Cartão atualizado com sucesso');
      Navigator.pop(context);
    });

    commandValue.onFailure((exception) {
      AppSnackBar.showError(context, exception.toString());
    });
  }

  bool get _canSubmit {
    return dto.descricao.isNotEmpty && dto.bancoSigla.isNotEmpty;
  }

  void _handleSubmit() {
    if (_canSubmit) {
      ref.read(cartaoUpdateViewModelProvider).updateCommand.execute(dto);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = ref.watch(cartaoUpdateViewModelProvider);

    return AppForm(
      title: 'Editar Cartão',
      type: AppFormType.modal,
      actions: [
        ListenableBuilder(
          listenable: viewModel.updateCommand,
          builder: (context, _) {
            return ButtonSave(
              onPressed: viewModel.updateCommand.value.isRunning || !_canSubmit ? null : _handleSubmit,
            );
          },
        ),
      ],
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          AppTextFormField(
            label: 'Descrição',
            initialValue: dto.descricao,
            onChanged: (value) {
              dto.setDescricao(value);
              setState(() {});
            },
          ),
          const AppSpacing(size: AppSpacingSize.md),
          Row(
            children: [
              Expanded(
                child: AppTextFormField(
                  label: 'Limite',
                  initialValue: dto.limite.toString(),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    dto.setLimite(double.tryParse(value) ?? 0);
                    setState(() {});
                  },
                ),
              ),
              const AppSpacing(size: AppSpacingSize.md, isHorizontal: true),
              Expanded(
                child: AppTextFormField(
                  label: 'Dia Fechamento',
                  initialValue: dto.diaFechamento.toString(),
                  keyboardType: TextInputType.number,
                  onChanged: (value) {
                    dto.setDiaFechamento(int.tryParse(value) ?? 1);
                    setState(() {});
                  },
                ),
              ),
            ],
          ),
          const AppSpacing(size: AppSpacingSize.md),
          AppBancoDropdown(
            value: dto.bancoSigla,
            onChanged: (value) {
              dto.setBancoSigla(value ?? '');
              setState(() {});
            },
          ),
          const AppSpacing(size: AppSpacingSize.md),
          AppStatusDropdown(
            value: dto.ativo,
            onChanged: (value) {
              dto.setAtivo(value ?? true);
              setState(() {});
            },
          ),
        ],
      ),
    );
  }
}
