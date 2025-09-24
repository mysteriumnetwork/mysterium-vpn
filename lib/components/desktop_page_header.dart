import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/asset.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/svg_icon_button.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';

class DesktopPageHeader extends ConsumerWidget {
  const DesktopPageHeader({
    required this.asset,
    required this.onPressed,
    this.showNavigationButton = true,
    super.key,
  });

  final SvgGenImage asset;
  final VoidCallback onPressed;
  final bool showNavigationButton;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsStore = ref.read(analyticsStorePOD);

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            SvgIconButton(
              onPressed: () {
                onNavigationButtonPressed(context, analyticsStore);
              },
              asset: Asset.icons.navigateBackLighter(context),
            ),
            TextButton(
              onPressed: () {
                onNavigationButtonPressed(context, analyticsStore);
              },
              child: EasyText(
                LocaleKeys.back.tr(),
                fontSize: 14,
              ),
            ),
          ],
        ),
        if (showNavigationButton)
          SvgIconButton(
            onPressed: onPressed,
            asset: asset,
          ),
      ],
    );
  }

  void onNavigationButtonPressed(BuildContext context, AnalyticsStore analyticsStore) {
    analyticsStore.logEvent(AnalyticsEvent.backButtonClick);
    context.beamBack();
  }
}
