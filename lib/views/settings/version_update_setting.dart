import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/analytics_event.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart' hide LoadingIndicator;

class AppVersionUpdateSetting extends HookConsumerWidget {
  const AppVersionUpdateSetting({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final remoteConfigStore = ref.watch(remoteConfigStorePOD);
    final analyticsStore = ref.watch(analyticsStorePOD);
    final screenType = ScreenType.of(context);

    final isDesktop = screenType >= ScreenType.tablet;

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
            title: S.current.appUpdateAvailableSetting,
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
              child: Text(S.current.updateBtn),
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
