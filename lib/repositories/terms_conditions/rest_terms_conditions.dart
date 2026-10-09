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
  Future<TermsConsent> getConsent() =>
      _logFailures('Error loading terms and conditions consent', () async {
        final response = await _api.getTerms().userTerms();
        return TermsConsent(
          acceptedVersion: response.data?.acceptedVersion,
          latestVersion: response.data?.latestVersion,
        );
      });

  @override
  Future<void> acceptVersion({required String acceptedVersion}) =>
      _logFailures('Error accepting terms and conditions version', () async {
        final request = AuthTermsRequest(version: acceptedVersion);
        await _api.getTerms().acceptTerms(authTermsRequest: request);
      });

  @override
  Future<TermsAndConditions?> getLatestVersion(String theme) =>
      _logFailures('Error getting latest terms and conditions version', () async {
        final response = await _api.getTerms().terms(theme: theme);
        final content = response.data?.content;
        final version = response.data?.version;
        if (content.isNullOrEmpty || version.isNullOrEmpty) {
          return null;
        }
        return TermsAndConditions(content: content!, version: version!);
      });

  /// Expected failures are logged as warnings, never as fatal, then rethrown
  /// for the store to map.
  Future<T> _logFailures<T>(String message, Future<T> Function() call) async {
    try {
      return await call();
    } catch (e, stackTrace) {
      _logger.warning(message, e, stackTrace);
      rethrow;
    }
  }
}
