import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/features/home/views/home_connection_view.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class HomeDesktopRightPanel extends StatelessWidget {
  const HomeDesktopRightPanel({super.key});

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (context, constraints) => DecoratedBox(
      decoration: BoxDecoration(color: Theme.of(context).palette.bgPrimary),
      child: Stack(
        children: [
          const HomeConnectionView(),
          Positioned(
            bottom: 48,
            left: 24,
            right: 24,
            child: Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: constraints.maxWidth < 432 ? constraints.maxWidth : 432,
                ),
                child: const ConnectionTile(),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
