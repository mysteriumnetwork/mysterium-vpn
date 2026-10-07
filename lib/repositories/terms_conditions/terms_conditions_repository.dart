import 'package:mysterium_vpn/models/terms_conditions.dart';

abstract class TermsConditionsRepository {
  /// Version the user accepted, or null when they have not accepted one.
  /// Throws when the request fails.
  Future<String?> checkUserAcceptedVersion();

  /// Saves the version of the terms and conditions that the user has accepted.
  Future<void> acceptVersion({required String acceptedVersion});

  /// Latest terms, or null when the response has no content or version.
  /// Throws when the request fails.
  Future<TermsAndConditions?> getLatestVersion(String theme);
}
