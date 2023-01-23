// Flutter imports:
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/theme_store.dart';
import 'package:styled_widget/styled_widget.dart';
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
      return Directionality(
        textDirection: TextDirection.ltr,
        child: SvgPicture.asset(
          asset,
          matchTextDirection: true,
        ),
      ).center();
    });
  }
}
