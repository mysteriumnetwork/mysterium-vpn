import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/app_logo.dart';
import 'package:mysterium_vpn/components/kill_switch_tooltip.dart';
import 'package:mysterium_vpn/components/svg_icon_button.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:styled_widget/styled_widget.dart';

class HomeMobileAppBar extends ConsumerWidget {
  const HomeMobileAppBar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsStore = ref.read(analyticsStorePOD);
    return LayoutBuilder(
      builder: (context, constraints) => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgIconButton(
            onPressed: () => handleOnReportPage(
              context: context,
              intetcomStore: ref.read(intercomStorePOD),
              analyticsStore: ref.read(analyticsStorePOD),
            ),
            asset: Assets.report,
          ),
          KillSwitchTooltip(
            constraints: constraints.widthConstraints().copyWith(
                  maxWidth: constraints.maxWidth * .7,
                ),
          ),
          const Expanded(child: AppLogo()),
          SvgIconButton(
            onPressed: () {
              analyticsStore.logEvent(AnalyticsEvent.openSettings);
              context.beamToNamed(Routes.settings.path);
            },
            asset: Assets.settings,
          ),
        ],
      ).padding(horizontal: 20, top: 10),
    );
  }
}
