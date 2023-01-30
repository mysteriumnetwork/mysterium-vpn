import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';

class ConnectionIndicator extends StatelessWidget {
  const ConnectionIndicator({required this.connectionStatus, Key? key}) : super(key: key);

  final ConnectionStatus connectionStatus;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 4,
      width: 4,
      decoration: BoxDecoration(
        color: connectionStatus == ConnectionStatus.connected ? Palette.green : Palette.pink,
        shape: BoxShape.circle,
      ),
    );
  }
}
