class WireguardConnectException implements Exception {
  WireguardConnectException(this.message);
  final String message;
  final int code = 503;
  @override
  String toString() => '$message!';
}
