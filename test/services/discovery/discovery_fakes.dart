import 'dart:convert';
import 'dart:typed_data';

import 'package:cryptography/cryptography.dart';
import 'package:dio/dio.dart';
import 'package:json_canonicalizer/json_canonicalizer.dart';
import 'package:mysterium_vpn/services/discovery/discovery_config.dart';
import 'package:mysterium_vpn/services/discovery/discovery_verifier.dart';
import 'package:mysterium_vpn/services/discovery/domain_discovery.dart';
import 'package:talker/talker.dart';

const apiHost = 'api.mysteriumvpn.com';
const alternativeApiHost = 'unblocked-api.mysteriumvpn.com';
const appHost = 'app.mysteriumvpn.com';
const alternativeAppHost = 'unblocked-app.mysteriumvpn.com';

Future<String> discoveryJson({Map<String, List<String>>? mappings}) => signTestEnvelope({
  'signed': {
    'schema_version': 1,
    'version': 1,
    'issued_at': '2026-01-01T00:00:00Z',
    'expires_at': '2099-01-01T00:00:00Z',
    'mappings':
        mappings ??
        {
          apiHost: [alternativeApiHost],
          appHost: [alternativeAppHost],
        },
  },
  'signatures': [],
});

ResponseBody jsonResponse(String body, [int status = 200]) => ResponseBody.fromString(
  body,
  status,
  headers: {
    Headers.contentTypeHeader: ['application/json'],
  },
);

class DiscoveryTestAdapter implements HttpClientAdapter {
  DiscoveryTestAdapter(this.handler);
  final Future<ResponseBody> Function(RequestOptions, Stream<Uint8List>?) handler;
  final calls = <RequestOptions>[];
  bool closed = false;

  @override
  Future<ResponseBody> fetch(
    RequestOptions options,
    Stream<Uint8List>? requestStream,
    Future<void>? cancelFuture,
  ) {
    calls.add(options);
    return handler(options, requestStream);
  }

  @override
  void close({bool force = false}) {
    closed = true;
  }
}

DomainDiscovery testDiscovery(
  DiscoveryTestAdapter adapter, {
  Map<String, String>? storage,
  DateTime Function()? now,
  Talker? logger,
}) {
  final values = storage ?? <String, String>{};
  final dio = Dio()..httpClientAdapter = adapter;
  return DomainDiscovery(
    read: (key) => values[key],
    write: (key, value) async {
      values[key] = value;
      return true;
    },
    client: dio,
    logger: logger,
    verifier: testVerifier,
    now: now,
    browserHosts: {appHost},
  );
}

Dio adapterClient(DiscoveryTestAdapter adapter) => Dio()..httpClientAdapter = adapter;

const testVerifier = DiscoveryVerifier.forTesting({
  'test-discovery': '11qYAYKxCrfVS/7TyWQHOg7hcvPapiMlrwIaaPcHURo=',
});

// Public RFC 8032 seed; never used as a production trust anchor.
Future<String> signTestEnvelope(Map<String, dynamic> envelope, {List<int>? bytesOverride}) async {
  final algorithm = Ed25519();
  final key = await algorithm.newKeyPairFromSeed(
    base64.decode('nWGxne/9WmC6hEr0kuwsxERJxWl7MmkZcDusAxyuf2A='),
  );
  final signature = await algorithm.sign(
    bytesOverride ?? canonicalizeUtf8(envelope['signed']),
    keyPair: key,
  );
  return jsonEncode({
    ...envelope,
    'signatures': [
      {'key_id': 'test-discovery', 'alg': 'Ed25519', 'sig': base64.encode(signature.bytes)},
    ],
  });
}

Future<DiscoveryConfig> parseTestConfig(String source) =>
    DiscoveryConfig.parse(source, verifier: testVerifier);
