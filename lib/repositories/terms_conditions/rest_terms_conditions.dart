import 'package:mysterium_vpn/common/extensions/string.dart';
import 'package:mysterium_vpn/models/terms_conditions.dart';
import 'package:mysterium_vpn/repositories/terms_conditions/terms_conditions_repository.dart';
import 'package:talker/talker.dart';
import 'package:vpn_api/vpn_api.dart';

class RestTermsConditionsRepository implements TermsConditionsRepository {
  RestTermsConditionsRepository({required this._api, required this._logger});

  final VpnApi _api;
  final Talker _logger;

  @override
  Future<String?> checkUserAcceptedVersion() async {
    try {
      final response = await _api.getAuthentication().checkAuth();
      final termsVersion = response.data?.termsVersion;
      return termsVersion;
    } catch (e, stackTrace) {
      _logger.warning('Error checking user accepted terms and conditions version', e, stackTrace);
      rethrow;
    }
  }

  @override
  Future<void> acceptVersion({required String acceptedVersion}) async {
    try {
      final request = AuthTermsRequest(version: acceptedVersion);
      final response = await _api.getTerms().acceptTerms(authTermsRequest: request);
      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to save accepted terms and conditions version');
      }
    } catch (e, stackTrace) {
      _logger.warning('Error accepting terms and conditions version', e, stackTrace);
      throw Exception('Failed to save accepted terms and conditions version');
    }
  }

  @override
  Future<TermsAndConditions?> getLatestVersion(String theme) async {
    try {
      final response = await _api.getTerms().terms(theme: theme);
      final content = response.data?.content;
      final version = response.data?.version;
      if (content.isNullOrEmpty || version.isNullOrEmpty) {
        return null;
      }
      return TermsAndConditions(content: content!, version: version!);
    } catch (e, stackTrace) {
      _logger.warning('Error getting latest terms and conditions version', e, stackTrace);
      rethrow;
    }
  }
}
