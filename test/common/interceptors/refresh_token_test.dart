import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/common/interceptors/refresh_token.dart';
import 'package:mysterium_vpn/common/interceptors/retry_request.dart';
import 'package:talker/talker.dart';

/// Answers 401 once, then 200, and keeps what it was asked.
class _ExpiredOnceAdapter implements HttpClientAdapter {
  final requests = <RequestOptions>[];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    requests.add(options);
    return ResponseBody.fromString(
      '{}',
      requests.length == 1 ? 401 : 200,
      headers: {
        Headers.contentTypeHeader: [Headers.jsonContentType],
      },
    );
  }

  @override
  void close({bool force = false}) {}
}

void main() {
  late Dio dio;
  late _ExpiredOnceAdapter adapter;

  setUp(() {
    adapter = _ExpiredOnceAdapter();
    dio = Dio(BaseOptions(baseUrl: 'https://api.test'))..httpClientAdapter = adapter;
    dio.interceptors.add(
      RefreshTokenInterceptor(
        dio: dio,
        logger: Talker(settings: TalkerSettings(useConsoleLogs: false)),
      ),
    );
    refreshTokenCallback = () async {};
  });

  tearDown(() => refreshTokenCallback = null);

  test('replays the request once the token is refreshed', () async {
    final response = await dio.get<dynamic>('/subscription');

    expect(response.statusCode, 200);
    expect(adapter.requests, hasLength(2));
  });

  test("the replay is still the caller's request", () async {
    // A replay that dropped these would outlive a cancel and be retried.
    final token = CancelToken();

    await dio.get<dynamic>(
      '/connection/disconnect',
      cancelToken: token,
      options: Options(extra: kNoRetryExtra),
    );

    expect(adapter.requests[1].cancelToken, same(token));
    expect(adapter.requests[1].disableRetry, isTrue);
  });

  test('a request cancelled while the token was refreshing is not replayed', () async {
    final token = CancelToken();
    refreshTokenCallback = () async => token.cancel();

    await expectLater(
      dio.get<dynamic>('/connection/disconnect', cancelToken: token),
      throwsA(isA<DioException>().having((e) => e.type, 'type', DioExceptionType.cancel)),
    );
    await pumpEventQueue();

    expect(adapter.requests, hasLength(1));
  });
}
