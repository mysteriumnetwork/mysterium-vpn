import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/analytics_logger_overlay.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/setting_item.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/settings/network_statistics.dart';

class QAToolbox extends HookConsumerWidget {
  const QAToolbox({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final themeStore = ref.read(themeStorePOD);
    final bannerStore = ref.read(bannersStorePOD);
    final locationsStore = ref.read(locationsStorePOD);
    final vpnStore = ref.read(vpnStorePOD);
    return Observer(
      builder: (context) {
        final isDarkTheme = themeStore.isDarkMode;

        return Column(
          children: [
            if (vpnStore.isConnected && Platform.isAndroid) const NetworkStatistics(),
            SettingItem(
              asset: isDarkTheme ? Assets.resetAppSettingDark : Assets.resetAppSettingLight,
              title: 'Reset hidden banners',
              subtitle: const EasyText('This will reset all hidden banners to be shown again'),
              actionWidget: TextButton.icon(
                label: const EasyText('Reset'),
                icon: const Icon(Icons.refresh),
                onPressed: () async {
                  await bannerStore.resetShown();
                  showSnackbar(
                    'Banners reset successfully',
                  );
                },
              ),
            ),
            SettingItem(
              asset: isDarkTheme ? Assets.resetAppSettingDark : Assets.resetAppSettingLight,
              title: 'Reset recent locations',
              subtitle: const EasyText('This will remove all recent locations'),
              actionWidget: TextButton.icon(
                label: const EasyText('Reset'),
                icon: const Icon(Icons.refresh),
                onPressed: () async {
                  await locationsStore.resetRecentLocations();
                  showSnackbar(
                    'Recent locations reset successfully',
                  );
                },
              ),
            ),
            SettingItem(
              asset: isDarkTheme ? Assets.settingsDark : Assets.settingsLight,
              title: 'VPN Connection limit',
              subtitle: EasyText('Exceeded: ${vpnStore.connectionLimitReached}'),
              actionWidget: TextButton.icon(
                label: EasyText(
                  vpnStore.connectionLimitReached ? 'Mark not reached' : 'Mark reached',
                ),
                icon: const Icon(Icons.refresh),
                onPressed: () async {
                  vpnStore.connectionLimitReached = !vpnStore.connectionLimitReached;
                  showSnackbar(
                    'Connection limit reached: ${vpnStore.connectionLimitReached}',
                  );
                },
              ),
            ),
            SettingItem(
              asset: isDarkTheme ? Assets.settingsDark : Assets.settingsLight,
              title: 'Mock subscription failure status',
              subtitle: const EasyText('Will set subscription status to failed'),
              actionWidget: TextButton.icon(
                label: const EasyText(
                  'Mark subscription failed',
                ),
                icon: const Icon(Icons.refresh),
                onPressed: () async {
                  ref.read(subscriptionStorePOD).mockSubscriptionFailureStatus();
                  showSnackbar(
                    'Subscription status set to failed',
                  );
                },
              ),
            ),
            SettingItem(
              asset: isDarkTheme ? Assets.settingsDark : Assets.settingsLight,
              title: 'Clear cached locations',
              subtitle: const EasyText('Will delete all VPNLocations from db'),
              actionWidget: TextButton.icon(
                label: const EasyText(
                  'Clear',
                ),
                icon: const Icon(Icons.refresh),
                onPressed: () async {
                  await ref.read(locationsStorePOD).resetStoredLocations();
                  showSnackbar(
                    'Locations cleared',
                  );
                },
              ),
            ),
            SettingItem(
              asset: isDarkTheme ? Assets.settingsDark : Assets.settingsLight,
              title: 'Check tunnel status',
              subtitle: const EasyText('Will query the current tunnel status'),
              actionWidget: TextButton.icon(
                label: const EasyText(
                  'Check',
                ),
                icon: const Icon(Icons.refresh),
                onPressed: () async {
                  final status = await ref.read(vpnStorePOD).checkTunnelStatus();
                  showSnackbar(
                    'Tunnel status: $status',
                  );
                },
              ),
            ),
            SettingItem(
              asset: isDarkTheme ? Assets.settingsDark : Assets.settingsLight,
              title: locationsStore.clearFetchedLocations ? 'Restore locations' : 'Clear locations',
              actionWidget: TextButton.icon(
                label: EasyText(locationsStore.clearFetchedLocations ? 'Restore' : 'Clear'),
                icon: Icon(locationsStore.clearFetchedLocations ? Icons.restore : Icons.clear),
                onPressed: () async {
                  locationsStore.clearFetchedLocations = !locationsStore.clearFetchedLocations;
                  await locationsStore.refreshAll();
                },
              ),
            ),
            SettingItem(
              asset: isDarkTheme ? Assets.settingsDark : Assets.settingsLight,
              title: 'Check analytics logs',
              subtitle: const EasyText('Will list and observe all analytics logs'),
              actionWidget: TextButton.icon(
                label: const EasyText('Check'),
                icon: const Icon(Icons.open_in_new),
                onPressed: () => AnalyticsLoggerOverlay.show(context),
              ),
            ),
            const SizedBox(height: 36),
          ],
        );
      },
    );
  }
}
