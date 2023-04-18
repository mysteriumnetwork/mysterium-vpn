class ApiException implements Exception {
  ApiException(this.message, this.code);
  String message;
  final int code;
  @override
  String toString() => '$message!';
}
