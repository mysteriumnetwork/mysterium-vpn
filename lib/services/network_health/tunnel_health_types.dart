/// One leg of a health probe. `elapsed` is null when the request failed.
typedef TunnelHealthLeg = ({Duration? elapsed, String? ip, Object? error});

enum TunnelHealthVerdict {
  healthy,
  degraded,

  /// Both legs failed — the device has no working internet.
  noNetwork,

  /// The direct leg failed, so the tunnel cannot be blamed.
  inconclusive,

  /// The direct leg did not demonstrably bypass the tunnel.
  bypassUnavailable,
}

class TunnelHealthSample {
  const TunnelHealthSample({
    required this.tunnelled,
    required this.direct,
    required this.bypassVerified,
    required this.controlReachable,
  });

  final TunnelHealthLeg tunnelled;
  final TunnelHealthLeg direct;

  /// The direct leg returned an IP and it differs from the exit IP.
  final bool bypassVerified;

  /// A raw TCP connect to the control IP succeeded.
  ///
  /// Deliberately needs neither DNS nor TLS: the tunnel pushes its own
  /// resolver, so a broken tunnel breaks name resolution for both HTTP legs
  /// alike. This is the only check that still answers "is the user's own
  /// network alive" when that happens, which is what separates a bad node from
  /// a bad connection.
  final bool controlReachable;
}
