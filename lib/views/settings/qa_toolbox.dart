import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/asset.dart';
import 'package:mysterium_vpn/common/hooks/screen_type_hook.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/analytics_logger_overlay.dart';
import 'package:mysterium_vpn/components/analytics_user_properties_overlay.dart';
import 'package:mysterium_vpn/components/dialogs/device_limit_dialog.dart';
import 'package:mysterium_vpn/components/dialogs/marketing_consent_dialog.dart';
import 'package:mysterium_vpn/components/dialogs/retry_dialog.dart';
import 'package:mysterium_vpn/components/dialogs/subscription_upgrade_success_dialog.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/setting_item.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/pages/subscription_upgrade_modal_page.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/settings/network_statistics.dart';

class QAToolbox extends HookConsumerWidget {
  const QAToolbox({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bannerStore = ref.read(bannersStorePOD);
    final locationsStore = ref.read(locationsStorePOD);
    final recentLocationsStore = ref.read(recentLocationsStorePOD);
    final vpnStore = ref.read(vpnStorePOD);
    final sessionStore = ref.read(authSessionStorePOD);
    final screenType = useScreenType();
    final subscriptionUpgradeStore = ref.read(subscriptionUpgradeStorePOD);
    final connectionsLimitStore = ref.read(connectionsLimitStorePOD);
    return Observer(
      builder: (context) => Column(
        children: [
          if (vpnStore.isConnected && Platform.isAndroid) const NetworkStatistics(),
          SettingItem(
            asset: Asset.icons.resetAppSetting(context),
            title: 'Reset hidden banners',
            subtitle: const EasyText(
              'This will reset all hidden banners to be shown again',
            ),
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
            asset: Asset.icons.resetAppSetting(context),
            title: 'Reset recent locations',
            subtitle: const EasyText('This will remove all recent locations'),
            actionWidget: TextButton.icon(
              label: const EasyText('Reset'),
              icon: const Icon(Icons.refresh),
              onPressed: () async {
                await recentLocationsStore.clear();
                showSnackbar('Recent locations reset successfully');
              },
            ),
          ),
          SettingItem(
            asset: Asset.icons.settingsAdaptive(context),
            title: 'VPN Connection limit',
            subtitle: EasyText(
              'Exceeded: ${connectionsLimitStore.connectionLimitReached}',
            ),
            actionWidget: TextButton.icon(
              label: EasyText(
                connectionsLimitStore.connectionLimitReached ? 'Mark not reached' : 'Mark reached',
              ),
              icon: const Icon(Icons.refresh),
              onPressed: () async {
                connectionsLimitStore.connectionLimitReached =
                    !connectionsLimitStore.connectionLimitReached;
                showSnackbar(
                  'Connection limit reached: ${connectionsLimitStore.connectionLimitReached}',
                );
              },
            ),
          ),
          SettingItem(
            asset: Asset.icons.settingsAdaptive(context),
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
            asset: Asset.icons.settingsAdaptive(context),
            title: 'Clear cached locations',
            subtitle: const EasyText('Will delete all VPNLocations from db'),
            actionWidget: TextButton.icon(
              label: const EasyText(
                'Clear',
              ),
              icon: const Icon(Icons.refresh),
              onPressed: () async {
                await locationsStore.clear();
                showSnackbar(
                  'Locations cleared',
                );
              },
            ),
          ),
          SettingItem(
            asset: Asset.icons.settingsAdaptive(context),
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
            asset: Asset.icons.settingsAdaptive(context),
            title: 'Check analytics logs',
            subtitle: const EasyText('Will list and observe all analytics logs'),
            actionWidget: TextButton.icon(
              label: const EasyText('Check'),
              icon: const Icon(Icons.open_in_new),
              onPressed: () => AnalyticsLoggerOverlay.show(context),
            ),
          ),
          SettingItem(
            asset: Asset.icons.settingsAdaptive(context),
            title: 'Check analytics user properties',
            subtitle: const EasyText(
              'Will list and observe all analytics user properties',
            ),
            actionWidget: TextButton.icon(
              label: const EasyText('Check'),
              icon: const Icon(Icons.open_in_new),
              onPressed: () => AnalyticsUserPropertiesOverlay.show(context),
            ),
          ),
          SettingItem(
            asset: Asset.icons.settingsAdaptive(context),
            title: 'Insert invalid locations',
            subtitle: const EasyText(
              'Will add invalid location to a list of locations for testing connection to unavailable locations',
            ),
            actionWidget: TextButton.icon(
              label: const EasyText('Insert'),
              icon: const Icon(Icons.open_in_new),
              onPressed: locationsStore.insertInvalidLocations,
            ),
          ),
          SettingItem(
            asset: Asset.icons.settingsAdaptive(context),
            title: 'Show marketing consent popup',
            subtitle: const EasyText('Will show the marketing consent dialog'),
            actionWidget: TextButton.icon(
              label: const EasyText('Show'),
              icon: const Icon(Icons.open_in_new),
              onPressed: () => showMarketingConsentDialog(
                context,
                desktopSize: screenType == ScreenType.desktop,
              ),
            ),
          ),
          SettingItem(
            asset: Asset.icons.settingsAdaptive(context),
            title: 'Show retry verification dialog',
            subtitle: const EasyText(
              'Will show the retry verification for subscription',
            ),
            actionWidget: TextButton.icon(
              label: const EasyText('Show'),
              icon: const Icon(Icons.open_in_new),
              onPressed: () => showRetryDialog(
                context: context,
                asset: Asset.icons.subscription,
                title: LocaleKeys.subscriptionVerificationFailed.tr(),
                subtitle: LocaleKeys.failedToVerifySubs.tr(),
                dismissText: LocaleKeys.cancelBtn.tr(),
                onDismiss: () => Navigator.of(context).pop(),
                onRetry: () => Navigator.of(context).pop(),
              ),
            ),
          ),
          SettingItem(
            asset: Asset.icons.settingsAdaptive(context),
            title: 'Invalidate access token',
            subtitle: const EasyText('For testing if token refreshes correctly'),
            actionWidget: TextButton.icon(
              label: const EasyText('Show'),
              icon: const Icon(Icons.open_in_new),
              onPressed: () async {
                await sessionStore.invalidateAccessToken();
                showSnackbar('Access token invalidated');
              },
            ),
          ),
          SettingItem(
            asset: Asset.icons.settingsAdaptive(context),
            title: 'Show upgrade success page',
            subtitle: const EasyText(
              'Just to test the design of upgrade success page.',
            ),
            actionWidget: TextButton.icon(
              label: const EasyText('Show'),
              icon: const Icon(Icons.open_in_new),
              onPressed: () async {
                final product = subscriptionUpgradeStore.upgradeProduct;
                if (product != null) {
                  await showSubscriptionUpgradeSuccessDialog(
                    context,
                    purchasedPlan: product,
                  );
                }
              },
            ),
          ),
          SettingItem(
            asset: Asset.icons.settingsAdaptive(context),
            title: 'Mock limited time offer',
            subtitle: const EasyText(
              'Creates fake limited time offer so dialog can pop up when pressing "subscribe"',
            ),
            actionWidget: TextButton.icon(
              label: const EasyText('Show'),
              icon: const Icon(Icons.open_in_new),
              onPressed: () async {
                final store = ref.read(subscriptionLimitedTimeOfferStorePOD);
                await store.mockOffer();
              },
            ),
          ),
          SettingItem(
            asset: Asset.icons.settingsAdaptive(context),
            title: 'Show device limit reached dialog',
            subtitle: const EasyText(
              'Just for testing dialog UI without actually having 6 devices.',
            ),
            actionWidget: TextButton.icon(
              label: const EasyText('Show'),
              icon: const Icon(Icons.open_in_new),
              onPressed: () async {
                await showDeviceLimitDialog(context);
              },
            ),
          ),
          Visibility(
            visible: Platform.isWindows,
            child: SettingItem(
              asset: Asset.icons.settingsAdaptive(context),
              title: 'Show OpenVPN logs',
              actionWidget: TextButton.icon(
                label: const EasyText(
                  'Show logs',
                ),
                icon: const Icon(Icons.read_more),
                onPressed: () async {
                  try {
                    final localAppData = Platform.environment['LOCALAPPDATA'];
                    if (localAppData == null) {
                      showSnackbar(
                        'LOCALAPPDATA environment variable not found',
                      );
                      return;
                    }

                    // Try multiple possible log locations
                    final possiblePaths = [
                      '$localAppData\\OpenVPNDart\\config\\openvpn.log',
                      '$localAppData\\OpenVPNDart\\openvpn.log',
                      '$localAppData\\Temp\\openvpn.log',
                      r'C:\ProgramData\OpenVPNDart\config\openvpn.log',
                      r'C:\Program Files\OpenVPN\log\openvpn.log',
                    ];

                    File? foundLogFile;
                    String? foundPath;

                    debugPrint('===== Searching for OpenVPN log files =====');
                    for (final path in possiblePaths) {
                      final file = File(path);
                      debugPrint(
                        'Checking: $path - ${file.existsSync() ? "FOUND" : "not found"}',
                      );
                      if (file.existsSync()) {
                        foundLogFile = file;
                        foundPath = path;
                        break;
                      }
                    }

                    // Also check if config directory exists
                    final configDir = Directory('$localAppData\\OpenVPNDart\\config');
                    debugPrint(
                      'Config directory exists: ${configDir.existsSync()} at ${configDir.path}',
                    );
                    if (configDir.existsSync()) {
                      debugPrint('Config directory contents:');
                      final files = configDir.listSync();
                      for (final file in files) {
                        debugPrint('  - ${file.path}');
                      }
                    }

                    if (foundLogFile != null && foundPath != null) {
                      // Read only last 300 lines to avoid memory issues with large log files
                      final allLines = await foundLogFile.readAsLines();
                      final lastLines = allLines.length > 300
                          ? allLines.sublist(allLines.length - 300)
                          : allLines;
                      final logs = lastLines.join('\n');

                      debugPrint(
                        '===== OpenVPN Logs (last ${lastLines.length} lines from $foundPath) =====\n$logs\n===== End Logs =====',
                      );

                      final logPreview =
                          logs.length > 200 ? '...${logs.substring(logs.length - 200)}' : logs;

                      showSnackbar(
                        'Log preview (from ${foundPath.split(r'\').last}):\n$logPreview',
                        action: SnackBarAction(
                          textColor: Palette.black,
                          label: LocaleKeys.copyBtn.tr(),
                          onPressed: () => FlutterClipboard.copy(logs).then(
                            (value) => showSnackbar(
                              LocaleKeys.linkCopied.tr(),
                              type: MessageType.success,
                            ),
                          ),
                        ),
                      );
                    } else {
                      final pathsList = possiblePaths.map((p) => '  • $p').join('\n');
                      showSnackbar(
                        'Log file not found. Checked:\n$pathsList\n\nCheck debug console for details.',
                      );
                    }
                  } catch (e, stackTrace) {
                    debugPrint('Show Logs Error: $e\nStack trace: $stackTrace');
                    showSnackbar(
                      'Error reading log file: $e',
                    );
                  }
                },
              ),
            ),
          ),
          SettingItem(
            asset: Asset.icons.settingsAdaptive(context),
            title: 'Show subscription upgrade modal page',
            actionWidget: Theme(
              data: Theme.of(context).designSystem,
              child: Builder(
                builder: (context) => TextButton.icon(
                  label: const EasyText('Show'),
                  icon: const Icon(Icons.open_in_new),
                  onPressed: () async {
                    await showSubscriptionUpgradeModalPage(context);
                  },
                ),
              ),
            ),
          ),
          const SizedBox(height: 36),
        ],
      ),
    );
  }
}
