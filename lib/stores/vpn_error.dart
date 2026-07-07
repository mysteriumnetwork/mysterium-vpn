/// A user-facing VPN connection failure surfaced by `VpnStore`.
///
/// The store sets this (translation-free); the UI layer maps it to a localized
/// message and shows it — see `vpnErrorMessage` + the reaction in
/// `useHomeAutorun`.
enum VpnErrorType {
  connectionTimeout,
  tooManyRequests,
  failedToConnect,
  tunnelSetupFailed,
  tunnelPermissionRequired,
}

class VpnError {
  const VpnError(this.type, {this.errorCode});

  final VpnErrorType type;

  /// Present for [VpnErrorType.failedToConnect].
  final int? errorCode;
}
