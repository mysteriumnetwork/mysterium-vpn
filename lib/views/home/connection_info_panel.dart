import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:styled_widget/styled_widget.dart';

class ConnectionInfoPanel extends HookConsumerWidget {
  const ConnectionInfoPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vpnStore = ref.watch(vpnStorePOD);
    return Observer(
      builder: (context) {
        final isConnected = vpnStore.isConnected;
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _InfoItem(
              label: LocaleKeys.duration.tr(),
              text: '--',
              icon: isConnected ? Asset.icons.durationActive : Asset.icons.duration,
              isConnected: isConnected,
            ).expanded(),
            _InfoItem(
              label: LocaleKeys.download,
              text: '--',
              icon: isConnected ? Asset.icons.downloadActive : Asset.icons.download,
              isConnected: isConnected,
            ).expanded(),
            _InfoItem(
              label: LocaleKeys.upload,
              text: '--',
              icon: isConnected ? Asset.icons.uploadActive : Asset.icons.upload,
              isConnected: isConnected,
            ).expanded(),
          ],
        ).card(
          color: Palette.black,
          elevation: 0,
          shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20))),
        );
      },
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({
    required this.label,
    required this.isConnected,
    required this.icon,
    required this.text,
  });

  final String label;
  final String text;
  final SvgGenImage icon;
  final bool isConnected;

  @override
  Widget build(BuildContext context) => Column(
    children: [
      SvgIcon(asset: icon).padding(bottom: 20),
      EasyText(
        label,
        fontSize: 10,
        fontWeight: FontWeight.w400,
        color: isConnected ? Palette.white : Palette.lightBlack,
      ).padding(bottom: 16),
      EasyText(
        text,
        fontSize: 16,
        fontWeight: FontWeight.w700,
        color: isConnected ? Palette.white : Palette.lightBlack,
      ),
    ],
  ).padding(vertical: 20);
}
