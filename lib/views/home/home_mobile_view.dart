import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/connect_button.dart';
import 'package:mysterium_vpn/components/connection_bar.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/home/home_mobile_app_bar.dart';
import 'package:mysterium_vpn/views/locations/locations_slider_mobile_view.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:styled_widget/styled_widget.dart';

class HomeMobileView extends HookConsumerWidget {
  const HomeMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vpnStore = ref.watch(vpnStorePOD);
    final pc = useMemoized(PanelController.new);

    return Observer(
      builder: (context) {
        final isConnected = vpnStore.isConnected;
        return SlidingUpPanel(
          maxHeight: getMediaHeight(context) * 0.8,
          minHeight: getMediaHeight(context) * 0.4,
          controller: pc,
          panelSnapping: false,
          color: Theme.of(context).primaryColor,
          panelBuilder: (sc) => LocationsSliderMobileView(
            sc: sc,
            pc: pc,
          ),
          borderRadius:
              const BorderRadius.only(topLeft: Radius.circular(20), topRight: Radius.circular(20)),
          body: Stack(
            children: [
              Lottie.asset(Assets.backgroundElements),
              Column(
                children: [
                  const HomeMobileAppBar(),
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
                      ).width((getMediaWidth(context) + getMediaHeight(context)) * 0.08),
                    ],
                  ).padding(bottom: getMediaHeight(context) * 0.08).expanded(),
                  // const Visibility(visible: false, child: ConnectionInfoPanel()),
                ],
              ).height(getMediaHeight(context) * 0.66 - getWindowPadding().top),
            ],
          ),
        );
      },
    );
  }
}
