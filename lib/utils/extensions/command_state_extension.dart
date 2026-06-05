import 'package:result_command/result_command.dart';

/// Extension para facilitar a extração de mensagens de erro do CommandState
extension CommandStateExtension<T extends Object> on CommandState<T> {
  /// Extrai a mensagem de erro de forma simplificada
  /// 
  /// Retorna a mensagem do erro se o comando falhou,
  /// caso contrário retorna a mensagem padrão fornecida.
  /// 
  /// Exemplo:
  /// ```dart
  /// final errorMessage = viewModel.loginCommand.value.getErrorMessage();
  /// SnackBarBase.showError(context, errorMessage);
  /// ```
  String getErrorMessage([String defaultMessage = 'Erro desconhecido']) {
    return when<String>(
      data: (_) => '',
      failure: (exception) => exception?.toString() ?? defaultMessage,
      orElse: () => defaultMessage,
    );
  }

  /// Executa uma ação apenas se o comando falhou
  /// 
  /// Útil para executar callbacks quando há erro sem precisar
  /// verificar isFailure manualmente.
  /// 
  /// Exemplo:
  /// ```dart
  /// viewModel.loginCommand.value.onFailure((exception) {
  ///   SnackBarBase.showError(context, exception?.toString() ?? 'Erro');
  /// });
  /// ```
  void onFailure(void Function(Exception? exception) callback) {
    if (isFailure) {
      when(
        data: (_) => null,
        failure: (exception) {
          callback(exception);
          return null;
        },
        orElse: () => null,
      );
    }
  }

  /// Executa uma ação apenas se o comando foi bem-sucedido
  /// 
  /// Exemplo:
  /// ```dart
  /// viewModel.loginCommand.value.onSuccess((user) {
  ///   SnackBarBase.showSuccess(context, 'Login realizado com sucesso!');
  /// });
  /// ```
  void onSuccess(void Function(T value) callback) {
    if (isSuccess) {
      when(
        data: (value) {
          callback(value);
          return null;
        },
        failure: (_) => null,
        orElse: () => null,
      );
    }
  }

  /// Retorna o valor de sucesso ou null
  /// 
  /// Exemplo:
  /// ```dart
  /// final user = viewModel.loginCommand.value.getValueOrNull();
  /// if (user != null) {
  ///   print('Usuário logado: ${user.name}');
  /// }
  /// ```
  T? getValueOrNull() {
    return when<T?>(
      data: (value) => value,
      failure: (_) => null,
      orElse: () => null,
    );
  }

  /// Retorna a exceção ou null
  /// 
  /// Exemplo:
  /// ```dart
  /// final exception = viewModel.loginCommand.value.getExceptionOrNull();
  /// if (exception != null) {
  ///   logger.error(exception.toString());
  /// }
  /// ```
  Exception? getExceptionOrNull() {
    return when<Exception?>(
      data: (_) => null,
      failure: (exception) => exception,
      orElse: () => null,
    );
  }
}
