class ApiException implements Exception {
  ApiException(this.message, this.code, this.identifier);
  String message;
  String identifier;
  final int code;
  @override
  String toString() => '$message!';
}
