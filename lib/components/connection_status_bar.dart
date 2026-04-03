import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class ConnectionStatusBar extends HookConsumerWidget {
  const ConnectionStatusBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vpnStore = ref.watch(vpnStorePOD);
    final connectionStatus = useComputedValue(() => vpnStore.vpnStatus);
    final isFetchingConfig = useComputedValue(() => vpnStore.isFetchingConfig);

    return ConnectionBar(
      label: _statusText(connectionStatus, isFetchingConfig),
      killSwitchLabel: LocaleKeys.killSwitchTooltipTitle.tr(),
      killSwitchDescription: LocaleKeys.killSwitchTooltipMessage.tr(),
      status: _mapStatus(connectionStatus, isFetchingConfig),
    );
  }

  String _statusText(VpnConnectionStatus connectionStatus, bool isFetchingConfig) {
    if (isFetchingConfig) {
      return LocaleKeys.gettingIPAddress.tr();
    }
    return switch (connectionStatus) {
      VpnConnectionStatus.connected => LocaleKeys.connected.tr(),
      VpnConnectionStatus.connecting => LocaleKeys.connecting.tr(),
      VpnConnectionStatus.disconnected => LocaleKeys.disconnected.tr(),
      VpnConnectionStatus.disconnecting => LocaleKeys.disconnecting.tr(),
      VpnConnectionStatus.unknown => '',
    };
  }

  BarStatus _mapStatus(VpnConnectionStatus status, bool isFetchingConfig) {
    if (isFetchingConfig) {
      return BarStatus.gettingIp;
    }
    return switch (status) {
      VpnConnectionStatus.connected => BarStatus.connected,
      VpnConnectionStatus.connecting => BarStatus.connecting,
      VpnConnectionStatus.disconnected => BarStatus.disconnected,
      VpnConnectionStatus.disconnecting => BarStatus.disconnecting,
      VpnConnectionStatus.unknown => BarStatus.disconnected,
    };
  }
}
