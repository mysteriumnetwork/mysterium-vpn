import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/connect_button.dart';
import 'package:mysterium_vpn/components/connection_bar.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/home/connection_info_panel.dart';
import 'package:styled_widget/styled_widget.dart';

class HomeDesktopRightPanel extends ConsumerWidget {
  const HomeDesktopRightPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vpnStore = ref.watch(vpnStorePOD);
    return Observer(
      builder: (context) {
        final isConnected = vpnStore.isConnected;
        return Stack(
          children: [
            Lottie.asset(Assets.backgroundElements),
            Column(
              children: [
                const MobileConnectionStatusBar(),
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Lottie.asset(
                      isConnected ? Assets.circlesPurple : Assets.circlesGrey,
                      alignment: Alignment.center,
                    ),
                    ConnectButton(
                      onPressed: vpnStore.toggleConnection,
                    ).width((getMediaWidth(context) + getMediaHeight(context)) * 0.06),
                  ],
                ).padding(vertical: 40).expanded(),
                const Visibility(
                  visible: false,
                  child: ConnectionInfoPanel(),
                ),
              ],
            ).padding(horizontal: 40, vertical: 20),
          ],
        ).backgroundColor(Palette.darkBlue);
      },
    );
  }
}
