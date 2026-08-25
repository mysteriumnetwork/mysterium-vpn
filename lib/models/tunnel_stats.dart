import 'package:flutter/foundation.dart';

/// Tunnel byte counters, normalised across VPN protocols.
///
/// [latestHandshake] is null when the protocol has no handshake (OpenVPN) or
/// none has happened yet — the repositories translate each protocol's sentinel,
/// so no consumer has to know about it.
@immutable
class TunnelStats {
  const TunnelStats({required this.totalDownload, required this.totalUpload, this.latestHandshake});

  final int totalDownload;
  final int totalUpload;
  final DateTime? latestHandshake;

  /// Value equality matters: the store assigns a sample every second, and MobX
  /// skips notifying observers when the new value equals the old one.
  @override
  bool operator ==(Object other) =>
      other is TunnelStats &&
      other.totalDownload == totalDownload &&
      other.totalUpload == totalUpload &&
      other.latestHandshake == latestHandshake;

  @override
  int get hashCode => Object.hash(totalDownload, totalUpload, latestHandshake);
}
