class ApiException implements Exception {
  ApiException(this.message);
  final String message;

  @override
  String toString() => '$message!';
}
