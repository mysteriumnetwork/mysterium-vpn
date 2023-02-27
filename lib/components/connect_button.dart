import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/components/svg_icon_button.dart';

// TODO(kristijan): Add correct svg asset for the connect button
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
  Widget build(BuildContext context) => SvgIconButton(
        onPressed: callback,
        asset: Assets.connectButton,
      );
}
