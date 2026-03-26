import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/asset.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/components/api_version.dart';
import 'package:mysterium_vpn/components/app_version.dart';
import 'package:mysterium_vpn/components/header_title.dart';
import 'package:mysterium_vpn/components/svg_icon_button.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:styled_widget/styled_widget.dart';

class PageHeader extends HookConsumerWidget {
  const PageHeader({required this.headerTitle, super.key});

  final String headerTitle;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsStore = ref.read(analyticsStorePOD);
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
