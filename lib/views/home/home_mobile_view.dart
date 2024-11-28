import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/connect_button_animated.dart';
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
    final analyticsStore = ref.watch(analyticsStorePOD);
    final pc = useMemoized(PanelController.new);
    final handleToggleConnection = useHandleToggleConnection();

    return Observer(
      builder: (context) {
        final size = Size(getMediaWidth(context), getMediaHeight(context));
        final isConnected = vpnStore.isConnected;
        final buttonSize = (size.width + size.height) * 0.08;

        void handleConnect() {
          analyticsStore.logEvent(
            isConnected ? AnalyticsEvent.disconnectMain : AnalyticsEvent.connectMain,
          );
          handleToggleConnection();
        }

        return SlidingUpPanel(
          maxHeight: size.height * 0.8,
          minHeight: size.height * 0.4,
          controller: pc,
          isDraggable: !isDesktop(),
          color: Theme.of(context).primaryColor,
          panelBuilder: (sc) => LocationsSliderMobileView(pc: pc, sc: sc),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
          body: Stack(
            children: [
              Lottie.asset(Assets.backgroundElements),
              Column(
                children: [
                  const HomeMobileAppBar(),
                  const MobileConnectionStatusBar(),
                  ConnectButtonAnimated(
                    onPressed: handleConnect,
                    buttonSize: buttonSize,
                  ).expanded(),
                  SizedBox(height: size.height * 0.08),
                ],
              ).height(size.height * 0.66 - getWindowPadding().top),
            ],
          ),
        );
      },
    );
  }
}
