import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/stores/vpn_error.dart';

/// Maps a translation-free [VpnError] from the store to a localized message.
/// Lives in the view layer so `VpnStore` stays free of translation.
String vpnErrorMessage(VpnError error) => switch (error.type) {
  VpnErrorType.connectionTimeout => S.current.connectionTimeout,
  VpnErrorType.tooManyRequests => S.current.toManyRequestsErrorMsg,
  VpnErrorType.failedToConnect => S.current.failedToConnectError(error.errorCode ?? 0),
  VpnErrorType.tunnelSetupFailed => S.current.tunnelSetupError,
  VpnErrorType.tunnelPermissionRequired => S.current.tunnelPermissionRequired,
};
