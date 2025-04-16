import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/configurations/breakpoint_configuration.dart';
import 'package:mysterium_vpn/common/hooks/responsive_value_hook.dart';
import 'package:mysterium_vpn/views/home/desktop_left_panel.dart';
import 'package:mysterium_vpn/views/home/desktop_right_panel.dart';

class HomeDesktopView extends HookConsumerWidget {
  const HomeDesktopView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => const Stack(
        clipBehavior: Clip.none,
        fit: StackFit.passthrough,
        alignment: Alignment.topLeft,
        children: [
          Padding(
            padding: EdgeInsets.only(left: 500),
            child: HomeDesktopRightPanel(),
          ),
          SizedBox(
            width: 500,
            child: HomeDesktopLeftPanel(),
          ),
        ],
      );
}
