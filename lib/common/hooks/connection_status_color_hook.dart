import 'dart:ui';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/common/enums/vpn_connection_status.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

Color useConnectionStatusColor() {
  final vpnStore = useProvider<VpnStore>(vpnStorePOD);
  final connectionStatus = useComputedValue(() => vpnStore.vpnStatus);
  final isLoading = useComputedValue(() => vpnStore.isFetchingConfig);

  return useMemoized(() {
    if (isLoading) {
      return Palette.warning;
    }
    return switch (connectionStatus) {
      VpnConnectionStatus.connected => Palette.success,
      VpnConnectionStatus.disconnected => Palette.error,
      VpnConnectionStatus.connecting => Palette.warning,
      VpnConnectionStatus.disconnecting => Palette.warning,
      _ => Palette.error,
    };
  }, [connectionStatus, isLoading]);
}
