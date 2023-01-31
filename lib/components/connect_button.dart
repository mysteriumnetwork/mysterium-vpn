import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/svg_icon_button.dart';

class ConnectButton extends StatelessWidget {
  const ConnectButton({required this.isConnected, required this.callback, super.key});

  final bool isConnected;
  final VoidCallback callback;
  @override
  Widget build(BuildContext context) {
    final radius = ((getMediaHeight(context) + getMediaWidth(context)) / 2) * 0.13;
    return Container(
      height: radius,
      width: radius,
      decoration: BoxDecoration(
        color: isConnected ? Palette.purple : Palette.lightBlack,
        shape: BoxShape.circle,
      ),
      child: SvgIconButton(
        onPressed: callback,
        asset: Assets.connectButton,
      ),
    );
  }
}
