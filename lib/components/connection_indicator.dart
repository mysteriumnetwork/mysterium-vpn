import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/core/styles/style.dart';

class ConnectionIndicator extends StatelessWidget {
  const ConnectionIndicator({required this.isConnected, super.key});

  final bool isConnected;
  @override
  Widget build(BuildContext context) =>
      CircleBox(size: 4, color: isConnected ? Palette.green : Palette.pink);
}
