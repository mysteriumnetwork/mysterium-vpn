import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';

class LoadingBarrier extends StatelessWidget {
  const LoadingBarrier({required this.color, super.key});

  final Color color;
  @override
  Widget build(BuildContext context) => Stack(
        children: <Widget>[
          Opacity(
            opacity: 0.9,
            child: ModalBarrier(dismissible: false, color: color),
          ),
          const Center(
            child: LoadingIndicator(
              radius: 30,
              strokeWidth: 3,
              message: 'Authenticating',
              messageColor: Palette.pink,
            ),
          ),
        ],
      );
}
