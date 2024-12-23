import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/views/home/home_connection_view.dart';

class HomeDesktopRightPanel extends HookConsumerWidget {
  const HomeDesktopRightPanel({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => const DecoratedBox(
        decoration: BoxDecoration(color: Palette.darkBlue),
        child: HomeConnectionView(),
      );
}
