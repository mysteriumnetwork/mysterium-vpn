import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/connect_button_animated.dart';
import 'package:mysterium_vpn/components/connection_bar.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/home/connection_info_panel.dart';
import 'package:styled_widget/styled_widget.dart';

class HomeDesktopRightPanel extends HookConsumerWidget {
  const HomeDesktopRightPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vpnStore = ref.watch(vpnStorePOD);
    final analyticsStore = ref.watch(analyticsStorePOD);
    final handleToggleConnection = useHandleToggleConnection();

    return Observer(
      builder: (context) {
        final isConnected = vpnStore.isConnected;
        final buttonSize = (getMediaWidth(context) + getMediaHeight(context)) * 0.06;

        void handleConnect() {
          analyticsStore.logEvent(
            isConnected ? AnalyticsEvent.disconnectMain : AnalyticsEvent.connectMain,
          );
          handleToggleConnection();
        }

        return Stack(
          children: [
            Positioned.fill(child: Lottie.asset(Assets.backgroundElements)),
            Column(
              children: [
                const MobileConnectionStatusBar(),
                ConnectButtonAnimated(
                  onPressed: handleConnect,
                  buttonSize: buttonSize,
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
