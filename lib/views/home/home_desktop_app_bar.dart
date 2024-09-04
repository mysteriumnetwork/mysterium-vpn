import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/app_logo.dart';
import 'package:mysterium_vpn/components/svg_icon_button.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:styled_widget/styled_widget.dart';

class HomeDesktopAppBar extends ConsumerWidget {
  const HomeDesktopAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeStore = ref.read(themeStorePOD);
    final analyticsStore = ref.read(analyticsStorePOD);
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        const AppLogo(),
        Observer(
          builder: (context) => Row(
            children: [
              SvgIconButton(
                onPressed: () => handleOnReportPage(
                  context: context,
                  intetcomStore: ref.read(intercomStorePOD),
                  analyticsStore: analyticsStore,
                ),
                asset: themeStore.isDarkMode ? Assets.reportPurple : Assets.report,
              ),
              SvgIconButton(
                onPressed: () {
                  analyticsStore.logEvent(AnalyticsEvent.openSettings);
                  context.beamToNamed(Routes.settings.toRoute);
                },
                asset: themeStore.isDarkMode ? Assets.settingsLightBlack : Assets.settings,
              ),
            ],
          ),
        ),
      ],
    ).padding(vertical: 20);
  }
}
