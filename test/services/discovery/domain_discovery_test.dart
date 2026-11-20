import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/services/discovery/domain_discovery.dart';
import 'package:talker/talker.dart';

import 'discovery_fakes.dart';

void main() {
  test('validates schema only after authenticating the payload', () async {
    final valid = await discoveryJson();
    for (final source in ['{}', 'null', '$valid{}']) {
      await expectLater(parseTestConfig(source), throwsFormatException);
    }
    for (final change in <void Function(Map<String, dynamic>)>[
      (signed) {
        signed['schema_version'] = 2;
      },
      (signed) {
        signed['version'] = null;
      },
      (signed) {
        signed['expires_at'] = '2020-01-01T00:00:00Z';
      },
      (signed) {
        signed['mappings'] = {
          apiHost: ['https://$alternativeApiHost'],
        };
      },
      (signed) {
        signed['mappings'] = {
          apiHost: ['127.0.0.1'],
        };
      },
      (signed) {
        signed['mappings'] = {apiHost: <String>[]};
      },
    ]) {
      final envelope = jsonDecode(valid) as Map<String, dynamic>;
      change(envelope['signed'] as Map<String, dynamic>);
      await expectLater(parseTestConfig(await signTestEnvelope(envelope)), throwsFormatException);
    }
    expect((await parseTestConfig(valid)).mappings[apiHost], [alternativeApiHost]);
  });

  test('authenticated discovery can introduce new domain replacements', () async {
    final config = await parseTestConfig(
      await discoveryJson(
        mappings: {
          apiHost: ['new-mirror.example'],
          'new-api.example': ['new-alternative.example'],
        },
      ),
    );
    expect(config.mappings[apiHost], ['new-mirror.example']);
    expect(config.mappings['new-api.example'], ['new-alternative.example']);
  });

  test('uses Raw on invalid Pages config, coalesces refresh and persists state', () async {
    final adapter = DiscoveryTestAdapter(
      (options, _) async => jsonResponse(
        options.uri.host == 'static-resources-hub.github.io' ? '{}' : await discoveryJson(),
      ),
    );
    final storage = <String, String>{};
    var now = DateTime.utc(2026, 11, 16);
    final service = testDiscovery(adapter, storage: storage, now: () => now);
    addTearDown(service.close);
    final original = Uri.https(apiHost, '/api/v1/test', {'secret': 'never-cache'});
    expect(await service.cachedCandidates(original), [original]);
    expect(adapter.calls, isEmpty);
    await Future.wait(List.generate(10, (_) => service.candidatesAfterFailure(original)));
    expect(adapter.calls.length, 2);
    expect(adapter.calls.every((it) => it.headers['Authorization'] == null), isTrue);
    await service.record(original, original, success: false);
    final alternative = original.replace(host: alternativeApiHost);
    await service.record(original, alternative, success: true);
    expect(storage.values.single, isNot(contains('never-cache')));
    final restarted = testDiscovery(adapter, storage: storage, now: () => now);
    expect((await restarted.cachedCandidates(original)).first, alternative);
    await restarted.candidatesAfterFailure(original);
    expect(adapter.calls.length, 2);
    now = now.add(const Duration(minutes: 31));
    expect((await restarted.cachedCandidates(original)).first, original);
  });

  test('failed refresh retains expired cache and retries on demand each hour', () async {
    final storage = <String, String>{};
    var now = DateTime.utc(2026, 11, 16);
    var offline = false;
    final adapter = DiscoveryTestAdapter(
      (_, _) async => offline ? jsonResponse('{}', 503) : jsonResponse(await discoveryJson()),
    );
    final service = testDiscovery(adapter, storage: storage, now: () => now);
    addTearDown(service.close);
    final original = Uri.https(apiHost);
    await service.candidatesAfterFailure(original);
    offline = true;
    now = now.add(const Duration(hours: 2));
    expect((await service.candidatesAfterFailure(original)).length, 2);
    expect(adapter.calls.length, 3);
    await service.candidatesAfterFailure(original);
    expect(adapter.calls.length, 3);
    final state = jsonDecode(storage.values.single) as Map<String, dynamic>;
    final config = state['config'] as Map<String, dynamic>;
    final signed = config['signed'] as Map<String, dynamic>;
    signed['expires_at'] = '2026-02-01T00:00:00Z';
    state['config'] = jsonDecode(await signTestEnvelope(config));
    storage[DomainDiscovery.cacheKey] = jsonEncode(state);
    final restarted = testDiscovery(adapter, storage: storage, now: () => now);
    expect((await restarted.cachedCandidates(original)).length, 2);
    await restarted.candidatesAfterFailure(original);
    expect(adapter.calls.length, 5);
  });

  test('corrupt cache and failed persistence do not break requests', () async {
    final adapter = DiscoveryTestAdapter((_, _) async => jsonResponse(await discoveryJson()));
    final service = DomainDiscovery(
      read: (_) => 'broken',
      write: (_, _) async => throw Exception('read only'),
      client: adapterClient(adapter),
      verifier: testVerifier,
    );
    addTearDown(service.close);
    expect((await service.candidatesAfterFailure(Uri.https(apiHost))).length, 2);
  });

  test('browser probes exclude URL credentials, path and query', () async {
    final logger = Talker(settings: TalkerSettings(useConsoleLogs: false));
    final adapter = DiscoveryTestAdapter((options, _) async {
      expect(options.headers['Authorization'], isNull);
      if (options.uri.path.endsWith('config.json')) {
        return jsonResponse(await discoveryJson());
      }
      expect(options.uri.path, '/api/v1/healthcheck');
      expect(options.uri.query, isEmpty);
      expect(options.uri.userInfo, isEmpty);
      return options.uri.host == alternativeAppHost
          ? jsonResponse('{}', 403)
          : jsonResponse('{"status":"OK"}');
    });
    final service = testDiscovery(adapter, logger: logger);
    addTearDown(service.close);
    // Only a degraded service probes at all, so give it something to go on.
    final apiOrigin = Uri.https(apiHost);
    await service.candidatesAfterFailure(apiOrigin);
    await service.record(apiOrigin, apiOrigin.replace(host: alternativeApiHost), success: true);

    final original = Uri.parse('https://$appHost/oauth/authorize?code_challenge=secret#fragment');
    final resolved = await service.resolveBrowserUrl(original);

    // The fallback is tried first and fails, so the primary wins it back.
    expect(resolved, original);
    final logs = logger.history.map((it) => it.message).join('\n');
    expect(logs, contains('Browser endpoint failed health check: https://$alternativeAppHost'));
    expect(logs, contains('Verified configuration from https://static-resources-hub.github.io'));
    expect(logs, isNot(contains('code_challenge')));
    expect(logs, isNot(contains('secret')));
    expect(logs, isNot(contains('fragment')));
    final calls = adapter.calls.length;
    expect(
      await service.resolveBrowserUrl(Uri.https('accounts.google.com')),
      Uri.https('accounts.google.com'),
    );
    expect(adapter.calls.length, calls);
  });

  test('a healthy origin is never written to storage', () async {
    final storage = <String, String>{};
    final adapter = DiscoveryTestAdapter((_, _) async => jsonResponse(await discoveryJson()));
    final service = testDiscovery(adapter, storage: storage);
    addTearDown(service.close);
    final original = Uri.https(apiHost);
    // Load a verified config so the "no alternatives" short-circuit cannot be
    // what keeps storage empty.
    await service.candidatesAfterFailure(original);
    storage.clear();

    await service.record(original, original, success: true);
    await service.record(original, original, success: true);

    expect(storage, isEmpty);
    expect(service.degraded, isFalse);
  });

  test('a browser URL is handed back untouched while nothing is known to fail', () async {
    final adapter = DiscoveryTestAdapter((_, _) async => jsonResponse(await discoveryJson()));
    final service = testDiscovery(adapter);
    addTearDown(service.close);
    final original = Uri.https(appHost, '/login');

    expect(await service.resolveBrowserUrl(original), original);

    // No health check, no config fetch: a user who is not blocked pays nothing.
    expect(adapter.calls, isEmpty);
  });

  test('once degraded, a browser URL resolves through a probed fallback', () async {
    final adapter = DiscoveryTestAdapter((options, _) async {
      if (options.uri.path.endsWith('config.json')) {
        return jsonResponse(await discoveryJson());
      }
      return options.uri.host == appHost
          ? htmlResponse('<html>blocked</html>')
          : jsonResponse('{"status":"OK"}');
    });
    final logger = Talker(settings: TalkerSettings(useConsoleLogs: false));
    final service = testDiscovery(adapter, logger: logger);
    addTearDown(service.close);
    final apiOrigin = Uri.https(apiHost);
    // The API failing over is the evidence that makes the browser path engage.
    await service.candidatesAfterFailure(apiOrigin);
    await service.record(apiOrigin, apiOrigin.replace(host: alternativeApiHost), success: true);
    expect(service.degraded, isTrue);

    final resolved = await service.resolveBrowserUrl(Uri.https(appHost, '/login'));

    expect(resolved.host, alternativeAppHost);
    // The fallback is probed before the user is sent to it, and the blocked
    // primary is never tried.
    expect(adapter.calls.map((it) => it.uri.host), isNot(contains(appHost)));
    expect(
      logger.history.map((it) => it.message).join('\n'),
      contains('Browser fallback selected: https://$appHost -> https://$alternativeAppHost'),
    );
  });

  test('the warm-up detects a blocked web host while the API is healthy', () async {
    final adapter = DiscoveryTestAdapter((options, _) async {
      if (options.uri.path.endsWith('config.json')) {
        return jsonResponse(await discoveryJson());
      }
      // An HTML block page: a JSON 403 would be the backend talking.
      return options.uri.host == appHost
          ? htmlResponse('<html>blocked</html>')
          : jsonResponse('{"status":"OK"}');
    });
    final service = testDiscovery(adapter);
    addTearDown(service.close);

    await service.warmBrowserHosts();

    // Nothing else would ever fetch a config on a device with a healthy API.
    expect(adapter.calls.map((it) => it.uri.path), contains('/config.json'));
    expect(service.degraded, isTrue);
    expect((await service.resolveBrowserUrl(Uri.https(appHost))).host, alternativeAppHost);
  });

  test('a warm-up success clears a stale fallback preference', () async {
    final adapter = DiscoveryTestAdapter(
      (options, _) async => options.uri.path.endsWith('config.json')
          ? jsonResponse(await discoveryJson())
          : jsonResponse('{"status":"OK"}'),
    );
    final service = testDiscovery(adapter);
    addTearDown(service.close);
    final original = Uri.https(appHost);
    await service.candidatesAfterFailure(original);
    await service.record(original, original.replace(host: alternativeAppHost), success: true);
    expect(service.degraded, isTrue);

    await service.warmBrowserHosts();

    // Without this the browser path stays on fallback domains for good.
    expect(service.degraded, isFalse);
  });

  test('an offline warm-up records nothing and does not probe', () async {
    final adapter = DiscoveryTestAdapter((_, _) async => jsonResponse(await discoveryJson()));
    final service = testDiscovery(adapter, online: () async => false);
    addTearDown(service.close);

    await service.warmBrowserHosts();

    expect(adapter.calls, isEmpty);
    expect(service.degraded, isFalse);
  });

  test('a failed refresh backs off in seconds, not for the full hour', () async {
    var now = DateTime.utc(2026, 11, 16);
    final adapter = DiscoveryTestAdapter((_, _) async => jsonResponse('{}', 503));
    final service = testDiscovery(adapter, now: () => now);
    addTearDown(service.close);
    final original = Uri.https(apiHost);

    await service.candidatesAfterFailure(original);
    expect(adapter.calls.length, 2);

    now = now.add(const Duration(seconds: 31));
    await service.candidatesAfterFailure(original);

    // A blocked network is also where GitHub is likely blocked, so waiting an
    // hour to try again strands exactly the users this exists for.
    expect(adapter.calls.length, 4);
  });

  test('the kill switch stops every entry point, not just requests', () async {
    final adapter = DiscoveryTestAdapter((_, _) async => jsonResponse(await discoveryJson()));
    final service = testDiscovery(adapter, tuning: () => const DiscoveryTuning(enabled: false));
    addTearDown(service.close);
    final original = Uri.https(appHost, '/login');

    expect(await service.cachedCandidates(original), [original]);
    expect(await service.candidatesAfterFailure(original), [original]);
    await service.record(original, original.replace(host: alternativeAppHost), success: true);
    await service.warmBrowserHosts();
    await service.recordBrowserFailure(original, original);

    expect(service.degraded, isFalse);
    expect(await service.resolveBrowserUrl(original), original);
    expect(adapter.calls, isEmpty);
  });

  test('tuning drives the cooldown that ranks a failed host last', () async {
    var now = DateTime.utc(2026, 11, 16);
    final adapter = DiscoveryTestAdapter((_, _) async => jsonResponse(await discoveryJson()));
    final service = testDiscovery(
      adapter,
      now: () => now,
      tuning: () => const DiscoveryTuning(cooldown: Duration(minutes: 5)),
    );
    addTearDown(service.close);
    final original = Uri.https(apiHost);
    await service.candidatesAfterFailure(original);
    await service.record(original, original, success: false);

    expect((await service.cachedCandidates(original)).first.host, alternativeApiHost);

    now = now.add(const Duration(minutes: 6));

    expect((await service.cachedCandidates(original)).first.host, apiHost);
  });

  test('a blocked origin is reported once, not once per request', () async {
    final events = <(AnalyticsEvent, Map<String, dynamic>)>[];
    final adapter = DiscoveryTestAdapter((_, _) async => jsonResponse(await discoveryJson()));
    final service = testDiscovery(
      adapter,
      report: (event, parameters) {
        events.add((event, parameters));
      },
    );
    addTearDown(service.close);
    final original = Uri.https(apiHost);
    await service.candidatesAfterFailure(original);

    await service.record(original, original, success: false, reason: 'http_403');
    await service.record(original, original, success: false, reason: 'http_403');

    expect(events.map((it) => it.$1), [AnalyticsEvent.domainBlockDetected]);
    expect(events.single.$2, {'kind': 'api', 'host': apiHost, 'reason': 'http_403'});
  });

  test('failing over and recovering bracket an episode', () async {
    var now = DateTime.utc(2026, 11, 16);
    final events = <AnalyticsEvent>[];
    final adapter = DiscoveryTestAdapter((_, _) async => jsonResponse(await discoveryJson()));
    final service = testDiscovery(adapter, now: () => now, report: (event, _) => events.add(event));
    addTearDown(service.close);
    final original = Uri.https(apiHost);
    final fallback = original.replace(host: alternativeApiHost);
    await service.candidatesAfterFailure(original);

    await service.record(original, original, success: false, reason: 'connection_error');
    await service.record(original, fallback, success: true);
    now = now.add(const Duration(minutes: 31));
    await service.record(original, original, success: true);

    expect(events, [
      AnalyticsEvent.domainBlockDetected,
      AnalyticsEvent.domainFailoverSucceeded,
      AnalyticsEvent.domainDiscoveryRecovered,
    ]);
  });

  test('a sweep that re-blocks in the same call reports neither', () async {
    var now = DateTime.utc(2026, 11, 16);
    final events = <AnalyticsEvent>[];
    final adapter = DiscoveryTestAdapter((_, _) async => jsonResponse(await discoveryJson()));
    final service = testDiscovery(adapter, now: () => now, report: (event, _) => events.add(event));
    addTearDown(service.close);
    final original = Uri.https(appHost);
    await service.candidatesAfterFailure(original);
    await service.record(original, original, success: false, reason: 'http_403');
    events.clear();

    // The cooldown lapses and the host fails again in the same call, which is
    // one continuous block — not an episode ending and another beginning.
    now = now.add(const Duration(minutes: 31));
    await service.record(original, original, success: false, reason: 'http_403');

    expect(events, isEmpty);
  });

  test('a bootstrap failure is reported when no config can be had', () async {
    final events = <AnalyticsEvent>[];
    final adapter = DiscoveryTestAdapter((_, _) async => jsonResponse('{}', 503));
    final service = testDiscovery(adapter, report: (event, _) => events.add(event));
    addTearDown(service.close);

    await service.candidatesAfterFailure(Uri.https(apiHost));

    expect(events, contains(AnalyticsEvent.domainDiscoveryUnavailable));
  });

  test('a browser probe timeout is a weak link, not a block', () async {
    final adapter = DiscoveryTestAdapter((options, _) async {
      if (options.uri.path.endsWith('config.json')) {
        return jsonResponse(await discoveryJson());
      }
      throw DioException.receiveTimeout(
        timeout: const Duration(seconds: 1),
        requestOptions: options,
      );
    });
    final service = testDiscovery(adapter);
    addTearDown(service.close);

    await service.warmBrowserHosts();

    // Latching here would put every later link tap on the probe path for the
    // whole cooldown, on nothing more than one slow request.
    expect(service.degraded, isFalse);
    expect(await service.resolveBrowserUrl(Uri.https(appHost)), Uri.https(appHost));
  });

  test('the check interval survives a restart, so relaunching does not re-probe', () async {
    var now = DateTime.utc(2026, 11, 16);
    final storage = <String, String>{};
    final adapter = DiscoveryTestAdapter(
      (options, _) async => options.uri.path.endsWith('config.json')
          ? jsonResponse(await discoveryJson())
          : jsonResponse('{"status":"OK"}'),
    );
    final first = testDiscovery(adapter, storage: storage, now: () => now);
    addTearDown(first.close);
    await first.warmBrowserHosts();
    final probes = adapter.calls.length;
    expect(probes, 1);

    now = now.add(const Duration(minutes: 5));
    final restarted = testDiscovery(adapter, storage: storage, now: () => now);
    addTearDown(restarted.close);
    await restarted.warmBrowserHosts();

    // Ten launches in half an hour must cost one check, not ten.
    expect(adapter.calls.length, probes);

    now = now.add(const Duration(minutes: 31));
    final later = testDiscovery(adapter, storage: storage, now: () => now);
    addTearDown(later.close);
    await later.warmBrowserHosts();

    expect(adapter.calls.length, probes + 1);
  });
}
