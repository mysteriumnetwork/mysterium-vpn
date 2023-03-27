import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/connection_indicator.dart';
import 'package:mysterium_vpn/components/decorated_label.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/flag.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:styled_widget/styled_widget.dart';

class MobileConnectionStatusBar extends HookConsumerWidget {
  const MobileConnectionStatusBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vpnStore = ref.watch(vpnStorePOD);

    return Observer(
      builder: (context) {
        final vpnConnection = vpnStore.vpnConnection;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BarItem(label: LocaleKeys.connectionIp.tr(), text: vpnConnection.connectionIP),
            _BarItem(
              label: LocaleKeys.status.tr(),
              text: vpnStore.connectionStatus.name.tr(),
              isConnected: vpnStore.isConnected,
              leading: ConnectionIndicator(
                isConnected: vpnStore.isConnected,
              ),
            ),
            _BarItem(
              label: LocaleKeys.location.tr(),
              text: vpnConnection.location.tr(),
              leading:
                  vpnStore.isConnected ? Flag(countryCode: vpnStore.vpnConnection.location) : null,
            )
          ],
        ).padding(vertical: 20);
      },
    );
  }
}

class _BarItem extends StatelessWidget {
  const _BarItem({
    required this.label,
    required this.text,
    this.isConnected = false,
    this.leading,
  });

  final String label;
  final Widget? leading;
  final String text;
  final bool isConnected;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          EasyText(
            label,
            color: Palette.lightBlue,
            fontWeight: FontWeight.w400,
            fontSize: 10,
          ).padding(bottom: 4),
          if (isConnected)
            DecoratedLabel(
              text: text,
              color: Palette.green,
            )
          else
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
