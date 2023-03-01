import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/svg_icon_button.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

class DesktopPageHeader extends ConsumerWidget {
  const DesktopPageHeader({
    required this.asset,
    required this.onPressed,
    this.showNavigationButton = true,
    super.key,
  });

  final String asset;
  final VoidCallback onPressed;
  final bool showNavigationButton;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeStore = ref.read(themeStorePOD);

    return Observer(
      builder: (context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              SvgIconButton(
                onPressed: () => context.beamBack(),
                asset: themeStore.isDarkMode ? Assets.navigateBackLightBlack : Assets.navigateBack,
              ),
              TextButton(
                onPressed: () => context.beamBack(),
                child: EasyText(
                  LocaleKeys.back.tr(),
                  fontSize: 14,
                ),
              )
            ],
          ),
          if (showNavigationButton)
            SvgIconButton(
              onPressed: onPressed,
              asset: asset,
            )
        ],
      ),
    );
  }
}
