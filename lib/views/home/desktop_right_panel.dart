import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/connect_button.dart';
import 'package:mysterium_vpn/components/connection_bar.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/home/connection_info_panel_desktop.dart';
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
                LayoutBuilder(
                  builder: (context, con) => Stack(
                    alignment: Alignment.center,
                    children: [
                      Material(
                        color: Colors.transparent,
                        shape: const CircleBorder(),
                        clipBehavior: Clip.hardEdge,
                        shadowColor: Colors.transparent,
                        child: InkWell(
                          highlightColor: Palette.purple.withOpacity(0.2),
                          splashColor: Palette.purple.withOpacity(0.1),
                          splashFactory: InkSparkle.splashFactory,
                          onTap: () => isConnected ? vpnStore.disconnect() : vpnStore.connect(null),
                          child: Lottie.asset(
                            isConnected ? Assets.circlesPurple : Assets.circlesGrey,
                            alignment: Alignment.center,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 100,
                        width: 100,
                        child: ConnectButton(
                          callback: () {
                            isConnected ? vpnStore.disconnect() : vpnStore.connect(null);
                          },
                          isConnected: isConnected,
                          height: con.maxHeight,
                          width: con.maxHeight,
                        ),
                      ),
                    ],
                  ).padding(vertical: 40),
                ).expanded(),
                const ConnectionInfoPanelDesktop().height(148),
              ],
            ).padding(horizontal: 40, vertical: 20),
          ],
        ).backgroundColor(Palette.darkBlue);
      },
    );
  }
}
