import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/components/connection_tile.dart';
import 'package:mysterium_vpn/views/home/home_connection_view.dart';

class HomeDesktopRightPanel extends HookConsumerWidget {
  const HomeDesktopRightPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => LayoutBuilder(
    builder: (context, constraints) => DecoratedBox(
      decoration: const BoxDecoration(color: Palette.darkBlue),
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
