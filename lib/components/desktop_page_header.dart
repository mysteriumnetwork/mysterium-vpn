import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/components/svg_icon_button.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';

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
    final analyticsStore = ref.read(analyticsStorePOD);

    return Observer(
      builder: (context) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgIconButton(
            onPressed: () {
              onNavigationButtonPressed(context, analyticsStore);
            },
            asset: themeStore.isDarkMode
                ? Assets.navigateBackLightGrey
                : Assets.navigateBackLightBlack,
          ),
          if (showNavigationButton)
            SvgIconButton(
              onPressed: onPressed,
              asset: asset,
            ),
        ],
      ),
    );
  }

  void onNavigationButtonPressed(BuildContext context, AnalyticsStore analyticsStore) {
    analyticsStore.logEvent(AnalyticsEvent.backButtonClick);
    context.beamBack();
  }
}
