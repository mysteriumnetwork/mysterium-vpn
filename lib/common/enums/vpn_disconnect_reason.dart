/// Why the tunnel was torn down. [user] ends the user's own connection attempt;
/// the rest are transitional or app-initiated.
enum VpnDisconnectReason {
  /// The user ended the session (Disconnect, a protocol switch made in
  /// Settings, connection error).
  user,

  /// Torn down to be re-established (IP refresh or server switch).
  reconnect,

  /// The app ended it (entitlement lost, protocol fallback, failed startup).
  appInitiated,

  /// The app ended it because the account is going away: logout or account
  /// deletion.
  logout;

  /// Whether the app, not the user, tore the tunnel down.
  bool get isAppInitiated => this == appInitiated || this == logout;
}
