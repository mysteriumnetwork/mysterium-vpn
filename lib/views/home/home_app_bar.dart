import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/svg_icon_button.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/locations/components/locations_search.dart';

class HomeAppBar extends HookConsumerWidget implements PreferredSizeWidget {
  const HomeAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final brightness = Theme.of(context).brightness;
    final analyticsStore = ref.read(analyticsStorePOD);

    return SafeArea(
      bottom: false,
      minimum: const EdgeInsets.only(top: 12),
      child: Padding(
        padding: const EdgeInsets.only(left: 20, right: 20, bottom: 24),
        child: Column(
          spacing: 12,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              spacing: 4,
              children: [
                Expanded(
                  child: SvgPicture.asset(
                    switch (brightness) {
                      Brightness.dark => Assets.logoWhiteSvg,
                      Brightness.light => Assets.logoBlackSvg,
                    },
                    height: 24,
                    alignment: Alignment.centerLeft,
                  ),
                ),
                SvgIconButton(
                  onPressed: () => handleOnReportPage(
                    context: context,
                    intetcomStore: ref.read(intercomStorePOD),
                    analyticsStore: ref.read(analyticsStorePOD),
                  ),
                  asset: switch (brightness) {
                    Brightness.dark => Assets.supportDark,
                    Brightness.light => Assets.supportLight,
                  },
                ),
                SvgIconButton(
                  onPressed: () {
                    analyticsStore.logEvent(AnalyticsEvent.openSettings);
                    context.beamToNamed(Routes.settings.path);
                  },
                  asset: switch (brightness) {
                    Brightness.dark => Assets.settingsDark,
                    Brightness.light => Assets.settingsLight,
                  },
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
