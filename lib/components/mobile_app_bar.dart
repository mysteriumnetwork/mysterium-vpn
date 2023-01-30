import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/components/app_logo.dart';
import 'package:mysterium_vpn/components/svg_icon_button.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

class MobileAppBar extends HookConsumerWidget {
  const MobileAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeStore = ref.watch(themeStorePOD);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SvgIconButton(
         onPressed: (){},
          asset: Assets.report,
        ),
        const AppLogo(),
        SvgIconButton(
          onPressed: () {
            themeStore.switchTheme();
          },
          asset: Assets.settings,
        ),
      ],
    );
  }
}
