import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/views/home/desktop_left_panel.dart';
import 'package:mysterium_vpn/views/home/desktop_right_panel.dart';

class HomeDesktopView extends HookConsumerWidget {
  const HomeDesktopView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Row(
      children: const [
        Flexible(
          flex: 6,
          child: HomeDesktopLeftPanel(),
        ),
        Flexible(
          flex: 5,
          child: HomeDesktopRightPanel(),
        ),
      ],
    );
  }
}
