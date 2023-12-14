class NoInternetConnectionException implements Exception {
  NoInternetConnectionException(this.message);
  final String message;
  @override
  String toString() => '$message!';
}
