/// Live tunnel counters for [tunnelStatsLabel]. A record rather than a class so
/// the formatter stays free of the store layer and is trivially unit-testable.
typedef TunnelStatsReadout = ({
  double downloadMbps,
  double uploadMbps,
  double totalDownloadMb,
  double totalUploadMb,
  DateTime? latestHandshake,
});

/// One-line QA readout shown under the connection tile in dev builds:
/// `Protocol: wireguard · now ↓ 12.50 ↑ 3.25 Mbps · total ↓ 40.0 ↑ 10.0 MB · hs 7s`.
///
/// Falls back to the protocol alone when [stats] is null while disconnected,
/// and to `no stats (<[unavailableReason]>)` when [connected] — a platform that
/// reports nothing, one whose read fails and one that hangs would otherwise be
/// indistinguishable from an idle tunnel, since all four draw zeros.
/// A null handshake renders as `hs —`: OpenVPN has no equivalent, and
/// WireGuard has none before the first one lands.
String tunnelStatsLabel({
  required String protocol,
  required TunnelStatsReadout? stats,
  required DateTime now,
  bool connected = false,
  String? unavailableReason,
}) {
  final label = 'Protocol: $protocol';
  if (stats == null) {
    if (!connected) {
      return label;
    }
    return unavailableReason == null
        ? '$label · no stats'
        : '$label · no stats ($unavailableReason)';
  }

  final handshake = stats.latestHandshake;
  final handshakeLabel = handshake == null ? 'hs —' : 'hs ${now.difference(handshake).inSeconds}s';

  return [
    label,
    'now ${tunnelRateLabel(downloadMbps: stats.downloadMbps, uploadMbps: stats.uploadMbps)}',
    'total ${tunnelTotalLabel(totalDownloadMb: stats.totalDownloadMb, totalUploadMb: stats.totalUploadMb)}',
    handshakeLabel,
  ].join(' · ');
}

/// Throughput over the last sampling interval, e.g. `↓ 12.50 ↑ 3.25 Mbps` —
/// how much is moving through the tunnel right now, not a link speed.
String tunnelRateLabel({required double downloadMbps, required double uploadMbps}) =>
    '↓ ${downloadMbps.toStringAsFixed(2)} ↑ ${uploadMbps.toStringAsFixed(2)} Mbps';

/// Cumulative transfer for the session, e.g. `↓ 40.0 ↑ 10.0 MB`.
String tunnelTotalLabel({required double totalDownloadMb, required double totalUploadMb}) =>
    '↓ ${totalDownloadMb.toStringAsFixed(1)} ↑ ${totalUploadMb.toStringAsFixed(1)} MB';
