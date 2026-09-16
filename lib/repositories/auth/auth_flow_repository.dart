import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/services/services.dart';

/// Single source of truth for the state a sign-in attempt needs across app
/// launches: the PKCE pair, a deferred deep link, and who signed in last.
abstract class AuthFlowRepository {
  Future<PkcePair?> pkcePair();

  Future<void> savePkcePair({required String codeChallenge, required String codeVerifier});

  Future<String?> appLink();

  Future<void> saveAppLink(String appLink);

  Future<String?> lastLoggedInUser();

  /// The signed-in user's local record, written on sign-in.
  Future<void> setUser(AuthUser user);

  Future<UserData> userData();
}

/// [AuthFlowRepository] over [SecureStorageService] and [LocalDBService].
class LocalAuthFlowRepository implements AuthFlowRepository {
  LocalAuthFlowRepository({required SecureStorageService secureStorage, required LocalDBService db})
    : _secureStorage = secureStorage,
      _db = db;

  final SecureStorageService _secureStorage;
  final LocalDBService _db;

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

  @override
  Future<void> setUser(AuthUser user) => _db.setUser(user);

  @override
  Future<UserData> userData() => _db.getUserData();
}
