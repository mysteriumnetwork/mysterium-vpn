import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/remote_config/store/remote_config_store.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class AppVersionUpdateSetting extends StatelessWidget {
  const AppVersionUpdateSetting({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final remoteConfigStore = getIt<RemoteConfigStore>();
    final analyticsStore = getIt<AnalyticsStore>();
    final isDesktop = ScreenType.of(context) >= ScreenType.tablet;

    return Observer(
      builder: (context) {
        if (!shouldShowAppUpdateBanner(remoteConfigStore)) {
          return const SizedBox.shrink();
        }

        return Padding(
          padding: isDesktop
              ? EdgeInsets.symmetric(horizontal: theme.spacing.xl3)
              : EdgeInsets.zero,
          child: SettingsCard(
            position: SettingsCardPosition.top,
            title: LocaleKeys.appUpdateAvailableSetting.tr(),
            trailing: ButtonSecondary(
              size: ButtonSize.small,
              decoration: const ButtonDecoration(
                minimumSize: Size.zero,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              ),
              onPressed: () {
                analyticsStore.logEvent(AnalyticsEvent.appVersionSettingClicked);
                openAppStorePage();
              },
              child: Text(LocaleKeys.updateBtn.tr()),
            ),
          ),
        );
      },
    );
  }

  bool shouldShowAppUpdateBanner(RemoteConfigStore remoteConfigStore) {
    final latestStableAppVersion = remoteConfigStore.latestStableAppVersion;
    final currentBuildVersion = Env.buildInfo.buildVersion;
    return currentBuildVersion.compareTo(latestStableAppVersion) < 0;
  }
}
