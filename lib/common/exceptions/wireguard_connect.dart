class WireguardConnectException implements Exception {
  WireguardConnectException(this.message);
  final String message;
  final int code = 1111;
  @override
  String toString() => '$message!';
}
