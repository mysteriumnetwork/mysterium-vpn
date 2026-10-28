import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/services/network_health/tunnel_health_probe.dart';
import 'package:talker/talker.dart';

class _StubAdapter implements HttpClientAdapter {
  _StubAdapter(this.handler);

  final Future<ResponseBody> Function(RequestOptions options) handler;
  final List<String> started = [];
  final List<String> finished = [];

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) async {
    started.add(options.uri.host);
    final body = await handler(options);
    finished.add(options.uri.host);
    return body;
  }

  @override
  void close({bool force = false}) {}
}

ResponseBody _ok(String body) => ResponseBody.fromString(
  body,
  200,
  headers: {
    Headers.contentTypeHeader: [Headers.jsonContentType],
  },
);

void main() {
  late Talker logger;

  setUp(() => logger = Talker());

  HttpTunnelHealthProbe build(
    _StubAdapter adapter, {
    void Function(List<String>)? onStale,
    List<String> dns = const ['198.51.100.7'],
  }) {
    final dio = Dio()..httpClientAdapter = adapter;
    return HttpTunnelHealthProbe(
      dio,
      logger,
      timeout: const Duration(seconds: 5),
      onControlAddressesStale: onStale,
      resolve: (_) async => dns.map(InternetAddress.new).toList(),
    );
  }

  test('times both legs and verifies the bypass', () async {
    final adapter = _StubAdapter((options) async {
      if (options.uri.host == 'ip.mysterium.network') {
        return _ok('10.0.0.1');
      }
      return _ok(jsonEncode({'ip': '203.0.113.9'}));
    });

    final sample = await build(adapter).probe(exitIp: '10.0.0.1', controlIps: const ['127.0.0.1']);

    expect(sample.tunnelled.ip, '10.0.0.1');
    expect(sample.direct.ip, '203.0.113.9');
    expect(sample.tunnelled.elapsed, isNotNull);
    expect(sample.direct.elapsed, isNotNull);
    expect(sample.bypassVerified, isTrue);
  });

  test('a direct leg returning the exit IP means the bypass is not in effect', () async {
    final adapter = _StubAdapter((options) async {
      if (options.uri.host == 'ip.mysterium.network') {
        return _ok('10.0.0.1');
      }
      return _ok(jsonEncode({'ip': '10.0.0.1'}));
    });

    final sample = await build(adapter).probe(exitIp: '10.0.0.1', controlIps: const ['127.0.0.1']);

    expect(sample.bypassVerified, isFalse);
  });

  test('a null exit IP leaves the bypass unverified but still times both legs', () async {
    final adapter = _StubAdapter((options) async {
      if (options.uri.host == 'ip.mysterium.network') {
        return _ok('10.0.0.1');
      }
      return _ok(jsonEncode({'ip': '203.0.113.9'}));
    });

    final sample = await build(adapter).probe(exitIp: null, controlIps: const ['127.0.0.1']);

    expect(sample.bypassVerified, isFalse);
    expect(sample.tunnelled.elapsed, isNotNull);
    expect(sample.direct.elapsed, isNotNull);
  });

  test('an empty exit IP is treated the same as null', () async {
    final adapter = _StubAdapter((options) async => _ok('10.0.0.1'));

    final sample = await build(adapter).probe(exitIp: '', controlIps: const ['127.0.0.1']);

    expect(sample.bypassVerified, isFalse);
  });

  test('a failing leg yields an error record, not a thrown future', () async {
    final adapter = _StubAdapter((options) async {
      if (options.uri.host == 'ip.mysterium.network') {
        throw DioException.connectionError(requestOptions: options, reason: 'down');
      }
      return _ok(jsonEncode({'ip': '203.0.113.9'}));
    });

    final sample = await build(adapter).probe(exitIp: '10.0.0.1', controlIps: const ['127.0.0.1']);

    expect(sample.tunnelled.elapsed, isNull);
    expect(sample.tunnelled.error, isNotNull);
    expect(sample.direct.elapsed, isNotNull);
  });

  test('an unparseable control IP is reported unreachable, not thrown', () async {
    final adapter = _StubAdapter((options) async => _ok('10.0.0.1'));

    final sample = await build(adapter).probe(exitIp: '10.0.0.1', controlIps: const ['nonsense']);

    expect(sample.controlReachable, isFalse);
  });

  test('reports a stale control IP while DNS still works', () async {
    // Silent otherwise: the dial just fails, every degraded tunnel reports as
    // no network, and nothing says the configured address has moved.
    final adapter = _StubAdapter((options) async => _ok(jsonEncode({'ip': '203.0.113.9'})));
    List<String>? reported;

    await build(
      adapter,
      onStale: (resolved) => reported = resolved,
    ).probe(exitIp: '10.0.0.1', controlIps: const ['192.0.2.1']);
    await pumpEventQueue();

    expect(reported, ['198.51.100.7']);
  });

  test('stays quiet when a configured control IP is still in DNS', () async {
    final adapter = _StubAdapter((options) async => _ok(jsonEncode({'ip': '203.0.113.9'})));
    var reported = false;

    await build(
      adapter,
      onStale: (_) => reported = true,
      // The host is load-balanced, so one overlapping answer is enough.
      dns: const ['198.51.100.7', '192.0.2.1'],
    ).probe(exitIp: '10.0.0.1', controlIps: const ['192.0.2.1']);
    await pumpEventQueue();

    expect(reported, isFalse);
  });

  test('reports a stale control IP once, not on every probe', () async {
    final adapter = _StubAdapter((options) async => _ok(jsonEncode({'ip': '203.0.113.9'})));
    var reports = 0;
    final probe = build(adapter, onStale: (_) => reports++);

    await probe.probe(exitIp: '10.0.0.1', controlIps: const ['192.0.2.1']);
    await pumpEventQueue();
    await probe.probe(exitIp: '10.0.0.1', controlIps: const ['192.0.2.1']);
    await pumpEventQueue();

    expect(reports, 1, reason: 'every resume would otherwise re-report the same answer');
  });

  test('a changed control IP config is checked again', () async {
    final adapter = _StubAdapter((options) async => _ok(jsonEncode({'ip': '203.0.113.9'})));
    var reports = 0;
    final probe = build(adapter, onStale: (_) => reports++);

    await probe.probe(exitIp: '10.0.0.1', controlIps: const ['192.0.2.1']);
    await pumpEventQueue();
    await probe.probe(exitIp: '10.0.0.1', controlIps: const ['192.0.2.2']);
    await pumpEventQueue();

    expect(reports, 2);
  });

  test('a failed lookup leaves the check armed for the next resume', () async {
    final adapter = _StubAdapter((options) async => _ok(jsonEncode({'ip': '203.0.113.9'})));
    var reports = 0;
    var failNext = true;
    final dio = Dio()..httpClientAdapter = adapter;
    final probe = HttpTunnelHealthProbe(
      dio,
      logger,
      timeout: const Duration(seconds: 5),
      onControlAddressesStale: (_) => reports++,
      resolve: (_) async {
        if (failNext) {
          failNext = false;
          throw const SocketException('no dns');
        }
        return [InternetAddress('198.51.100.7')];
      },
    );

    await probe.probe(exitIp: '10.0.0.1', controlIps: const ['192.0.2.1']);
    await pumpEventQueue();
    await probe.probe(exitIp: '10.0.0.1', controlIps: const ['192.0.2.1']);
    await pumpEventQueue();

    expect(reports, 1, reason: 'the inconclusive first attempt must not latch');
  });

  test('a failed lookup is inconclusive, never reported as stale', () async {
    final adapter = _StubAdapter((options) async => _ok(jsonEncode({'ip': '203.0.113.9'})));
    var reported = false;
    final dio = Dio()..httpClientAdapter = adapter;
    final probe = HttpTunnelHealthProbe(
      dio,
      logger,
      timeout: const Duration(seconds: 5),
      onControlAddressesStale: (_) => reported = true,
      resolve: (_) async => throw const SocketException('no dns'),
    );

    await probe.probe(exitIp: '10.0.0.1', controlIps: const ['192.0.2.1']);
    await pumpEventQueue();

    expect(reported, isFalse);
  });

  test('both legs are dispatched before either completes', () async {
    final gate = Completer<void>();
    final adapter = _StubAdapter((options) async {
      await gate.future;
      return _ok(jsonEncode({'ip': '203.0.113.9'}));
    });

    final future = build(adapter).probe(exitIp: '10.0.0.1', controlIps: const ['127.0.0.1']);
    await Future<void>.delayed(const Duration(milliseconds: 50));

    expect(adapter.started.length, 2, reason: 'legs must run in parallel');
    expect(adapter.finished, isEmpty);

    gate.complete();
    await future;
  });
}
