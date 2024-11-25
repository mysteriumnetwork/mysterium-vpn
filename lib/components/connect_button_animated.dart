import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lottie/lottie.dart';
import 'package:mysterium_vpn/common/hooks/handle_subscribe_hook.dart';
import 'package:mysterium_vpn/common/hooks/is_connected_hook.dart';
import 'package:mysterium_vpn/common/hooks/subscription_active_hook.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/components/connect_button.dart';
import 'package:mysterium_vpn/components/no_subscription_banner.dart';
import 'package:styled_widget/styled_widget.dart';

class ConnectButtonAnimated extends HookWidget {
  const ConnectButtonAnimated({
    required this.onPressed,
    this.locationCode,
    this.buttonSize = 24,
    super.key,
  });

  final VoidCallback onPressed;
  final String? locationCode;
  final double buttonSize;

  @override
  Widget build(BuildContext context) {
    final subscriptionActive = useSubscriptionActive();
    final handleSubscribe = useHandleSubscribe();
    final isConnected = useIsConnected();

    final banner =
        subscriptionActive ? null : NoSubscriptionBanner(onSubscribePressed: handleSubscribe);

    return Stack(
      fit: StackFit.expand,
      children: [
        Positioned.fill(
          bottom: (banner?.constraints.maxHeight ?? 0) * .3,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Lottie.asset(
                isConnected ? Assets.circlesPurple : Assets.circlesGrey,
                alignment: Alignment.center,
              ),
              ConnectButton(onPressed: onPressed).height(buttonSize),
            ],
          ),
        ),
        if (banner != null)
          Positioned(
            left: 21,
            right: 21,
            bottom: 0,
            child: Center(child: banner),
          ),
      ],
    );
  }
}
