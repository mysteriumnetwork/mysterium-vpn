import 'package:mysterium_vpn/models/terms_conditions.dart';

abstract class TermsConditionsRepository {
  /// Accepted and latest versions as the backend sees them.
  /// Throws when the request fails.
  Future<TermsConsent> getConsent();

  /// Saves the version of the terms and conditions that the user has accepted.
  Future<void> acceptVersion({required String acceptedVersion});

  /// Latest terms, or null when the response has no content or version.
  /// Throws when the request fails.
  Future<TermsAndConditions?> getLatestVersion(String theme);
}
