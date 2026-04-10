import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/extensions/asset.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/components/svg_icon_button.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/locations/components/locations_search.dart';

class HomeAppBar extends HookConsumerWidget implements PreferredSizeWidget {
  const HomeAppBar({required this.supportIcon, required this.settingsIcon, super.key});

  final SvgGenImage supportIcon;
  final SvgGenImage settingsIcon;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsStore = ref.read(analyticsStorePOD);

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
                    analyticsStore: ref.read(analyticsStorePOD),
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
