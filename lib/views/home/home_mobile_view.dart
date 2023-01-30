import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/components/connect_button.dart';
import 'package:mysterium_vpn/components/connection_bar.dart';
import 'package:mysterium_vpn/components/mobile_app_bar.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:styled_widget/styled_widget.dart';

class HomeMobileView extends HookConsumerWidget {
  const HomeMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vpnStore = ref.watch(vpnStorePOD);

    return Observer(builder: (context) {
      return Stack(
        children: [
          Lottie.asset(Assets.backgroundElements),
          Lottie.asset(Assets.circlesGrey).padding(top: 50),
          Column(
            children: const [
              MobileAppBar(),
              MobileConnectionBar(),
            ],
          ).padding(horizontal: 20, top: 30),
          Center(
            child: ConnectButton(
              callback: () {
                vpnStore.vpnConnection.connectionStatus == ConnectionStatus.connected
                    ? vpnStore.disconnect()
                    : vpnStore.connect();
              },
              connectionStatus: vpnStore.vpnConnection.connectionStatus,
            ),
          ),
        ],
      );
    });
  }
}
