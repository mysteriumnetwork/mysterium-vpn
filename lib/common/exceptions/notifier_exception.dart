/// A failed Notifier public-API call.
///
/// Exists so callers can react to a transport failure without importing Dio.
/// [category] is a coarse bucket for analytics — never a token, key or response
/// body — and is the only thing any caller does with this today.
class NotifierException implements Exception {
  const NotifierException({required this.category, this.statusCode});

  final String category;
  final int? statusCode;

  @override
  String toString() =>
      'NotifierException($category${statusCode == null ? '' : ', status: $statusCode'})';
}
