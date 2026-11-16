import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
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

  test('browser probes and fallback logs exclude URL credentials, path and query', () async {
    final logger = Talker(settings: TalkerSettings(useConsoleLogs: false));
    final adapter = DiscoveryTestAdapter((options, _) async {
      expect(options.headers['Authorization'], isNull);
      if (options.uri.path.endsWith('config.json')) {
        return jsonResponse(await discoveryJson());
      }
      expect(options.uri.path, '/api/v1/healthcheck');
      expect(options.uri.query, isEmpty);
      expect(options.uri.userInfo, isEmpty);
      return options.uri.host == appHost
          ? jsonResponse('{}', 403)
          : jsonResponse('{"status":"OK"}');
    });
    final service = testDiscovery(adapter, logger: logger);
    addTearDown(service.close);
    final original = Uri.parse('https://$appHost/oauth/authorize?code_challenge=secret#fragment');
    final resolved = await service.resolveBrowserUrl(original);
    expect(resolved, original.replace(host: alternativeAppHost));
    final logs = logger.history.map((it) => it.message).join('\n');
    expect(logs, contains('Browser endpoint failed health check: https://$appHost'));
    expect(
      logs,
      contains('Browser fallback selected: https://$appHost -> https://$alternativeAppHost'),
    );
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
}
