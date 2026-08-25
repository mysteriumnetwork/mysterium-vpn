import 'package:localizely_sdk/localizely_sdk.dart';
import 'package:talker/talker.dart';

/// Fetches over-the-air translations, returning whether the fetch succeeded.
/// Never throws, and never reaches `Talker.handle` — which Crashlytics records
/// as a fatal crash — so an unavailable bundle just keeps the bundled ARBs.
Future<bool> fetchOtaTranslations({
  required Talker logger,
  Future<void> Function() fetch = Localizely.updateTranslations,
  // The SDK's http client sets no timeout of its own.
  Duration timeout = const Duration(seconds: 10),
}) async {
  try {
    await fetch().timeout(timeout);
    return true;
  } catch (e) {
    logger.log('OTA translation update error (non-fatal): $e');
    return false;
  }
}
