import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/common/utils/tunnel_stats_label.dart';

void main() {
  final now = DateTime.utc(2026, 8, 24, 12);

  TunnelStatsReadout readout({DateTime? latestHandshake}) => (
    downloadMbps: 12.5,
    uploadMbps: 3.25,
    totalDownloadMb: 40,
    totalUploadMb: 10.04,
    latestHandshake: latestHandshake,
  );

  test('renders the protocol alone when there are no statistics', () {
    expect(tunnelStatsLabel(protocol: 'wireguard', stats: null, now: now), 'Protocol: wireguard');
  });

  test('renders rate, totals and handshake age on one line', () {
    final label = tunnelStatsLabel(
      protocol: 'wireguard',
      stats: readout(latestHandshake: now.subtract(const Duration(seconds: 7))),
      now: now,
    );

    expect(label, 'Protocol: wireguard · now ↓ 12.50 ↑ 3.25 Mbps · total ↓ 40.0 ↑ 10.0 MB · hs 7s');
    expect(label.contains('\n'), isFalse);
  });

  test('renders a dash when the handshake is missing', () {
    expect(tunnelStatsLabel(protocol: 'openvpn', stats: readout(), now: now), endsWith('hs —'));
  });

  test('formats the current rate on its own', () {
    expect(tunnelRateLabel(downloadMbps: 12.5, uploadMbps: 3.25), '↓ 12.50 ↑ 3.25 Mbps');
  });

  test('formats cumulative transfer on its own', () {
    expect(tunnelTotalLabel(totalDownloadMb: 40, totalUploadMb: 10.04), '↓ 40.0 ↑ 10.0 MB');
  });
}
