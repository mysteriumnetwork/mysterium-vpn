import 'dart:ui';

import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:wireguard_dart/wireguard_dart.dart';

Color useConnectionStatusColor() {
  final vpnStore = useProvider(vpnStorePOD);
  final connectionStatus = useComputedValue(() => vpnStore.vpnStatus);
  final isLoading = useComputedValue(() => vpnStore.isFetchingConfig);

  return useMemoized(
    () {
      if (isLoading) {
        return Palette.yellow;
      }
      return switch (connectionStatus) {
        ConnectionStatus.connected => Palette.forestGreen,
        ConnectionStatus.disconnected => Palette.crimsonRed,
        ConnectionStatus.connecting => Palette.yellow,
        ConnectionStatus.disconnecting => Palette.yellow,
        _ => Palette.crimsonRed,
      };
    },
    [connectionStatus, isLoading],
  );
}
