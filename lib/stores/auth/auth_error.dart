/// A user-facing auth failure surfaced by `AuthStore`.
///
/// The store sets this (translation-free); the UI layer maps it to a localized
/// message and shows it — see `authErrorMessage` + the reaction in `app.dart`.
enum AuthErrorType {
  tokenAlreadyUsed,
  incorrectMagicLink,
  authenticationFailed,
  signInAborted,
  notAvailable,
  sessionExpired,
  generic,

  /// A raw, already-localized message from the backend (e.g. `ApiException`).
  serverMessage,
}

class AuthError {
  const AuthError(this.type, [this.message]);

  /// Convenience for the common "something went wrong" case.
  static const generic = AuthError(AuthErrorType.generic);

  final AuthErrorType type;

  /// Present only for [AuthErrorType.serverMessage].
  final String? message;
}
