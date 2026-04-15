import 'dart:io';

import 'package:clipboard/clipboard.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/styles/style.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/auth/store/auth_session_store.dart';
import 'package:mysterium_vpn/features/home/store/banners_store.dart';
import 'package:mysterium_vpn/features/locations/store/locations_store.dart';
import 'package:mysterium_vpn/features/locations/store/recent_locations_store.dart';
import 'package:mysterium_vpn/features/settings/store/user_preferences_store.dart';
import 'package:mysterium_vpn/features/settings/views/network_statistics.dart';
import 'package:mysterium_vpn/features/subscription/pages/subscription_upgrade_modal_page.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_limited_time_offer_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_store.dart';
import 'package:mysterium_vpn/features/vpn/store/connections_limit_store.dart';
import 'package:mysterium_vpn/features/vpn/store/vpn_store.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn/services/data/local/local_db_service.dart';
import 'package:mysterium_vpn/shared/components/analytics_logger_overlay.dart';
import 'package:mysterium_vpn/shared/components/analytics_user_properties_overlay.dart';
import 'package:mysterium_vpn/shared/components/dialogs/device_limit_dialog.dart';
import 'package:mysterium_vpn/shared/components/dialogs/marketing_consent_dialog.dart';
import 'package:mysterium_vpn/shared/components/dialogs/push_notifications_dialog.dart';
import 'package:mysterium_vpn/shared/components/dialogs/retry_dialog.dart';

class QAToolbox extends StatelessWidget {
  const QAToolbox({super.key});

  @override
  Widget build(BuildContext context) => Observer(
    builder: (context) => Column(
      children: [
        if (getIt<VpnStore>().isConnected && Platform.isAndroid) const NetworkStatistics(),
        _ExpandableSection(
          title: 'Data Management',
          icon: Icons.storage,
          children: [
            _buildResetActions(context),
            _buildClearLocationsAction(context),
            _buildGetMarketingConsent(context),
          ],
        ),
        _ExpandableSection(
          title: 'VPN & Connection',
          icon: Icons.vpn_lock,
          children: [
            _buildConnectionLimitAction(context),
            _buildTunnelStatusAction(context),
            _buildInvalidLocationsAction(context),
            if (Platform.isWindows) _buildOpenVPNLogsAction(context),
          ],
        ),
        _ExpandableSection(
          title: 'Subscription & Auth',
          icon: Icons.card_membership,
          children: [_buildSubscriptionActions(context), _buildAuthActions(context)],
        ),
        _ExpandableSection(
          title: 'Analytics & Debugging',
          icon: Icons.analytics,
          children: [_buildAnalyticsActions(context)],
        ),
        _ExpandableSection(
          title: 'UI Testing',
          icon: Icons.visibility,
          children: [_buildDialogTestActions(context)],
        ),
        const SizedBox(height: 36),
      ],
    ),
  );

  Widget _buildResetActions(BuildContext context) {
    final bannerStore = getIt<BannersStore>();
    final recentLocationsStore = getIt<RecentLocationsStore>();

    return _QAActionItem(
      icon: Icons.refresh,
      title: 'Reset cached data',
      subtitle: 'Reset banners and recent locations',
      actions: [
        _QAActionButton(
          label: 'Banners',
          onPressed: () async {
            await bannerStore.resetShown();
            showSnackbar('Banners reset successfully');
          },
        ),
        _QAActionButton(
          label: 'Locations',
          onPressed: () async {
            await recentLocationsStore.clear();
            showSnackbar('Recent locations reset successfully');
          },
        ),
        _QAActionButton(
          label: 'Reset PN Cooldown',
          onPressed: () async {
            await LocalDBService.instance.resetPushNotificationsPromptLastShownAt();
            showSnackbar('Push notifications prompt cooldown reset successfully');
          },
        ),
        _QAActionButton(
          label: 'Reset App open count',
          onPressed: () async {
            await LocalDBService.instance.resetAppOpenCount();
            showSnackbar('App open count reset successfully');
          },
        ),
      ],
    );
  }

