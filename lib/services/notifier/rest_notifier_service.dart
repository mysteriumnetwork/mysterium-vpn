import 'package:dio/dio.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/services/notifier/notifier_service.dart';
import 'package:talker/talker.dart';

/// Dio-backed [NotifierService].
///
/// The injected Dio must carry the public API key and must NOT carry the
/// user's access token or the refresh-token interceptor.
class RestNotifierService implements NotifierService {
  const RestNotifierService({required Dio dio, required Talker logger})
    : _dio = dio,
      _logger = logger;

  final Dio _dio;
  final Talker _logger;

  @override
  Future<void> registerDevice({
    required String externalUserId,
    required String token,
    required NotifierPlatform platform,
  }) => _send(
    'registerDevice',
    () => _dio.post<Object?>(
      '/public/devices',
      data: {'externalUserId': externalUserId, 'token': token, 'platform': _wireValue(platform)},
    ),
  );

  @override
  Future<void> mergeAttributes({
    required String externalUserId,
    required Map<String, Object?> attributes,
  }) => _send(
    'mergeAttributes',
    () => _dio.put<Object?>(
      '/public/users/${Uri.encodeComponent(externalUserId)}/attributes',
      data: {'attributes': attributes},
    ),
  );

  @override
  Future<void> recordEvent({
    required String token,
    required NotifierEventType type,
    String? campaignId,
    String? journeyStepId,
  }) => _send(
    'recordEvent',
    () => _dio.post<Object?>(
      '/public/events',
      data: {
        'token': token,
        'type': type.name,
        'campaignId': ?campaignId,
        'journeyStepId': ?journeyStepId,
      },
    ),
  );

  Future<void> _send(String operation, Future<void> Function() request) async {
    try {
      await request();
    } on DioException catch (e) {
      final failure = NotifierException(
        category: _categorize(e),
        statusCode: e.response?.statusCode,
      );
      // Expected failure — `warning`, not `handle`, which reports as fatal.
      _logger.warning('Notifier $operation failed: $failure');
      throw failure;
    } catch (e) {
      const failure = NotifierException(category: 'unknown');
      _logger.warning('Notifier $operation failed: $failure');
      throw failure;
    }
  }

  /// Notifier's `Platform` enum is `ios | android | windows | web` — it has no
  /// `macos` and validates the field, so a Mac registers as `ios`. Delivery is
  /// unaffected (Notifier sends through FCM by token, which routes to APNs
  /// regardless), but campaign platform targeting and segments count Macs as
  /// iOS until the API adds `macos`. When it does, map it through and bump
  /// [kNotifierContractVersion] so every device re-registers correctly.
  ///
  /// An exhaustive switch, so adding an enum value breaks the build here rather
  /// than silently sending a name the API rejects.
  String _wireValue(NotifierPlatform platform) => switch (platform) {
    NotifierPlatform.macos || NotifierPlatform.ios => 'ios',
    NotifierPlatform.android => 'android',
  };

  /// Snake_case to match the analytics event vocabulary it ends up in.
  String _categorize(DioException e) => switch (e.type) {
    DioExceptionType.connectionTimeout ||
    DioExceptionType.sendTimeout ||
    DioExceptionType.receiveTimeout => 'timeout',
    DioExceptionType.badResponse => _fromStatus(e.response?.statusCode),
    _ => 'network',
  };

  String _fromStatus(int? status) => switch (status) {
    null => 'invalid_response',
    401 || 403 => 'unauthorized',
    404 => 'not_found',
    >= 500 => 'server',
    >= 400 => 'bad_request',
    _ => 'invalid_response',
  };
}
