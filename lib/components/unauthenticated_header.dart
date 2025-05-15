import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/app_logo.dart';
import 'package:mysterium_vpn/components/svg_icon_button.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

class UnauthenticatedHeader extends HookConsumerWidget {
  const UnauthenticatedHeader({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authSessionStore = ref.read(authSessionStorePOD);
    final canBrowseApp = useComputedValue(() => authSessionStore.canBrowseApp);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      spacing: 24,
      children: [
        if (canBrowseApp) const _BackButton(),
        if (!canBrowseApp) const SizedBox.shrink(),
        const AppLogo(),
        SvgIconButton(
          asset: Assets.messageSvg,
          onPressed: () {
            handleOnSupportPage(
              context: context,
              intetcomStore: ref.read(intercomStorePOD),
              analyticsStore: ref.read(analyticsStorePOD),
            );
          },
        ),
      ],
    );
  }
}

class _BackButton extends HookConsumerWidget {
  const _BackButton();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeStore = ref.watch(themeStorePOD);
    final isDarkMode = useComputedValue(() => themeStore.isDarkMode);

    Future<void> handleBackOrHome() async {
      final beamer = Beamer.of(context);
      final success = await beamer.popRoute();
      if (!success) {
        beamer.beamToNamed(Routes.main.path);
      }
    }

    return SvgIconButton(
      asset: isDarkMode ? Assets.navigateBackLightGrey : Assets.navigateBackLightBlack,
      onPressed: handleBackOrHome,
    );
  }
}
