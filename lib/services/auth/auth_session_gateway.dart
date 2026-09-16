import 'package:mysterium_vpn/models/models.dart';

/// Narrow session port so auth services can clear the local session without
/// depending on `AuthSessionStore`.
abstract interface class AuthSessionGateway {
  AuthUser? get user;

  Future<void> setUnauthenticated();
}
