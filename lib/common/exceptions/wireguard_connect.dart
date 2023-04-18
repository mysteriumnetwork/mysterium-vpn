class WireguardConnectException implements Exception {
  WireguardConnectException(this.message);
  final String message;
  final int code = 500;
  @override
  String toString() => '$message!';
}
