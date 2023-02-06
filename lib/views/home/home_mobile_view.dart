import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/connect_button.dart';
import 'package:mysterium_vpn/components/connection_bar.dart';
import 'package:mysterium_vpn/components/connection_info_panel.dart';
import 'package:mysterium_vpn/components/mobile_app_bar.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/locations/locations_slider_mobile_view.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:styled_widget/styled_widget.dart';

class HomeMobileView extends HookConsumerWidget {
  const HomeMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vpnStore = ref.watch(vpnStorePOD);
    return Observer(builder: (context) {
      bool isConnected = vpnStore.isConnected;
      return SlidingUpPanel(
        maxHeight: getMediaHeight(context) * 0.8,
        minHeight: getMediaHeight(context) * 0.35,
        parallaxEnabled: true,
        parallaxOffset: .1,
        color: Theme.of(context).primaryColor,
        isDraggable: true,
        panelBuilder: (sc) => LocationsSliderMobileView(sc: sc),
        borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(18.0), topRight: Radius.circular(18.0)),
        body: Stack(
          children: [
            Lottie.asset(Assets.backgroundElements),
            Column(
              children: [
                const MobileAppBar(),
                const MobileConnectionStatusBar(),
                LayoutBuilder(builder: (context, con) {
                  return Stack(
                    alignment: Alignment.center,
                    children: [
                      Lottie.asset(
                        isConnected ? Assets.circlesPurple : Assets.circlesGrey,
                        alignment: Alignment.center,
                      ),
                      ConnectButton(
                        callback: () {
                          isConnected ? vpnStore.disconnect() : vpnStore.connect();
                        },
                        isConnected: isConnected,
                        height: con.maxHeight,
                        width: con.maxHeight,
                      )
                    ],
                  ).padding(bottom: 20);
                }).expanded(),
                const ConnectionInfoPanel().height(90)
              ],
            ).height(getMediaHeight(context) * 0.65 - getWindowPadding().top),
          ],
        ),
      );
    });
  }
}
