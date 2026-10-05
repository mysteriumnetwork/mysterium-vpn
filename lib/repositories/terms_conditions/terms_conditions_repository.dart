import 'package:mysterium_vpn/models/terms_conditions.dart';

abstract class TermsConditionsRepository {
  /// Returns the version of the terms and conditions that the user has accepted,
  /// or null if the user has not accepted any version.
  Future<String?> checkUserAcceptedVersion();

  /// Saves the version of the terms and conditions that the user has accepted.
  Future<void> acceptVersion({required String acceptedVersion});

  /// Returns the latest version of the terms and conditions.
  Future<TermsAndConditions?> getLatestVersion(String theme);
}
