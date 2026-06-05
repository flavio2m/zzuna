abstract class AppException implements Exception {
  final String message;
  final StackTrace? stackTrace;

  AppException(this.message, [this.stackTrace]);

  @override
  String toString() {
    if (stackTrace != null) {
      return '$message ($runtimeType) (\nStackTrace: $stackTrace)';
    }
    return '$message ($runtimeType)';
  }
}
