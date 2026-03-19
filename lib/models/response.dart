class Response {
  Response({required this.statusCode, this.statusMessage, this.data = const {}});
  final int statusCode;
  final String? statusMessage;
  final dynamic data;
  @override
  String toString() => 'statusCode=$statusCode\nstatusMessage=$statusMessage\n data=$data';
}
