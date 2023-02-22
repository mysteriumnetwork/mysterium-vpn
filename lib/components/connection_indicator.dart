import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';

class ConnectionIndicator extends StatelessWidget {
  const ConnectionIndicator({required this.isConnected, super.key});

  final bool isConnected;
  @override
  Widget build(BuildContext context) => Container(
        height: 4,
        width: 4,
        decoration: BoxDecoration(
          color: isConnected ? Palette.green : Palette.pink,
          shape: BoxShape.circle,
        ),
      );
}
