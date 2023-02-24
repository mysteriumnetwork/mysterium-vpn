import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/circle_box.dart';
import 'package:mysterium_vpn/components/svg_icon_button.dart';

class ConnectButton extends StatelessWidget {
  const ConnectButton({
    required this.isConnected,
    required this.callback,
    required this.height,
    required this.width,
    super.key,
  });

  final bool isConnected;
  final VoidCallback callback;
  final double width;
  final double height;
  @override
  Widget build(BuildContext context) {
    final radius = ((height + width) / 2) * 0.23;
    return CircleBox(
      size: radius,
      color: isConnected ? Palette.purple : Palette.lightBlack,
      child: SvgIconButton(
        onPressed: callback,
        asset: Assets.connectButton,
      ),
    );
  }
}