  Widget _buildClearLocationsAction(BuildContext context) => _QAActionItem(
    icon: Icons.delete_outline,
    title: 'Clear cached locations',
    subtitle: 'Delete all VPN locations from database',
    actions: [
      _QAActionButton(
        label: 'Clear',
        onPressed: () async {
          await getIt<LocationsStore>().clear();
          showSnackbar('Locations cleared');
        },
      ),
    ],
  );

  Widget _buildConnectionLimitAction(BuildContext context) {
    final connectionsLimitStore = getIt<ConnectionsLimitStore>();

    return _QAActionItem(
      icon: Icons.swap_horiz,
      title: 'VPN connection limit',
      subtitle:
          'Status: ${connectionsLimitStore.connectionLimitReached ? "Reached" : "Not reached"}',
      actions: [
        _QAActionButton(
          label: 'Toggle',
          onPressed: () {
            connectionsLimitStore.connectionLimitReached =
                !connectionsLimitStore.connectionLimitReached;
            showSnackbar(
              'Connection limit: ${connectionsLimitStore.connectionLimitReached ? "reached" : "not reached"}',
            );
          },
        ),
      ],
    );
  }

  Widget _buildGetMarketingConsent(BuildContext context) {
    final userPreferencesStore = getIt<UserPreferencesStore>();

    return _QAActionItem(
      icon: Icons.swap_horiz,
      title: 'Get marketing consent',
      subtitle:
          'Status: ${userPreferencesStore.marketingConsent ?? false ? "Consented" : "Not consented"}',
      actions: [
        _QAActionButton(
          label: 'Toggle',
          onPressed: () async {
            final consent = await userPreferencesStore.getMarketingConsent();
            final newConsent = userPreferencesStore.marketingConsent;
            showSnackbar('Marketing consent fetched: $consent, current state: $newConsent');
          },
        ),
      ],
    );
  }

  Widget _buildTunnelStatusAction(BuildContext context) => _QAActionItem(
    icon: Icons.network_check,
    title: 'Check tunnel status',
    subtitle: 'Query current tunnel connection status',
    actions: [
      _QAActionButton(
        label: 'Check',
        onPressed: () async {
          final status = await getIt<VpnStore>().checkTunnelStatus();
          showSnackbar('Tunnel status: $status');
        },
      ),
    ],
  );

  Widget _buildInvalidLocationsAction(BuildContext context) => _QAActionItem(
    icon: Icons.add_location_alt_outlined,
    title: 'Insert invalid locations',
    subtitle: 'Add test locations for testing unavailable connections',
    actions: [
      _QAActionButton(label: 'Insert', onPressed: getIt<LocationsStore>().insertInvalidLocations),
    ],
  );

  Widget _buildSubscriptionActions(BuildContext context) => _QAActionItem(
    icon: Icons.science_outlined,
    title: 'Subscription testing',
    subtitle: 'Mock subscription states and offers',
    actions: [
      _QAActionButton(
        label: 'Fail',
        onPressed: () async {
          getIt<SubscriptionStore>().mockSubscriptionFailureStatus();
          showSnackbar('Subscription set to failed');
        },
      ),
      _QAActionButton(
        label: 'Mock Offer',
        onPressed: () async {
          await getIt<SubscriptionLimitedTimeOfferStore>().mockOffer();
          showSnackbar('Limited time offer created');
        },
      ),
    ],
  );

  Widget _buildAuthActions(BuildContext context) => _QAActionItem(
    icon: Icons.key_off,
    title: 'Invalidate access token',
    subtitle: 'Test token refresh mechanism',
    actions: [
      _QAActionButton(
        label: 'Invalidate',
        onPressed: () async {
          await getIt<AuthSessionStore>().invalidateAccessToken();
          showSnackbar('Access token invalidated');
        },
      ),
    ],
  );

  Widget _buildAnalyticsActions(BuildContext context) => _QAActionItem(
    icon: Icons.bug_report_outlined,
    title: 'Analytics inspection',
    subtitle: 'View logs and user properties',
    actions: [
      _QAActionButton(label: 'Logs', onPressed: () => AnalyticsLoggerOverlay.show(context)),
      _QAActionButton(
        label: 'Properties',
        onPressed: () => AnalyticsUserPropertiesOverlay.show(context),
      ),
    ],
  );

