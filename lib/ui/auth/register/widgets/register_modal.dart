import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/dtos/user/register_user_dto.dart';
import 'package:zzuna/domain/validators/register_user_dto_validator.dart';
import 'package:zzuna/ui/auth/register/viewmodels/register_viewmodel.dart';
import 'package:zzuna/ui/shared/feedback/app_snackbar.dart';
import 'package:zzuna/ui/shared/widgets/buttons/app_button.dart';
import 'package:zzuna/ui/shared/widgets/buttons/button_cancel.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_form.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_text_form_field.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_spacing.dart';
import 'package:zzuna/utils/extensions/command_state_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterModal extends ConsumerStatefulWidget {
  const RegisterModal({super.key});

  @override
  ConsumerState<RegisterModal> createState() => _RegisterModalState();
}

class _RegisterModalState extends ConsumerState<RegisterModal> {
  late final RegisterViewModel viewModel;
  final validator = RegisterUserDtoValidator();
  final dto = RegisterUserDto(name: '', email: '', password: '');

  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    viewModel = ref.read(registerViewModelProvider);
    viewModel.registerCommand.addListener(_commandListener);
  }

  void _commandListener() {
    final commandValue = viewModel.registerCommand.value;

    // Tratar sucesso - fecha o modal
    commandValue.onSuccess((user) {
      Navigator.of(context).pop(); // Fecha o modal
      AppSnackBar.showSuccess(
        context,
        'Cadastro realizado com sucesso! Bem-vindo, ${user.name}!', //
      );
    });

    // Tratar erro
    commandValue.onFailure((exception) {
      AppSnackBar.showError(context, exception.toString());
    });
  }

  @override
  void dispose() {
    viewModel.registerCommand.removeListener(_commandListener);
    super.dispose();
  }

  bool get _canSubmit {
    return validator.validate(dto).isValid;
  }

  void _handleRegister() {
    if (validator.validate(dto).isValid) {
      viewModel.registerCommand.execute(dto);
    }
  }

  Widget _divider() {
    return AppSpacing(size: AppSpacingSize.sm);
  }

  @override
  Widget build(BuildContext context) {
    return AppForm(
      formKey: formKey,
      type: AppFormType.modal,
      title: 'Cadastrar',
      actions: [
        ButtonCancel(onPressed: () => Navigator.of(context).pop()),
        ListenableBuilder(
          listenable: viewModel.registerCommand,
          builder: (_, _) {
            final isLoading = viewModel.registerCommand.value.isRunning;

            return AppButton(
              label: isLoading ? 'Cadastrando...' : 'Cadastrar',
              icon: const Icon(Icons.person_add),
              onPressed: isLoading || !_canSubmit ? null : _handleRegister,
              loading: isLoading,
            );
          },
        ),
      ],
      child: Column(
        children: [
          AppTextFormField(
            label: 'Nome',
            icon: Icons.person,
            onChanged: (value) {
              dto.setName(value);
              setState(() {});
            },
            validator: validator.byField(dto, 'name'),
          ),

          _divider(),

          _divider(),

          AppTextFormField(
            label: 'Senha',
            icon: Icons.lock,
            obscureText: true,
            onChanged: (value) {
              dto.setPassword(value);
              setState(() {});
            },
            validator: validator.byField(dto, 'password'),
          ),
        ],
      ),
    );
  }
}
