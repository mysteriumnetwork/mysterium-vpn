import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/features/home/views/desktop_left_panel.dart';
import 'package:mysterium_vpn/features/home/views/desktop_right_panel.dart';

class HomeDesktopView extends HookConsumerWidget {
  const HomeDesktopView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const sidebarWidth = 460.0;
    return const Stack(
      clipBehavior: Clip.none,
      fit: StackFit.passthrough,
      alignment: Alignment.topLeft,
      children: [
        Padding(
          padding: EdgeInsets.only(left: sidebarWidth),
          child: HomeDesktopRightPanel(),
        ),
        SizedBox(width: sidebarWidth, child: HomeDesktopLeftPanel()),
      ],
    );
  }
}
