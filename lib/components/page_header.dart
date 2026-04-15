import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/extensions/asset.dart';
import 'package:mysterium_vpn/core/styles/style.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:styled_widget/styled_widget.dart';

class PageHeader extends StatelessWidget {
  const PageHeader({required this.headerTitle, super.key});

  final String headerTitle;

  @override
  Widget build(BuildContext context) {
    final analyticsStore = getIt<AnalyticsStore>();
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SvgIconButton(
            onPressed: () {
              analyticsStore.logEvent(AnalyticsEvent.backButtonClick);
              context.beamBack();
            },
            asset: Asset.icons.navigateBackAdaptive(context),
          ),
          HeaderTitle(text: headerTitle, color: Palette.white),
          const Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [AppVersion(), ApiVersion()],
          ),
        ],
      ).padding(horizontal: 20),
    );
  }
}
