import 'dart:convert';
import 'dart:math';

import 'package:crypto/crypto.dart';

/// A pair of ([codeVerifier], [codeChallenge]) that can be used with PKCE
/// (Proof Key for Code Exchange).
class PkcePair {
  /// Generates a [PkcePair].
  ///
  /// [length] is the length used to generate the [codeVerifier].
  factory PkcePair.generate({int length = 128}) {
    final random = Random.secure();
    final verifier = base64UrlEncode(List.generate(length, (_) => random.nextInt(256)));
    final hash = sha256.convert(ascii.encode(verifier));

    final challenge = base64Url
        .encode(hash.bytes)
        .replaceAll('=', '')
        .replaceAll('+', '-')
        .replaceAll('/', '_');

    return PkcePair._(verifier, challenge);
  }

  ///[PkcePair] from secured storage.
  factory PkcePair.fromStorage({required String codeChallenge, required String codeVerifier}) =>
      PkcePair._(codeVerifier, codeChallenge);

  const PkcePair._(this.codeVerifier, this.codeChallenge);

  /// The code verifier.
  final String codeVerifier;

  /// The code challenge, computed as base64Url(sha256([codeVerifier])) with
  /// padding removed as per the spec.
  final String codeChallenge;

  @override
  String toString() => 'codeVerifier: $codeVerifier, codeChallenge: $codeChallenge';
}
