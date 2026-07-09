import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/stores/auth/auth_error.dart';

/// Maps a translation-free [AuthError] from the store to a localized message.
/// Lives in the view layer so `AuthStore` stays free of translation.
String authErrorMessage(AuthError error) => switch (error.type) {
  AuthErrorType.tokenAlreadyUsed => S.current.tokenAlreadyUsed,
  AuthErrorType.incorrectMagicLink => S.current.incorrectMagicLink,
  AuthErrorType.authenticationFailed => S.current.authenticationFailed,
  AuthErrorType.signInAborted => S.current.signInAbortedMsg,
  AuthErrorType.notAvailable => S.current.notAvailableMsg,
  AuthErrorType.sessionExpired => S.current.loginSessionExpired,
  AuthErrorType.generic => S.current.somethingWentWrong,
  AuthErrorType.serverMessage => error.message ?? S.current.somethingWentWrong,
};