  Widget _buildDialogTestActions(BuildContext context) => Column(
    children: [
      _QAActionItem(
        icon: Icons.check,
        title: 'Test dialogs',
        subtitle: 'Show various app dialogs for testing',
        actions: [
          _QAActionButton(
            label: 'Marketing Consent',
            onPressed: () => showMarketingConsentDialog(context),
          ),
          _QAActionButton(
            label: 'Retry Subscription Verification',
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
          _QAActionButton(label: 'Device Limit', onPressed: () => showDeviceLimitDialog(context)),
          _QAActionButton(
            label: 'Push Notifications',
            onPressed: () => showPushNotificationsPermissionDialog(context),
          ),
          _QAActionButton(
            label: 'Subscription upgrade modal',
            onPressed: () => showSubscriptionUpgradeModalPage(context),
          ),
        ],
      ),
    ],
  );

  Widget _buildOpenVPNLogsAction(BuildContext context) => _QAActionItem(
    icon: Icons.description_outlined,
    title: 'Show OpenVPN logs',
    subtitle: 'View recent OpenVPN connection logs',
    actions: [_QAActionButton(label: 'Show Logs', onPressed: () => _showOpenVPNLogs(context))],
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
        debugPrint('Checking: $path - ${file.existsSync() ? "FOUND" : "not found"}');
        if (file.existsSync()) {
          foundLogFile = file;
          foundPath = path;
          break;
        }
      }

      final configDir = Directory('$localAppData\\OpenVPNDart\\config');
      debugPrint('Config directory exists: ${configDir.existsSync()} at ${configDir.path}');
      if (configDir.existsSync()) {
        debugPrint('Config directory contents:');
        final files = configDir.listSync();
        for (final file in files) {
          debugPrint('  - ${file.path}');
        }
      }

      if (foundLogFile != null && foundPath != null) {
        final allLines = await foundLogFile.readAsLines();
        final lastLines = allLines.length > 300
            ? allLines.sublist(allLines.length - 300)
            : allLines;
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
            onPressed: () => FlutterClipboard.copy(
              logs,
            ).then((value) => showSnackbar(LocaleKeys.linkCopied.tr(), type: MessageType.success)),
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

class _ExpandableSection extends StatefulWidget {
  const _ExpandableSection({required this.title, required this.icon, required this.children});
  final String title;
  final IconData icon;
  final List<Widget> children;

  @override
  State<_ExpandableSection> createState() => _ExpandableSectionState();
}

class _ExpandableSectionState extends State<_ExpandableSection> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      InkWell(
        onTap: () => setState(() => _isExpanded = !_isExpanded),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            children: [
              Icon(widget.icon, size: 20, color: Colors.grey[600]),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  widget.title,
                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                ),
              ),
              AnimatedRotation(
                turns: _isExpanded ? 0.5 : 0,
                duration: const Duration(milliseconds: 200),
                child: Icon(Icons.keyboard_arrow_down, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
      ),
      AnimatedCrossFade(
        firstChild: const SizedBox.shrink(),
        secondChild: Column(children: widget.children),
        crossFadeState: _isExpanded ? CrossFadeState.showSecond : CrossFadeState.showFirst,
        duration: const Duration(milliseconds: 200),
      ),
      Divider(height: 1, thickness: 1, color: Colors.grey[300]),
    ],
  );
}

class _QAActionItem extends StatelessWidget {
  const _QAActionItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.actions,
  });
  final IconData icon;
  final String title;
  final String subtitle;
  final List<_QAActionButton> actions;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: Colors.grey[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 18, color: Colors.grey[700]),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(title, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500)),
              const SizedBox(height: 2),
              Text(subtitle, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Wrap(
            alignment: WrapAlignment.end,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 6,
            runSpacing: 6,
            children: actions,
          ),
        ),
      ],
    ),
  );
}

class _QAActionButton extends StatelessWidget {
  const _QAActionButton({required this.label, required this.onPressed});
  final String label;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => InkWell(
    onTap: onPressed,
    borderRadius: BorderRadius.circular(6),
    child: Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Palette.lightPurple,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: Palette.purple),
      ),
      child: Text(
        label,
        style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w500, color: Palette.white),
      ),
    ),
  );
}
