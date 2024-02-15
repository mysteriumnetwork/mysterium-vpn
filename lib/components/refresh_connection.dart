import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:styled_widget/styled_widget.dart';

class RefreshConnection extends HookConsumerWidget {
  const RefreshConnection({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vpnStore = ref.watch(vpnStorePOD);
    return Observer(
      builder: (context) => Visibility(
        visible: vpnStore.isConnected,
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            backgroundColor: Palette.blue,
            padding: EdgeInsets.zero,
          ),
          onPressed: () => vpnStore.toggleConnection(refreshIP: true),
          label: EasyText(
            LocaleKeys.refreshIP.tr(),
            fontSize: 12,
            color: Palette.white,
          ),
          icon: const SvgIcon(
            asset: Assets.refreshConn,
          ),
        ).height(32).width(105).padding(top: 4),
      ),
    );
  }
}
