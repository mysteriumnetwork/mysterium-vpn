import 'dart:convert';
import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:json_canonicalizer/json_canonicalizer.dart';
import 'package:mysterium_vpn/services/discovery/discovery_config.dart';
import 'package:mysterium_vpn/services/discovery/domain_discovery.dart';

import 'discovery_fakes.dart';

void main() {
  test('verifies the published document with the bundled production key', () async {
    final source = File('test/services/discovery/fixtures/production.json').readAsStringSync();
    expect(
      (await DiscoveryConfig.parse(source, now: DateTime.utc(2026, 11, 16))).mappings[apiHost],
      contains(alternativeApiHost),
    );
    Object? reversed(Object? value) {
      if (value is Map<String, dynamic>) {
        return Map.fromEntries(
          value.entries.toList().reversed.map(
            (entry) => MapEntry(entry.key, reversed(entry.value)),
          ),
        );
      }
      return value is List<Object?> ? value.map(reversed).toList() : value;
    }

    final reordered = jsonEncode(reversed(jsonDecode(source)));
    expect(
      (await DiscoveryConfig.parse(reordered, now: DateTime.utc(2026, 11, 16))).mappings[appHost],
      contains(alternativeAppHost),
    );
  });

  test('the bundled production config is not about to expire', () async {
    final source = File('test/services/discovery/fixtures/production.json').readAsStringSync();
    final config = await DiscoveryConfig.parse(source, allowExpired: true);

    final left = config.expiresAt.difference(DateTime.now());

    expect(
      left,
      greaterThan(const Duration(days: 30)),
      reason:
          'the signed discovery config expires in ${left.inDays} days. Re-sign and republish it, '
          'then refresh test/services/discovery/fixtures/production.json — once it lapses, new '
          'installs get no failover at all.',
    );
  });

  test('matches Python jcs canonical bytes and signature across Unicode and numbers', () async {
    final fixture = jsonDecode(
      File('test/services/discovery/fixtures/python-jcs.json').readAsStringSync(),
    ) as Map<String, dynamic>;
    final envelope = fixture['envelope'] as Map<String, dynamic>;
    final decoded = jsonDecode(
      jsonEncode(envelope['signed']),
      reviver: (_, value) => value is num ? value.toDouble() : value,
    );
    expect(canonicalizeUtf8(decoded), base64.decode(fixture['canonical_base64'] as String));
    expect((await parseTestConfig(jsonEncode(envelope))).mappings[apiHost], [alternativeApiHost]);
  });

  test('rejects modified, unsigned, unknown-key and invalid signatures', () async {
    final valid = await discoveryJson();
    for (final change in <void Function(Map<String, dynamic>)>[
      (envelope) {
        envelope.remove('signatures');
      },
      (envelope) {
        envelope['signatures'] = <Object?>[];
      },
      (envelope) {
        (envelope['signed'] as Map<String, dynamic>)['version'] = 2;
      },
      (envelope) {
        ((envelope['signatures'] as List).first as Map<String, dynamic>)['key_id'] = 'unknown';
      },
      (envelope) {
        ((envelope['signatures'] as List).first as Map<String, dynamic>)['alg'] = 'ed25519';
      },
      (envelope) {
        ((envelope['signatures'] as List).first as Map<String, dynamic>)['sig'] = '!!!';
      },
      (envelope) {
        ((envelope['signatures'] as List).first as Map<String, dynamic>)['sig'] = base64.encode(
          List.filled(64, 0),
        );
      },
    ]) {
      final envelope = jsonDecode(valid) as Map<String, dynamic>;
      change(envelope);
      await expectLater(parseTestConfig(jsonEncode(envelope)), throwsFormatException);
    }
    // The production parser must never trust the test signing key.
    await expectLater(DiscoveryConfig.parse(valid), throwsFormatException);
  });

  test(
    'requires JCS signatures, rejects duplicate keys, and accepts one valid trusted signature',
    () async {
      final source = await discoveryJson();
      final envelope = jsonDecode(source) as Map<String, dynamic>;
      final nonCanonical = utf8.encode(
        const JsonEncoder.withIndent('  ').convert(envelope['signed']),
      );
      await expectLater(
        parseTestConfig(await signTestEnvelope(envelope, bytesOverride: nonCanonical)),
        throwsFormatException,
      );
      final duplicate = source.replaceFirst(
        '"schema_version":1',
        '"schema_version":1,"schema_version":1',
      );
      await expectLater(parseTestConfig(duplicate), throwsFormatException);
      (envelope['signatures'] as List<Object?>).insertAll(0, [
        {'key_id': 'future-key', 'alg': 'Ed25519', 'sig': 'bad'},
        {'key_id': 'test-discovery', 'alg': 'Ed25519', 'sig': 'bad'},
      ]);
      expect((await parseTestConfig(jsonEncode(envelope))).mappings[apiHost], [alternativeApiHost]);
    },
  );
  test('only verified documents enter or replace the persistent cache', () async {
    final storage = <String, String>{};
    final valid = await discoveryJson();
    var now = DateTime.utc(2026, 11, 16);
    var source = valid;
    final adapter = DiscoveryTestAdapter((_, _) async => jsonResponse(source));
    final service = testDiscovery(adapter, storage: storage, now: () => now);
    addTearDown(service.close);
    final original = Uri.https(apiHost);
    expect((await service.candidatesAfterFailure(original)).length, 2);
    final cached = storage[DomainDiscovery.cacheKey];
    now = now.add(const Duration(hours: 2));
    source = valid.replaceFirst(alternativeApiHost, 'attacker.example');
    expect((await service.candidatesAfterFailure(original)).last.host, alternativeApiHost);
    expect(storage[DomainDiscovery.cacheKey], cached);
    final state = jsonDecode(cached!) as Map<String, dynamic>;
    (state['config'] as Map<String, dynamic>).remove('signatures');
    storage[DomainDiscovery.cacheKey] = jsonEncode(state);
    final restarted = testDiscovery(adapter, storage: storage, now: () => now);
    expect(await restarted.cachedCandidates(original), [original]);
    expect(await restarted.candidatesAfterFailure(original), [original]);
  });

  test('checks expiration and schema only after the signature succeeds', () async {
    final envelope = jsonDecode(await discoveryJson()) as Map<String, dynamic>;
    final payload = envelope['signed'] as Map<String, dynamic>;
    payload['schema_version'] = 99;
    await expectLater(
      parseTestConfig(jsonEncode(envelope)),
      throwsA(
        isA<FormatException>().having((error) => error.message, 'message', contains('signature')),
      ),
    );
    payload['schema_version'] = 1;
    payload['issued_at'] = '2000-01-01T00:00:00Z';
    payload['expires_at'] = '2000-02-01T00:00:00Z';
    final expired = await signTestEnvelope(envelope);
    await expectLater(
      parseTestConfig(expired),
      throwsA(
        isA<FormatException>().having((error) => error.message, 'message', contains('expired')),
      ),
    );
    final cached = await DiscoveryConfig.parse(expired, verifier: testVerifier, allowExpired: true);
    expect(cached.mappings[apiHost], [alternativeApiHost]);
  });
}
