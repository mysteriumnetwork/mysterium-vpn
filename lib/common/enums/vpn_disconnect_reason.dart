/// Why the tunnel was torn down. Only [user] ends a session the review prompt
/// counts; the rest are transitional or app-initiated.
enum VpnDisconnectReason {
  /// The user ended the session (Disconnect, protocol switch, connection error).
  user,

  /// Torn down to be re-established (IP refresh or server switch).
  reconnect,

  /// The app ended it: logout, account deletion, or the subscription becoming
  /// inactive or paused. Never counts as a completed session.
  appInitiated,
}
