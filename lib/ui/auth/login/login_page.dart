import 'package:zzuna/config/providers.dart';
import 'package:zzuna/domain/dtos/user/credentials.dart';
import 'package:zzuna/domain/validators/credentials_validator.dart';
import 'package:zzuna/ui/auth/login/viewmodels/login_viewmodel.dart';
import 'package:zzuna/ui/auth/register/widgets/register_modal.dart';
import 'package:zzuna/ui/shared/feedback/app_dialog.dart';
import 'package:zzuna/ui/shared/feedback/app_snackbar.dart';
import 'package:zzuna/ui/shared/widgets/buttons/app_button.dart';
import 'package:zzuna/ui/shared/widgets/buttons/app_textbutton.dart';
import 'package:zzuna/ui/shared/widgets/cards/app_card.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_form.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_text_form_field.dart';
import 'package:zzuna/ui/shared/widgets/forms/app_email_form_field.dart';
import 'package:zzuna/ui/shared/widgets/layout/app_spacing.dart';
import 'package:zzuna/utils/extensions/command_state_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  late final LoginViewModel viewModel;
  final validator = CredentialsValidator();
  final Credentials credentials = Credentials();

  @override
  void initState() {
    super.initState();
    viewModel = ref.read(loginViewModelProvider);
    viewModel.loginCommand.addListener(_listenableListener);
  }

  void _listenableListener() {
    viewModel.loginCommand.value.onFailure((exception) {
      AppSnackBar.showError(context, exception?.toString() ?? 'Erro');
    });
  }

  void _showRegisterModal() {
    AppDialog.show(context: context, child: const RegisterModal());
  }

  @override
  void dispose() {
    viewModel.loginCommand.removeListener(_listenableListener);
    super.dispose();
  }

  bool get _canSubmit {
    return validator.validate(credentials).isValid;
  }

  void _handleRegister() {
    if (validator.validate(credentials).isValid) {
      viewModel.loginCommand.execute(credentials);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SizedBox(
          width: 400,
          child: AppCard(
            variant: AppCardVariant.flat,
            child: AppForm(
              actionsLayout: AppFormActionsLayout.column,
              actions: [
                ListenableBuilder(
                  listenable: viewModel.loginCommand,
                  builder: (_, _) {
                    final isLoading = viewModel.loginCommand.value.isRunning;

                    return AppButton(
                      label: isLoading ? 'Entrando...' : 'Entrar',
                      icon: const Icon(Icons.login),
                      onPressed: isLoading || !_canSubmit ? null : _handleRegister,
                      loading: isLoading,
                      textStyle: TextStyle(
                        color: Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold, //
                      ),
                    );
                  },
                ),
                AppTextButton(
                  onPressed: _showRegisterModal,
                  label: 'Não tem conta? Cadastre-se', //
                ),
              ],
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const FlutterLogo(size: 100),

                  AppSpacing(size: AppSpacingSize.md),

                  AppEmailFormField(
                    label: 'E-mail',
                    icon: Icons.email,
                    onChanged: (value) {
                      credentials.setEmail(value);
                      setState(() {});
                    },
                    validator: validator.byField(credentials, 'email'),
                  ),

                  AppSpacing(size: AppSpacingSize.md),

                  AppTextFormField(
                    label: 'Senha',
                    icon: Icons.lock,
                    obscureText: true,
                    onChanged: (value) {
                      credentials.setPassword(value);
                      setState(() {});
                    },
                    validator: validator.byField(credentials, 'password'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
