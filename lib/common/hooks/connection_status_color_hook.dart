import 'dart:ui';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/core/enums/vpn_connection_status.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/core/styles/palette.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/features/vpn/store/vpn_store.dart';

Color useConnectionStatusColor() {
  final vpnStore = useProvider<VpnStore>(vpnStorePOD);
  final connectionStatus = useComputedValue(() => vpnStore.vpnStatus);
  final isLoading = useComputedValue(() => vpnStore.isFetchingConfig);

  return useMemoized(() {
    if (isLoading) {
      return Palette.yellow;
    }
    return switch (connectionStatus) {
      VpnConnectionStatus.connected => Palette.forestGreen,
      VpnConnectionStatus.disconnected => Palette.crimsonRed,
      VpnConnectionStatus.connecting => Palette.yellow,
      VpnConnectionStatus.disconnecting => Palette.yellow,
      _ => Palette.crimsonRed,
    };
  }, [connectionStatus, isLoading]);
}
