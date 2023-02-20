import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:styled_widget/styled_widget.dart';

class ConnectionInfoPanel extends HookConsumerWidget {
  const ConnectionInfoPanel({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vpnStore = ref.watch(vpnStorePOD);
    return Observer(builder: (context) {
      final isConnected = vpnStore.isConnected;
      return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _InfoItem(
            label: LocaleKeys.duration.tr(),
            text: vpnStore.duration?.toHoursMinutesSeconds() ?? '--',
            icon: isConnected ? Assets.durationActive : Assets.duration,
            isConnected: isConnected,
          ).expanded(),
          _InfoItem(
            label: LocaleKeys.download,
            text: vpnStore.downloadSpeed?.toStringAsFixed(2) ?? '--',
            icon: isConnected ? Assets.downloadActive : Assets.download,
            isConnected: isConnected,
          ).expanded(),
          _InfoItem(
            label: LocaleKeys.upload,
            text: vpnStore.uploadSpeed?.toStringAsFixed(2) ?? '--',
            icon: isConnected ? Assets.uploadActive : Assets.upload,
            isConnected: isConnected,
          ).expanded(),
        ],
      ).card(
        color: Palette.black,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
      );
    });
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem(
      {required this.label,
      required this.isConnected,
      required this.icon,
      required this.text,
      Key? key})
      : super(key: key);
  final String label;
  final String text;
  final String icon;
  final bool isConnected;
  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.center,
      children: [
        Positioned(
          top: -7,
          child: SvgIcon(
            asset: icon,
          ),
        ),
        Positioned(
          top: 5,
          child: Column(
            children: [
              EasyText(
                label,
                fontSize: 10,
                fontWeight: FontWeight.w400,
                color: isConnected ? Palette.white : Palette.lightBlack,
              ).padding(bottom: 6),
              EasyText(
                text,
                fontSize: 16,
                fontWeight: FontWeight.w900,
                color: isConnected ? Palette.white : Palette.lightBlack,
              )
            ],
          ).padding(vertical: 16),
        ),
      ],
    );
  }
}
