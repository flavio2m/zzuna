import 'package:zzuna/ui/shared/theme/app_colors.dart';
import 'package:flutter/material.dart';

/// Enum para definir os tipos de mensagem do SnackBar
enum SnackBarType {
  /// Mensagem de erro (vermelho)
  error,

  /// Mensagem de sucesso (verde)
  success,

  /// Mensagem de aviso (laranja/amarelo)
  warning,

  /// Mensagem informativa (azul)
  info,
}

/// Classe base para exibir SnackBars padronizados no projeto
class AppSnackBar {
  /// Exibe um SnackBar com as configurações baseadas no tipo
  static void show({
    required BuildContext context,
    required String message,
    required SnackBarType type,
    Duration duration = const Duration(seconds: 3),
    SnackBarAction? action,
  }) {
    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(_getIcon(type), color: AppColors.surface, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: const TextStyle(color: AppColors.surface, fontSize: 14),
            ),
          ),
        ],
      ),
      backgroundColor: _getColor(type),
      duration: duration,
      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      action: action,
    );

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(snackBar);
  }

  /// Atalho para exibir mensagem de erro
  static void showError(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context: context,
      message: message,
      type: SnackBarType.error,
      duration: duration,
    );
  }

  /// Atalho para exibir mensagem de sucesso
  static void showSuccess(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context: context,
      message: message,
      type: SnackBarType.success,
      duration: duration,
    );
  }

  /// Atalho para exibir mensagem de aviso
  static void showWarning(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context: context,
      message: message,
      type: SnackBarType.warning,
      duration: duration,
    );
  }

  /// Atalho para exibir mensagem informativa
  static void showInfo(
    BuildContext context,
    String message, {
    Duration duration = const Duration(seconds: 3),
  }) {
    show(
      context: context,
      message: message,
      type: SnackBarType.info,
      duration: duration,
    );
  }

  /// Retorna a cor baseada no tipo de mensagem
  static Color _getColor(SnackBarType type) {
    return switch (type) {
      SnackBarType.error => AppColors.danger,
      SnackBarType.success => AppColors.primary,
      SnackBarType.warning => AppColors.warning,
      SnackBarType.info => AppColors.indigo600,
    };
  }

  /// Retorna o ícone baseado no tipo de mensagem
  static IconData _getIcon(SnackBarType type) {
    return switch (type) {
      SnackBarType.error => Icons.error_outline,
      SnackBarType.success => Icons.check_circle_outline,
      SnackBarType.warning => Icons.warning_amber_outlined,
      SnackBarType.info => Icons.info_outline,
    };
  }
}
