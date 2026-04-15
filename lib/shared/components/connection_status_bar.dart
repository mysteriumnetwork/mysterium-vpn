import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/features/vpn/store/vpn_store.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class ConnectionStatusBar extends StatelessWidget {
  const ConnectionStatusBar({super.key});

  @override
  Widget build(BuildContext context) {
    final vpnStore = getIt<VpnStore>();
    return Observer(
      builder: (_) => ConnectionBar(
        label: _statusText(vpnStore.vpnStatus, vpnStore.isFetchingConfig),
        killSwitchLabel: LocaleKeys.killSwitchTooltipTitle.tr(),
        killSwitchDescription: LocaleKeys.killSwitchTooltipMessage.tr(),
        status: _mapStatus(vpnStore.vpnStatus, vpnStore.isFetchingConfig),
      ),
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
