/// Why the tunnel was torn down. Only [user] ends a session the review prompt
/// counts; the rest are transitional or app-initiated.
enum VpnDisconnectReason {
  /// The user ended the session (Disconnect, a protocol switch made in
  /// Settings, connection error).
  user,

  /// Torn down to be re-established (IP refresh or server switch).
  reconnect,

  /// The app ended it: logout, account deletion, the subscription becoming
  /// inactive or paused, or a protocol fallback after the network blocked the
  /// current protocol. Never counts as a completed session.
  appInitiated,
}
