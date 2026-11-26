import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/interceptors/retry_request.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/services/discovery/discovery_adapter.dart';
import 'package:talker/talker.dart';

import 'discovery_fakes.dart';

void main() {
  test('logs actual fallback hosts and cached routing without request secrets', () async {
    final logger = Talker(settings: TalkerSettings(useConsoleLogs: false));
    final source = DiscoveryTestAdapter((_, _) async => jsonResponse(await discoveryJson()));
    final discovery = testDiscovery(source, logger: logger);
    addTearDown(discovery.close);
    final transport = DiscoveryTestAdapter((request, _) async {
      if (request.uri.host == apiHost) {
        throw DioException.connectionError(requestOptions: request, reason: 'token=error-secret');
      }
      return jsonResponse('{}');
    });
    final dio = Dio()..httpClientAdapter = DiscoveryAdapter(transport, discovery, logger: logger);
    const url = 'https://$apiHost/api/v1/test?access_token=query-secret';
    await dio.get<Object?>(
      url,
      options: Options(headers: {'Authorization': 'Bearer header-secret'}),
    );
    await dio.get<Object?>(url);
    expect(transport.calls.map((it) => it.uri.host), [
      apiHost,
      alternativeApiHost,
      alternativeApiHost,
    ]);
    final logs = logger.history.map((it) => it.message).join('\n');
    expect(logs, contains('endpoint failed: https://$apiHost (connectionError)'));
    expect(logs, contains('https://$apiHost -> https://$alternativeApiHost (retry)'));
    expect(logs, contains('https://$apiHost -> https://$alternativeApiHost (cached selection)'));
    expect(
      logs,
      contains('fallback response: https://$apiHost -> https://$alternativeApiHost (HTTP 200)'),
    );
    expect(logs, isNot(contains('query-secret')));
    expect(logs, isNot(contains('header-secret')));
    expect(logs, isNot(contains('error-secret')));
  });

  test('fails over before application interceptors while preserving request data', () async {
    final source = DiscoveryTestAdapter((_, _) async => jsonResponse(await discoveryJson()));
    final discovery = testDiscovery(source);
    addTearDown(discovery.close);
    final transport = DiscoveryTestAdapter((request, body) async {
      if (request.uri.host == apiHost) {
        throw DioException.connectionTimeout(
          requestOptions: request,
          timeout: const Duration(seconds: 5),
        );
      }
      expect(request.method, 'POST');
      expect(request.uri.path, '/api/v1/login');
      expect(request.uri.query, 'continue_to=%2Fdashboard');
      expect(request.headers['Authorization'], 'Bearer api-token');
      final bytes = await body!.expand((it) => it).toList();
      expect(jsonDecode(utf8.decode(bytes)), {'email': 'user@example.com'});
      return jsonResponse('{"ok":true}');
    });
    final dio = Dio(
      BaseOptions(
        baseUrl: 'https://$apiHost/api/v1',
        headers: {'Authorization': 'Bearer api-token'},
      ),
    )..httpClientAdapter = DiscoveryAdapter(transport, discovery);
    final response = await dio.post<Object?>(
      '/login?continue_to=%2Fdashboard',
      data: {'email': 'user@example.com'},
    );
    expect(response.statusCode, 200);
    expect(transport.calls.map((it) => it.uri.host), [apiHost, alternativeApiHost]);
  });

  test('idempotent requests fail over on blocking and server responses', () async {
    // 451 is unambiguous whatever the body; 403 and 5xx only count as blocking
    // when the body is not the JSON our own backend answers with.
    final blocking = <ResponseBody Function()>[
      () => jsonResponse('{}', 451),
      () => htmlResponse('<html>blocked</html>'),
      () => htmlResponse('<html>bad gateway</html>', 503),
    ];
    for (final blocked in blocking) {
      final source = DiscoveryTestAdapter((_, _) async => jsonResponse(await discoveryJson()));
      final discovery = testDiscovery(source);
      addTearDown(discovery.close);
      final transport = DiscoveryTestAdapter(
        (request, _) async => request.uri.host == apiHost ? blocked() : jsonResponse('{}'),
      );
      final dio = Dio()..httpClientAdapter = DiscoveryAdapter(transport, discovery);
      expect((await dio.get<Object?>('https://$apiHost/api/v1/test')).statusCode, 200);
      expect(transport.calls.length, 2);
    }
  });

  test('a broken response stream can fail over without mixing response bytes', () async {
    final source = DiscoveryTestAdapter((_, _) async => jsonResponse(await discoveryJson()));
    final discovery = testDiscovery(source);
    addTearDown(discovery.close);
    final transport = DiscoveryTestAdapter((request, _) async {
      if (request.uri.host == apiHost) {
        Stream<Uint8List> broken() async* {
          yield Uint8List.fromList(utf8.encode('{broken'));
          throw const HttpException('Response interrupted');
        }

        return ResponseBody(broken(), 200);
      }
      return jsonResponse('{"ok":true}');
    });
    final dio = Dio()..httpClientAdapter = DiscoveryAdapter(transport, discovery);
    final response = await dio.get<Map<String, dynamic>>('https://$apiHost/test');
    expect(response.data, {'ok': true});
    expect(transport.calls.length, 2);
  });

  test('normal application errors bypass discovery', () async {
    for (final status in [400, 401, 404, 429]) {
      final source = DiscoveryTestAdapter((_, _) async => jsonResponse(await discoveryJson()));
      final discovery = testDiscovery(source);
      addTearDown(discovery.close);
      final transport = DiscoveryTestAdapter((_, _) async => jsonResponse('{}', status));
      final dio = Dio()..httpClientAdapter = DiscoveryAdapter(transport, discovery);
      await expectLater(dio.get<Object?>('https://$apiHost/test'), throwsA(isA<DioException>()));
      expect(source.calls, isEmpty);
      expect(transport.calls.length, 1);
    }
  });

  test('consumed POST bodies and explicitly disabled retries are not replayed', () async {
    for (final disable in [false, true]) {
      final source = DiscoveryTestAdapter((_, _) async => jsonResponse(await discoveryJson()));
      final discovery = testDiscovery(source);
      addTearDown(discovery.close);
      final transport = DiscoveryTestAdapter((request, body) async {
        if (!disable) {
          await body!.drain<void>();
        }
        throw DioException.receiveTimeout(
          requestOptions: request,
          timeout: const Duration(seconds: 15),
        );
      });
      final dio = Dio()..httpClientAdapter = DiscoveryAdapter(transport, discovery);
      final options = Options()..disableRetry = disable;
      await expectLater(
        dio.post<Object?>('https://$apiHost/payment', data: {'amount': 1}, options: options),
        throwsA(isA<DioException>()),
      );
      expect(transport.calls.length, 1);
      expect(source.calls, isEmpty);
    }
  });

  test('an already listened empty upload stream is not replayed', () async {
    final source = DiscoveryTestAdapter((_, _) async => jsonResponse(await discoveryJson()));
    final discovery = testDiscovery(source);
    addTearDown(discovery.close);
    final transport = DiscoveryTestAdapter((request, body) async {
      await body!.drain<void>();
      throw DioException.connectionError(requestOptions: request, reason: 'Lost connection');
    });
    final dio = Dio()..httpClientAdapter = DiscoveryAdapter(transport, discovery);
    await expectLater(
      dio.post<Object?>('https://$apiHost/payment', data: const Stream<Uint8List>.empty()),
      throwsA(isA<DioException>()),
    );
    expect(transport.calls.length, 1);
    expect(source.calls, isEmpty);
  });

  test('cancellation skips discovery and unmapped hosts retain their origin', () async {
    final source = DiscoveryTestAdapter((_, _) async => jsonResponse(await discoveryJson()));
    final discovery = testDiscovery(source);
    addTearDown(discovery.close);
    final token = CancelToken();
    final transport = DiscoveryTestAdapter((request, _) async {
      token.cancel('test');
      throw DioException.requestCancelled(requestOptions: request, reason: 'test');
    });
    final dio = Dio()..httpClientAdapter = DiscoveryAdapter(transport, discovery);
    await expectLater(
      dio.get<Object?>('https://$apiHost/test', cancelToken: token),
      throwsA(isA<DioException>()),
    );
    expect(source.calls, isEmpty);
    // Non-JSON, so it counts as blocking and does reach the refresh path: the
    // point here is that an unmapped host is still never rewritten.
    final unrelated = DiscoveryTestAdapter(
      (_, _) async => htmlResponse('<html>gateway</html>', 503),
    );
    dio.httpClientAdapter = DiscoveryAdapter(unrelated, discovery);
    await expectLater(dio.get<Object?>('https://other.example/test'), throwsA(isA<DioException>()));
    expect(source.calls.length, 1);
    expect(unrelated.calls.map((request) => request.uri.host), ['other.example']);
  });

  test('a JSON 403 is the backend answering, not a censor', () async {
    final source = DiscoveryTestAdapter((_, _) async => jsonResponse(await discoveryJson()));
    final discovery = testDiscovery(source);
    addTearDown(discovery.close);
    final transport = DiscoveryTestAdapter((_, _) async => jsonResponse('{"error":"denied"}', 403));
    final dio = Dio()..httpClientAdapter = DiscoveryAdapter(transport, discovery);

    final response = await dio.get<Object?>(
      'https://$apiHost/api/v1/test',
      options: Options(validateStatus: (_) => true),
    );

    expect(response.statusCode, 403);
    expect(transport.calls.length, 1);
    // An authorization failure must not put the domain in cooldown.
    expect(discovery.degraded, isFalse);
  });

  test('an HTML 403 is a block page and fails over', () async {
    final source = DiscoveryTestAdapter((_, _) async => jsonResponse(await discoveryJson()));
    final discovery = testDiscovery(source);
    addTearDown(discovery.close);
    final transport = DiscoveryTestAdapter(
      (request, _) async => request.uri.host == apiHost
          ? htmlResponse('<html>blocked by your provider</html>')
          : jsonResponse('{"ok":true}'),
    );
    final dio = Dio()..httpClientAdapter = DiscoveryAdapter(transport, discovery);

    expect((await dio.get<Object?>('https://$apiHost/api/v1/test')).statusCode, 200);

    expect(transport.calls.length, 2);
    expect(discovery.degraded, isTrue);
  });

  test('a receive timeout fails over without calling the domain blocked', () async {
    final source = DiscoveryTestAdapter((_, _) async => jsonResponse(await discoveryJson()));
    final discovery = testDiscovery(source);
    addTearDown(discovery.close);
    final transport = DiscoveryTestAdapter((request, _) async {
      if (request.uri.host == apiHost) {
        throw DioException.receiveTimeout(
          timeout: const Duration(seconds: 1),
          requestOptions: request,
        );
      }
      return jsonResponse('{"ok":true}');
    });
    final dio = Dio()..httpClientAdapter = DiscoveryAdapter(transport, discovery);

    expect((await dio.get<Object?>('https://$apiHost/api/v1/test')).statusCode, 200);

    // Still worth trying elsewhere, but a slow connection is not a block: it
    // must not cost every later link tap a probe.
    expect(transport.calls.length, 2);
    expect(discovery.degraded, isFalse);
  });

  test('the kill switch stops the adapter failing over or fetching config', () async {
    final source = DiscoveryTestAdapter((_, _) async => jsonResponse(await discoveryJson()));
    final discovery = testDiscovery(source, tuning: () => const DiscoveryTuning(enabled: false));
    addTearDown(discovery.close);
    final transport = DiscoveryTestAdapter(
      (request, _) async => request.uri.host == apiHost
          ? htmlResponse('<html>blocked</html>')
          : jsonResponse('{"ok":true}'),
    );
    final dio = Dio()..httpClientAdapter = DiscoveryAdapter(transport, discovery);

    final response = await dio.get<Object?>(
      'https://$apiHost/api/v1/test',
      options: Options(validateStatus: (_) => true),
    );

    expect(response.statusCode, 403);
    expect(transport.calls.map((it) => it.uri.host), [apiHost]);
    expect(source.calls, isEmpty);
  });

  test('exhausting every domain is reported, a non-replayable request is not', () async {
    final events = <AnalyticsEvent>[];
    final source = DiscoveryTestAdapter((_, _) async => jsonResponse(await discoveryJson()));
    final discovery = testDiscovery(source, report: (event, _) => events.add(event));
    addTearDown(discovery.close);
    final transport = DiscoveryTestAdapter(
      (request, _) async => htmlResponse('<html>blocked</html>'),
    );
    final dio = Dio()..httpClientAdapter = DiscoveryAdapter(transport, discovery);

    await dio.get<Object?>(
      'https://$apiHost/api/v1/test',
      options: Options(validateStatus: (_) => true),
    );

    expect(events, contains(AnalyticsEvent.domainFailoverExhausted));
    expect(events.where((it) => it == AnalyticsEvent.domainFailoverExhausted).length, 1);

    events.clear();
    // Retries are off, so the request stops after one domain: candidates were
    // never exhausted and reporting it that way would be a lie.
    await dio.post<Object?>(
      'https://$apiHost/api/v1/test',
      data: {'a': 1},
      options: Options(validateStatus: (_) => true)..disableRetry = true,
    );

    expect(events, isNot(contains(AnalyticsEvent.domainFailoverExhausted)));
  });

  test('a TLS handshake failure is a block and fails over a POST', () async {
    final source = DiscoveryTestAdapter((_, _) async => jsonResponse(await discoveryJson()));
    final discovery = testDiscovery(source);
    addTearDown(discovery.close);
    final transport = DiscoveryTestAdapter((request, _) async {
      if (request.uri.host == apiHost) {
        throw const HandshakeException('CERTIFICATE_VERIFY_FAILED');
      }
      return jsonResponse('{"ok":true}');
    });
    final dio = Dio()..httpClientAdapter = DiscoveryAdapter(transport, discovery);

    final response = await dio.post<Object?>('https://$apiHost/api/v1/login', data: {'a': 1});

    expect(response.statusCode, 200);
    expect(transport.calls.map((it) => it.uri.host), [apiHost, alternativeApiHost]);
    expect(discovery.degraded, isTrue);
  });

  test('an HTML 5xx fails over without calling the domain blocked', () async {
    final source = DiscoveryTestAdapter((_, _) async => jsonResponse(await discoveryJson()));
    final discovery = testDiscovery(source);
    addTearDown(discovery.close);
    final transport = DiscoveryTestAdapter(
      (request, _) async => request.uri.host == apiHost
          ? htmlResponse('<html>bad gateway</html>', 502)
          : jsonResponse('{"ok":true}'),
    );
    final dio = Dio()..httpClientAdapter = DiscoveryAdapter(transport, discovery);

    expect((await dio.get<Object?>('https://$apiHost/api/v1/test')).statusCode, 200);

    expect(transport.calls.length, 2);
    expect(discovery.degraded, isFalse);
  });

  test('when every domain fails the error still describes the original request', () async {
    final source = DiscoveryTestAdapter((_, _) async => jsonResponse(await discoveryJson()));
    final discovery = testDiscovery(source);
    addTearDown(discovery.close);
    final transport = DiscoveryTestAdapter(
      (request, _) async =>
          throw DioException.connectionError(requestOptions: request, reason: 'refused'),
    );
    final dio = Dio(BaseOptions(baseUrl: 'https://$apiHost/api/v1'))
      ..httpClientAdapter = DiscoveryAdapter(transport, discovery);

    final error = await dio
        .get<Object?>('/test', queryParameters: {'access_token': 'secret'})
        .then<DioException?>((_) => null, onError: (Object e) => e as DioException);

    expect(transport.calls.length, 2);
    expect(error!.requestOptions.path, '/test');
    expect(error.requestOptions.uri.host, apiHost);
  });

  test('an offline failure is not evidence of blocking', () async {
    final events = <AnalyticsEvent>[];
    final source = DiscoveryTestAdapter((_, _) async => jsonResponse(await discoveryJson()));
    final discovery = testDiscovery(
      source,
      online: () async => false,
      report: (event, _) => events.add(event),
    );
    addTearDown(discovery.close);
    final transport = DiscoveryTestAdapter(
      (request, _) async =>
          throw DioException.connectionError(requestOptions: request, reason: 'Failed host lookup'),
    );
    final dio = Dio()..httpClientAdapter = DiscoveryAdapter(transport, discovery);

    await expectLater(dio.get<Object?>('https://$apiHost/test'), throwsA(isA<DioException>()));

    expect(discovery.degraded, isFalse);
    expect(events, isEmpty);
    expect(source.calls, isEmpty);
  });

  test('exhaustion is reported once per episode and never for a host without fallbacks', () async {
    final events = <AnalyticsEvent>[];
    final source = DiscoveryTestAdapter((_, _) async => jsonResponse(await discoveryJson()));
    final discovery = testDiscovery(source, report: (event, _) => events.add(event));
    addTearDown(discovery.close);
    final transport = DiscoveryTestAdapter(
      (request, _) async =>
          throw DioException.connectionError(requestOptions: request, reason: 'refused'),
    );
    final dio = Dio()..httpClientAdapter = DiscoveryAdapter(transport, discovery);

    await expectLater(dio.get<Object?>('https://other.example/test'), throwsA(anything));
    expect(events, isNot(contains(AnalyticsEvent.domainFailoverExhausted)));

    await expectLater(dio.get<Object?>('https://$apiHost/test'), throwsA(anything));
    await expectLater(dio.get<Object?>('https://$apiHost/test'), throwsA(anything));

    expect(events.where((it) => it == AnalyticsEvent.domainFailoverExhausted).length, 1);
  });
}
