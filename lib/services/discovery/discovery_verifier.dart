import 'dart:convert';

import 'package:cryptography/cryptography.dart';
import 'package:flutter/foundation.dart';
import 'package:json_canonicalizer/json_canonicalizer.dart';

const _trustedKeys = <String, String>{
  'discovery-2026-11': 'A06gWTPsthdi7mDhmSaOyyr3BbMvaN5A/1xFrYw8doA=',
};

class DiscoveryVerifier {
  const DiscoveryVerifier() : _keys = _trustedKeys;

  @visibleForTesting
  const DiscoveryVerifier.forTesting(this._keys);

  final Map<String, String> _keys;

  Future<Map<String, dynamic>> verify(String source) async {
    if (utf8.encode(source).length > 1 << 20) {
      throw const FormatException('Discovery config exceeds 1 MiB');
    }
    // JCS numbers are IEEE-754 binary64, including JSON integer literals.
    final json = jsonDecode(source, reviver: (_, value) => value is num ? value.toDouble() : value);
    _rejectDuplicateKeys(source);
    canonicalizeUtf8(json);
    if (json is! Map<String, dynamic> ||
        json['signed'] is! Map<String, dynamic> ||
        json['signatures'] is! List<Object?>) {
      throw const FormatException('Missing signed discovery envelope');
    }
    final canonical = canonicalizeUtf8(json['signed']);
    for (final entry in json['signatures'] as List<Object?>) {
      if (entry is! Map<String, dynamic> || entry['alg'] != 'Ed25519') {
        continue;
      }
      final encodedKey = _keys[entry['key_id']];
      final encodedSignature = entry['sig'];
      if (encodedKey == null || encodedSignature is! String) {
        continue;
      }
      try {
        final key = base64.decode(encodedKey);
        final signature = base64.decode(encodedSignature);
        if (key.length != 32 ||
            signature.length != 64 ||
            base64.encode(signature) != encodedSignature) {
          continue;
        }
        if (await Ed25519().verify(
          canonical,
          signature: Signature(
            signature,
            publicKey: SimplePublicKey(key, type: KeyPairType.ed25519),
          ),
        )) {
          json['signed'] = jsonDecode(utf8.decode(canonical));
          return json;
        }
      } on FormatException {
        continue;
      }
    }
    throw const FormatException('Discovery has no valid trusted Ed25519 signature');
  }

  // dart:convert otherwise silently overwrites duplicate object properties.
  void _rejectDuplicateKeys(String source) {
    final scopes = <Set<String>?>[];
    final expectingKey = <bool>[];
    final tokens = RegExp(r'"(?:[^"\\]|\\.)*"|[{}\[\],]');
    for (final match in tokens.allMatches(source)) {
      final token = match.group(0)!;
      if (token == '{' || token == '[') {
        scopes.add(token == '{' ? <String>{} : null);
        expectingKey.add(token == '{');
      } else if (token == '}' || token == ']') {
        scopes.removeLast();
        expectingKey.removeLast();
      } else if (token == ',') {
        expectingKey[expectingKey.length - 1] = scopes.last != null;
      } else if (scopes.isNotEmpty && expectingKey.last) {
        final key = jsonDecode(token) as String;
        if (!scopes.last!.add(key)) {
          throw const FormatException('Duplicate discovery JSON property');
        }
        expectingKey[expectingKey.length - 1] = false;
      }
    }
  }
}
