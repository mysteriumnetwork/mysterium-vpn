// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
// Project imports:

class AppLogo extends HookConsumerWidget {
  const AppLogo({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeStore = ref.watch(themeStorePOD);

    return Observer(builder: (context) {
      final asset = themeStore.themeType == ThemeType.dark || checkMediaWidth(context, 650)
          ? Assets.logoWhiteSvg
          : Assets.logoBlackSvg;
      return SvgIcon(
        asset: asset,
      );
    });
  }
}
