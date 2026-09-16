import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/services/services.dart';

/// Single source of truth for the persisted session: the tokens and identity
/// in secure storage, plus the local user record they key into.
abstract class SessionRepository {
  Future<String?> accessToken();

  Future<String?> refreshToken();

  /// The stored identity, or null when either half is missing.
  Future<AuthUser?> user();

  /// Persists whichever of [accessToken], [refreshToken] and [user] is given.
  Future<void> save({String? accessToken, String? refreshToken, AuthUser? user});

  /// Removes the tokens and identity.
  Future<void> clear();

  /// Stores a deliberately invalid access token and returns what is now
  /// stored, so the refresh flow can be exercised.
  Future<String?> corruptAccessToken();

  /// Mirrors the signed-in [user] into the local user record, or clears it
  /// when [user] is null.
  Future<void> cacheUserRecord(AuthUser? user);
}

/// [SessionRepository] over [SecureStorageService] and [LocalDBService].
class LocalSessionRepository implements SessionRepository {
  LocalSessionRepository({required SecureStorageService secureStorage, required LocalDBService db})
    : _secureStorage = secureStorage,
      _db = db;

  final SecureStorageService _secureStorage;
  final LocalDBService _db;

  @override
  Future<String?> accessToken() => _secureStorage.getAccessToken();

  @override
  Future<String?> refreshToken() => _secureStorage.getRefreshToken();

  @override
  Future<AuthUser?> user() async {
    final [userId, userEmail] = await Future.wait([
      _secureStorage.getUserId(),
      _secureStorage.getUsername(),
    ]);

    if (userId != null && userEmail != null) {
      return AuthUser(userId: userId, username: userEmail);
    }
    return null;
  }

  @override
  Future<void> save({String? accessToken, String? refreshToken, AuthUser? user}) async {
    if (accessToken != null) {
      await _secureStorage.saveAccessToken(accessToken);
    }
    if (refreshToken != null) {
      await _secureStorage.saveRefreshToken(refreshToken);
    }
    if (user != null) {
      await _secureStorage.saveUserId(userId: user.userId);
      await _secureStorage.saveUsername(username: user.username);
    }
  }

  @override
  Future<void> clear() async {
    await _secureStorage.removeAccessToken();
    await _secureStorage.removeRefreshToken();
    await _secureStorage.removeUserId();
    await _secureStorage.removeUsername();
  }

  @override
  Future<String?> corruptAccessToken() async {
    await _secureStorage.saveAccessToken('invalid');
    return _secureStorage.getAccessToken();
  }

  @override
  Future<void> cacheUserRecord(AuthUser? user) async {
    if (user != null) {
      await _db.setUser(user);
    } else {
      _db.clearUser();
    }
  }
}
