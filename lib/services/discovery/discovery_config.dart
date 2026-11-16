import 'dart:io';

import 'package:mysterium_vpn/services/discovery/discovery_verifier.dart';

class DiscoveryConfig {
  DiscoveryConfig._(this.json, this.expiresAt, this.mappings);

  static Future<DiscoveryConfig> parse(
    String source, {
    DiscoveryVerifier verifier = const DiscoveryVerifier(),
    bool allowExpired = false,
    DateTime? now,
  }) async {
    final json = await verifier.verify(source);
    final signed = json['signed'] as Map<String, dynamic>;
    final version = signed['version'];
    final issued = signed['issued_at'];
    final expires = signed['expires_at'];
    final mappings = signed['mappings'];
    if (signed['schema_version'] is! int ||
        signed['schema_version'] != 1 ||
        version is! int ||
        version < 1 ||
        issued is! String ||
        expires is! String ||
        mappings is! Map<String, dynamic>) {
      throw const FormatException('Unsupported or incomplete discovery config');
    }
    final issuedAt = DateTime.tryParse(issued);
    final expiresAt = DateTime.tryParse(expires);
    if (issuedAt == null || expiresAt == null || !expiresAt.isAfter(issuedAt)) {
      throw const FormatException('Invalid discovery dates');
    }
    if (!allowExpired && !expiresAt.isAfter(now ?? DateTime.now())) {
      throw const FormatException('Discovery configuration has expired');
    }
    final domains = <String, List<String>>{};
    for (final entry in mappings.entries) {
      final hosts = entry.value;
      if (!_validDomain(entry.key) ||
          hosts is! List ||
          hosts.isEmpty ||
          hosts.any((host) => host is! String || !_validDomain(host))) {
        throw const FormatException('Invalid discovery domains');
      }
      domains[entry.key] = List<String>.unmodifiable(hosts.cast<String>());
    }
    return DiscoveryConfig._(json, expiresAt, Map.unmodifiable(domains));
  }

  final Map<String, dynamic> json;
  final DateTime expiresAt;
  final Map<String, List<String>> mappings;

  static bool _validDomain(String host) =>
      host.length <= 253 &&
      InternetAddress.tryParse(host) == null &&
      RegExp(r'^(?:[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]{0,61}[a-z0-9])?$')
          .hasMatch(host);
}
