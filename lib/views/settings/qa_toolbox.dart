import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/asset.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/analytics_logger_overlay.dart';
import 'package:mysterium_vpn/components/analytics_user_properties_overlay.dart';
import 'package:mysterium_vpn/components/dialogs/device_limit_dialog.dart';
import 'package:mysterium_vpn/components/dialogs/marketing_consent_dialog.dart';
import 'package:mysterium_vpn/components/dialogs/push_notifications_dialog.dart';
import 'package:mysterium_vpn/components/dialogs/retry_dialog.dart';
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
  Widget build(BuildContext context, WidgetRef ref) => Observer(
        builder: (context) => Column(
          children: [
            if (ref.read(vpnStorePOD).isConnected && Platform.isAndroid) const NetworkStatistics(),
            _ExpandableSection(
              title: 'Data Management',
              icon: Icons.storage,
              children: [
                _buildResetActions(context, ref),
                _buildClearLocationsAction(context, ref),
              ],
            ),
            _ExpandableSection(
              title: 'VPN & Connection',
              icon: Icons.vpn_lock,
              children: [
                _buildConnectionLimitAction(context, ref),
                _buildTunnelStatusAction(context, ref),
                _buildInvalidLocationsAction(context, ref),
                if (Platform.isWindows) _buildOpenVPNLogsAction(context),
              ],
            ),
            _ExpandableSection(
              title: 'Subscription & Auth',
              icon: Icons.card_membership,
              children: [
                _buildSubscriptionActions(context, ref),
                _buildAuthActions(context, ref),
              ],
            ),
            _ExpandableSection(
              title: 'Analytics & Debugging',
              icon: Icons.analytics,
              children: [
                _buildAnalyticsActions(context),
              ],
            ),
            _ExpandableSection(
              title: 'UI Testing',
              icon: Icons.visibility,
              children: [
                _buildDialogTestActions(context, ref),
              ],
            ),
            const SizedBox(height: 36),
          ],
        ),
      );

  Widget _buildResetActions(BuildContext context, WidgetRef ref) {
    final bannerStore = ref.read(bannersStorePOD);
    final recentLocationsStore = ref.read(recentLocationsStorePOD);

    return SettingItem(
      asset: Asset.icons.resetAppSetting(context),
      title: 'Reset cached data',
      subtitle: const EasyText('Reset banners and recent locations'),
      actionWidget: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextButton(
            onPressed: () async {
              await bannerStore.resetShown();
              showSnackbar('Banners reset successfully');
            },
            child: const EasyText('Banners'),
          ),
          const SizedBox(width: 8),
          TextButton(
            onPressed: () async {
              await recentLocationsStore.clear();
              showSnackbar('Recent locations reset successfully');
            },
            child: const EasyText('Locations'),
          ),
        ],
      ),
    );
  }

  Widget _buildClearLocationsAction(BuildContext context, WidgetRef ref) => SettingItem(
        asset: Asset.icons.settingsAdaptive(context),
        title: 'Clear cached locations',
        subtitle: const EasyText('Delete all VPN locations from database'),
        actionWidget: TextButton.icon(
          label: const EasyText('Clear'),
          icon: const Icon(Icons.delete_outline),
          onPressed: () async {
            await ref.read(locationsStorePOD).clear();
            showSnackbar('Locations cleared');
          },
        ),
      );

  Widget _buildConnectionLimitAction(BuildContext context, WidgetRef ref) {
    final connectionsLimitStore = ref.read(connectionsLimitStorePOD);

    return SettingItem(
      asset: Asset.icons.settingsAdaptive(context),
      title: 'VPN connection limit',
      subtitle: EasyText(
        'Status: ${connectionsLimitStore.connectionLimitReached ? "Reached" : "Not reached"}',
      ),
      actionWidget: TextButton.icon(
        label: const EasyText('Toggle'),
        icon: const Icon(Icons.swap_horiz),
        onPressed: () {
          connectionsLimitStore.connectionLimitReached =
              !connectionsLimitStore.connectionLimitReached;
          showSnackbar(
            'Connection limit: ${connectionsLimitStore.connectionLimitReached ? "reached" : "not reached"}',
          );
        },
      ),
    );
  }

  Widget _buildTunnelStatusAction(BuildContext context, WidgetRef ref) => SettingItem(
        asset: Asset.icons.settingsAdaptive(context),
        title: 'Check tunnel status',
        subtitle: const EasyText('Query current tunnel connection status'),
        actionWidget: TextButton.icon(
          label: const EasyText('Check'),
          icon: const Icon(Icons.network_check),
          onPressed: () async {
            final status = await ref.read(vpnStorePOD).checkTunnelStatus();
            showSnackbar('Tunnel status: $status');
          },
        ),
      );

  Widget _buildInvalidLocationsAction(BuildContext context, WidgetRef ref) => SettingItem(
        asset: Asset.icons.settingsAdaptive(context),
        title: 'Insert invalid locations',
        subtitle: const EasyText('Add test locations for testing unavailable connections'),
        actionWidget: TextButton.icon(
          label: const EasyText('Insert'),
          icon: const Icon(Icons.add_location_alt_outlined),
          onPressed: ref.read(locationsStorePOD).insertInvalidLocations,
        ),
      );

  Widget _buildSubscriptionActions(BuildContext context, WidgetRef ref) => SettingItem(
        asset: Asset.icons.settingsAdaptive(context),
        title: 'Subscription testing',
        subtitle: const EasyText('Mock subscription states and offers'),
        actionWidget: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () async {
                ref.read(subscriptionStorePOD).mockSubscriptionFailureStatus();
                showSnackbar('Subscription set to failed');
              },
              child: const EasyText('Fail'),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () async {
                await ref.read(subscriptionLimitedTimeOfferStorePOD).mockOffer();
                showSnackbar('Limited time offer created');
              },
              child: const EasyText('Mock Offer'),
            ),
          ],
        ),
      );

  Widget _buildAuthActions(BuildContext context, WidgetRef ref) => SettingItem(
        asset: Asset.icons.settingsAdaptive(context),
        title: 'Invalidate access token',
        subtitle: const EasyText('Test token refresh mechanism'),
        actionWidget: TextButton.icon(
          label: const EasyText('Invalidate'),
          icon: const Icon(Icons.key_off),
          onPressed: () async {
            await ref.read(authSessionStorePOD).invalidateAccessToken();
            showSnackbar('Access token invalidated');
          },
        ),
      );

  Widget _buildAnalyticsActions(BuildContext context) => SettingItem(
        asset: Asset.icons.settingsAdaptive(context),
        title: 'Analytics inspection',
        subtitle: const EasyText('View logs and user properties'),
        actionWidget: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () => AnalyticsLoggerOverlay.show(context),
              child: const EasyText('Logs'),
            ),
            const SizedBox(width: 8),
            TextButton(
              onPressed: () => AnalyticsUserPropertiesOverlay.show(context),
              child: const EasyText('Properties'),
            ),
          ],
        ),
      );

  Widget _buildDialogTestActions(BuildContext context, WidgetRef ref) => Column(
        children: [
          SettingItem(
            asset: Asset.icons.settingsAdaptive(context),
            title: 'Test dialogs',
            subtitle: const EasyText('Show various app dialogs for testing'),
            actionWidget: Wrap(
              spacing: 8,
              runSpacing: 4,
              children: [
                _buildDialogButton(
                  'Marketing Consent',
                  () => showMarketingConsentDialog(context),
                ),
                _buildDialogButton(
                  'Retry Subscription Verification',
                  () => showRetryDialog(
                    context: context,
                    asset: Asset.icons.subscription,
                    title: LocaleKeys.subscriptionVerificationFailed.tr(),
                    subtitle: LocaleKeys.failedToVerifySubs.tr(),
                    dismissText: LocaleKeys.cancelBtn.tr(),
                    onDismiss: () => Navigator.of(context).pop(),
                    onRetry: () => Navigator.of(context).pop(),
                  ),
                ),
                _buildDialogButton(
                  'Device Limit',
                  () => showDeviceLimitDialog(context),
                ),
                _buildDialogButton(
                  'Push Notifications',
                  () => showPushNotificationsPermissionDialog(context),
                ),
                _buildDialogButton(
                  'Subscription Upgrade',
                  () => showSubscriptionUpgradeModalPage(context),
                ),
              ],
            ),
          ),
        ],
      );

  Widget _buildDialogButton(String label, VoidCallback onPressed) => TextButton(
        onPressed: onPressed,
        style: TextButton.styleFrom(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          minimumSize: Size.zero,
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
        child: EasyText(
          label,
          textDecoration: TextDecoration.underline,
        ),
      );

  Widget _buildOpenVPNLogsAction(BuildContext context) => SettingItem(
        asset: Asset.icons.settingsAdaptive(context),
        title: 'Show OpenVPN logs',
        subtitle: const EasyText('View recent OpenVPN connection logs'),
        actionWidget: TextButton.icon(
          label: const EasyText('Show logs'),
          icon: const Icon(Icons.description_outlined),
          onPressed: () => _showOpenVPNLogs(context),
        ),
      );

  Future<void> _showOpenVPNLogs(BuildContext context) async {
    try {
      final localAppData = Platform.environment['LOCALAPPDATA'];
      if (localAppData == null) {
        showSnackbar('LOCALAPPDATA environment variable not found');
        return;
      }

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
        final allLines = await foundLogFile.readAsLines();
        final lastLines =
            allLines.length > 300 ? allLines.sublist(allLines.length - 300) : allLines;
        final logs = lastLines.join('\n');

        debugPrint(
          '===== OpenVPN Logs (last ${lastLines.length} lines from $foundPath) =====\n$logs\n===== End Logs =====',
        );

        final logPreview = logs.length > 200 ? '...${logs.substring(logs.length - 200)}' : logs;

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
      showSnackbar('Error reading log file: $e');
    }
  }
}

class _ExpandableSection extends HookWidget {
  const _ExpandableSection({
    required this.title,
    required this.icon,
    required this.children,
  });
  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final isExpanded = useState(false);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        InkWell(
          onTap: () => isExpanded.value = !isExpanded.value,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: Colors.grey[600],
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                AnimatedRotation(
                  turns: isExpanded.value ? 0.5 : 0,
                  duration: const Duration(milliseconds: 200),
                  child: Icon(
                    Icons.keyboard_arrow_down,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ),
        AnimatedCrossFade(
          firstChild: const SizedBox.shrink(),
          secondChild: Column(
            children: children,
          ),
          crossFadeState: isExpanded.value ? CrossFadeState.showSecond : CrossFadeState.showFirst,
          duration: const Duration(milliseconds: 200),
        ),
        Divider(
          height: 1,
          thickness: 1,
          color: Colors.grey[300],
        ),
      ],
    );
  }
}
