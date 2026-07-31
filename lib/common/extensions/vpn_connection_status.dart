import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

extension VpnConnectionStatusView on VpnConnectionStatus {
  /// Maps to the design-system connection state; fetching config renders as
  /// "getting IP" regardless of the raw tunnel status.
  BarStatus toBarStatus({required bool isFetchingConfig}) {
    if (isFetchingConfig) {
      return BarStatus.gettingIp;
    }
    return switch (this) {
      VpnConnectionStatus.connected => BarStatus.connected,
      VpnConnectionStatus.connecting => BarStatus.connecting,
      VpnConnectionStatus.disconnected || VpnConnectionStatus.unknown => BarStatus.disconnected,
      VpnConnectionStatus.disconnecting => BarStatus.disconnecting,
    };
  }
}

extension BarStatusLabel on BarStatus {
  /// Localized status text matching the [BarStatus] state.
  String get localizedLabel => switch (this) {
    BarStatus.connected => S.current.connected,
    BarStatus.connecting => S.current.connecting,
    BarStatus.gettingIp => S.current.gettingIPAddress,
    BarStatus.disconnected => S.current.disconnected,
    BarStatus.disconnecting => S.current.disconnecting,
  };
}
