import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

void main() {
  group('VpnConnectionStatusView.toBarStatus', () {
    test('maps raw tunnel statuses', () {
      expect(
        VpnConnectionStatus.connected.toBarStatus(isFetchingConfig: false, isDisconnecting: false),
        BarStatus.connected,
      );
      expect(
        VpnConnectionStatus.connecting.toBarStatus(isFetchingConfig: false, isDisconnecting: false),
        BarStatus.connecting,
      );
      expect(
        VpnConnectionStatus.disconnected.toBarStatus(
          isFetchingConfig: false,
          isDisconnecting: false,
        ),
        BarStatus.disconnected,
      );
      expect(
        VpnConnectionStatus.unknown.toBarStatus(isFetchingConfig: false, isDisconnecting: false),
        BarStatus.disconnected,
      );
      expect(
        VpnConnectionStatus.disconnecting.toBarStatus(
          isFetchingConfig: false,
          isDisconnecting: false,
        ),
        BarStatus.disconnecting,
      );
    });

    test('fetching config reports getting IP over the raw status', () {
      expect(
        VpnConnectionStatus.connected.toBarStatus(isFetchingConfig: true, isDisconnecting: false),
        BarStatus.gettingIp,
      );
    });

    test('teardown in flight reports disconnecting after the tunnel is down', () {
      expect(
        VpnConnectionStatus.disconnected.toBarStatus(
          isFetchingConfig: false,
          isDisconnecting: true,
        ),
        BarStatus.disconnecting,
      );
    });

    test('teardown in flight wins over fetching config', () {
      expect(
        VpnConnectionStatus.connecting.toBarStatus(isFetchingConfig: true, isDisconnecting: true),
        BarStatus.disconnecting,
      );
    });
  });
}
