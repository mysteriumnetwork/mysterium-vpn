import 'package:flutter/material.dart';
import 'package:mysterium_vpn/features/home/views/desktop_left_panel.dart';
import 'package:mysterium_vpn/features/home/views/desktop_right_panel.dart';

class HomeDesktopView extends StatelessWidget {
  const HomeDesktopView({super.key});

  @override
  Widget build(BuildContext context) {
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
