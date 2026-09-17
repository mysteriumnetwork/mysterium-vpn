import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/services/data/storage.dart';

/// Single source of truth for the state a sign-in attempt needs across app
/// launches: the PKCE pair, a deferred deep link, and who signed in last.
///
/// The user record itself belongs to `SessionRepository`.
abstract class AuthFlowRepository {
  Future<PkcePair?> pkcePair();

  Future<void> savePkcePair({required String codeChallenge, required String codeVerifier});

  Future<String?> appLink();

  Future<void> saveAppLink(String appLink);

  Future<String?> lastLoggedInUser();
}

/// [AuthFlowRepository] over [SecureStorageService].
class LocalAuthFlowRepository implements AuthFlowRepository {
  LocalAuthFlowRepository(this._secureStorage);

  final SecureStorageService _secureStorage;

  @override
  Future<PkcePair?> pkcePair() => _secureStorage.getPkcePair();

  @override
  Future<void> savePkcePair({required String codeChallenge, required String codeVerifier}) =>
      _secureStorage.savePkcePair(codeChallenge: codeChallenge, codeVerifier: codeVerifier);

  @override
  Future<String?> appLink() => _secureStorage.getAppLink();

  @override
  Future<void> saveAppLink(String appLink) => _secureStorage.saveAppLink(appLink: appLink);

  @override
  Future<String?> lastLoggedInUser() => _secureStorage.getLastLoggedInUser();
}
