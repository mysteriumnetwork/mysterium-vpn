import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/svg_icon_button.dart';

class ConnectButton extends StatelessWidget {
  const ConnectButton({required this.connectionStatus, required this.callback, super.key});

  final ConnectionStatus connectionStatus;
  final VoidCallback callback;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      width: 70,
      decoration: BoxDecoration(
        color: connectionStatus == ConnectionStatus.disconnected ? Palette.lightBlack : Palette.purple,
        shape: BoxShape.circle,
      ),
      child: SvgIconButton(
        onPressed: callback,
        asset: Assets.connectButton,
      ),
    );
  }
}
