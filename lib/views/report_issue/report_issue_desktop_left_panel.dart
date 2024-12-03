import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/routes.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/components/app_version.dart';
import 'package:mysterium_vpn/components/desktop_page_header.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/services/auth/auth_status.dart';
import 'package:styled_widget/styled_widget.dart';

class ReportIssueDesktopLeftPanel extends ConsumerWidget {
  const ReportIssueDesktopLeftPanel({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeStore = ref.read(themeStorePOD);
    final authSessionStore = ref.watch(authSessionStorePOD);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        DesktopPageHeader(
          showNavigationButton: authSessionStore.status == AuthStatus.authenticated,
          onPressed: () {
            context.beamToReplacementNamed(Routes.settings.toRoute);
          },
          asset: themeStore.isDarkMode ? Assets.settingsLightBlack : Assets.settings,
        ),
        SvgIcon(
          asset: themeStore.isDarkMode ? Assets.reportDark : Assets.reportLight,
        ).expanded(),
        const SizedBox(width: 160, child: SvgIcon(asset: Assets.logoGrey)),
        AppVersion(
          headerText: LocaleKeys.appVersion.tr(),
        ),
      ],
    ).padding(horizontal: 40, vertical: 40);
  }
}
