import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:lottie/lottie.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/hooks/responsive_value_hook.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/components/connect_button.dart';

class ConnectButtonAnimated extends HookWidget {
  const ConnectButtonAnimated({
    required this.onPressed,
    this.locationCode,
    super.key,
  });

  final VoidCallback onPressed;
  final String? locationCode;

  @override
  Widget build(BuildContext context) {
    final isConnected = useIsConnected();

    final maxWidth = useResponsiveValue<double>(
      250,
      tablet: 250,
      desktop: 350,
    );

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: maxWidth,
        maxHeight: maxWidth,
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Lottie.asset(
            isConnected ? Assets.circlesPurple : Assets.circlesGrey,
            alignment: Alignment.center,
          ),
          ConnectButton(onPressed: onPressed),
        ],
      ),
    );
  }
}
