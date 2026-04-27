import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/extensions/asset.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/locations/views/components/locations_search.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({required this.supportIcon, required this.settingsIcon, super.key});

  final SvgGenImage supportIcon;
  final SvgGenImage settingsIcon;

  @override
  Widget build(BuildContext context) {
    final analyticsStore = getIt<AnalyticsStore>();

    final spacing = Theme.of(context).spacing;
    return SafeArea(
      bottom: false,
      minimum: EdgeInsets.only(top: spacing.ms),
      child: Padding(
        padding: EdgeInsets.only(left: spacing.xl3, right: spacing.xl3, bottom: spacing.md),
        child: Column(
          spacing: spacing.ms,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              spacing: spacing.xs,
              children: [
                Expanded(
                  child: Asset.logo.logo(context).svg(height: 24, alignment: Alignment.centerLeft),
                ),
                SvgIconButton(
                  onPressed: () => handleOnSupportPage(
                    context: context,
                    analyticsStore: getIt<AnalyticsStore>(),
                  ),
                  asset: supportIcon,
                ),
                SvgIconButton(
                  onPressed: () {
                    analyticsStore.logEvent(AnalyticsEvent.openSettings);
                    context.beamToNamed(Routes.settings.path);
                  },
                  asset: settingsIcon,
                ),
              ],
            ),
            const LocationsSearch(),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(86);
}
