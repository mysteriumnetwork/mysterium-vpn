import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:mysterium_vpn/l10n/ota_translations.dart';
import 'package:talker/talker.dart';

import 'ota_translations_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Talker>()])
void main() {
  late MockTalker logger;

  setUp(() => logger = MockTalker());

  test('reports fresh translations when the fetch succeeds', () async {
    expect(await fetchOtaTranslations(logger: logger, fetch: () async {}), isTrue);
  });

  // Localizely 404s with `release_not_found` while the distribution has no
  // release — expected, and never a crash.
  test('a failed fetch keeps the bundled translations and is not a crash', () async {
    final fetched = await fetchOtaTranslations(
      logger: logger,
      fetch: () async => throw Exception('release_not_found'),
    );

    expect(fetched, isFalse);
    verifyNever(logger.handle(any, any, any));
  });

  test('a stalled fetch gives up instead of blocking on it', () async {
    final fetched = await fetchOtaTranslations(
      logger: logger,
      fetch: () => Completer<void>().future,
      timeout: const Duration(milliseconds: 20),
    );

    expect(fetched, isFalse);
    verifyNever(logger.handle(any, any, any));
  });
}
