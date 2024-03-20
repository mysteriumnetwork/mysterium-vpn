import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/connection_indicator.dart';
import 'package:mysterium_vpn/components/decorated_label.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/flag.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
import 'package:mysterium_vpn/components/refresh_connection.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:styled_widget/styled_widget.dart';

enum LeadingPosition {
  left,
  right,
  bottom,
}

class MobileConnectionStatusBar extends HookConsumerWidget {
  const MobileConnectionStatusBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vpnStore = ref.watch(vpnStorePOD);

    return Observer(
      builder: (context) {
        final vpnConnection = vpnStore.vpnConnection;
        return Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _BarItem(
              label: LocaleKeys.connectionIp.tr(),
              text: vpnConnection?.connectionIP ?? '--',
              maxLines: 1,
              action: const RefreshConnection(),
              indicator: vpnConnection?.isResolvingconnectionIP ?? false
                  ? const Padding(
                      padding: EdgeInsets.all(4),
                      child: LoadingIndicator(
                        radius: 14,
                      ),
                    )
                  : null,
            ).expanded(),
            _BarItem(
              label: LocaleKeys.status.tr(),
              text: vpnStore.connectionStatus.name.tr(),
              isConnected: vpnStore.isConnected,
              leading: ConnectionIndicator(
                isConnected: vpnStore.isConnected,
              ),
              maxLines: 1,
            ).expanded(),
            _BarItem(
              label: LocaleKeys.location.tr(),
              leading: vpnStore.isConnected
                  ? Flag(countryCode: vpnStore.vpnConnection?.location ?? '')
                  : null,
              text: vpnConnection?.location.tr() ?? '--',
              leadingPosition: LeadingPosition.bottom,
              maxLines: 2,
            ).expanded(),
          ],
        ).padding(vertical: 20, horizontal: 4);
      },
    );
  }
}

class _BarItem extends StatelessWidget {
  const _BarItem({
    required this.label,
    required this.text,
    required this.maxLines,
    this.isConnected = false,
    this.leading,
    this.leadingPosition = LeadingPosition.left,
    this.action,
    this.indicator,
  });

  final String label;
  final Widget? leading;
  final Widget? action;
  final String text;
  final bool isConnected;
  final LeadingPosition leadingPosition;
  final int maxLines;
  final Widget? indicator;
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
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (leadingPosition == LeadingPosition.left && leading != null)
                  leading!.paddingDirectional(end: 4),
                if (indicator != null)
                  indicator!
                else
                  EasyText(
                    text,
                    color: Palette.white,
                    fontWeight: FontWeight.w500,
                    fontSize: 12,
                    textAlign: TextAlign.center,
                    maxLines: maxLines,
                  ).flexible(),
              ],
            ),
          if (leadingPosition == LeadingPosition.bottom && leading != null)
            leading!.padding(top: 4),
          action ?? const SizedBox(),
        ],
      );
}
