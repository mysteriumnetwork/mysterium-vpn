import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/connection_indicator.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:styled_widget/styled_widget.dart';

class MobileConnectionStatusBar extends HookConsumerWidget {
  const MobileConnectionStatusBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vpnStore = ref.watch(vpnStorePOD);

    return Observer(builder: (context) {
      final vpnConnection = vpnStore.vpnConnection;
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _BarItem(label: LocaleKeys.connection_ip.tr(), text: vpnConnection.connectionIP),
          _BarItem(
            label: LocaleKeys.status.tr(),
            text: vpnStore.isConnected ? LocaleKeys.connected.tr() : LocaleKeys.disconnected.tr(),
            leading: ConnectionIndicator(
              isConnected: vpnStore.isConnected,
            ),
          ),
          _BarItem(
            label: LocaleKeys.location.tr(),
            text: vpnConnection.location,
            leading: vpnStore.countryFlag != null ? SvgIcon(asset: vpnStore.countryFlag!) : null,
          )
        ],
      ).padding(vertical: 20);
    });
  }
}

class _BarItem extends StatelessWidget {
  const _BarItem({
    required this.label,
    required this.text,
    this.leading,
  });

  final String label;
  final Widget? leading;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        EasyText(
          label,
          color: Palette.lightBlue,
          fontWeight: FontWeight.w400,
          fontSize: 10,
        ).padding(bottom: 4),
        Row(
          children: [
            if (leading != null) leading!.padding(right: 4),
            EasyText(
              text,
              color: Palette.white,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ],
        ),
      ],
    );
  }
}
