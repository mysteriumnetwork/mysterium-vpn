import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:lottie/lottie.dart';
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
      bool isConnected = vpnStore.isConnected;
      return Stack(
        children: [
          Lottie.asset(Assets.backgroundElements),
          Column(
            children: [
              const MobileAppBar(),
              const MobileConnectionBar(),
              Expanded(
                child: LayoutBuilder(builder: (context, con) {
                  return Stack(
                    alignment: AlignmentDirectional.center,
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
                        width: con.maxWidth,
                      ),
                    ],
                  );
                }),
              ),
              Container(
                height: 300,
              ),
            ],
          ).padding(horizontal: 20, top: 30),
        ],
      );
    });
  }
}
