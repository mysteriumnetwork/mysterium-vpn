import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/extensions/asset.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/locations/views/components/locations_search.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn/shared/components/svg_icon_button.dart';

class HomeAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeAppBar({required this.supportIcon, required this.settingsIcon, super.key});

  final SvgGenImage supportIcon;
  final SvgGenImage settingsIcon;

  @override
  Widget build(BuildContext context) {
    final analyticsStore = getIt<AnalyticsStore>();

    return SafeArea(
      bottom: false,
      minimum: const EdgeInsets.only(top: 12),
      child: Padding(
        padding: const EdgeInsets.only(left: 32, right: 32, bottom: 16),
        child: Column(
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              spacing: 4,
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
