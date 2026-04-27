import 'dart:io';

import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/core/constants/constants.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/exceptions/exceptions.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/auth/store/auth_session_store.dart';
import 'package:mysterium_vpn/features/remote_config/store/ab_testing_store.dart';
import 'package:mysterium_vpn/features/remote_config/store/remote_config_store.dart';
import 'package:mysterium_vpn/features/settings/views/blocker_picker.dart';
import 'package:mysterium_vpn/features/settings/views/protocol_picker.dart';
import 'package:mysterium_vpn/features/settings/views/settings_action_button.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_purchase_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_store.dart';
import 'package:mysterium_vpn/features/vpn/store/dns_store.dart';
import 'package:mysterium_vpn/features/vpn/store/refresh_ip_store.dart';
import 'package:mysterium_vpn/features/vpn/store/vpn_protocol_store.dart';
import 'package:mysterium_vpn/features/vpn/store/vpn_store.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class ConnectionSettings extends StatelessWidget {
  const ConnectionSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final vpnStore = getIt<VpnStore>();
    final refreshIPStore = getIt<RefreshIPStore>();
    final analyticsStore = getIt<AnalyticsStore>();
    final remoteConfigStore = getIt<RemoteConfigStore>();
    final dnsStore = getIt<DNSStore>();
    final authSessionStore = getIt<AuthSessionStore>();
    final vpnProtocolStore = getIt<VpnProtocolStore>();
    final isDesktop = ScreenType.of(context) >= ScreenType.tablet;
    final theme = Theme.of(context);

    Future<void> handleToggleConnection() async {
      final logEvent = vpnStore.isConnected
          ? analyticsStore.logDisconnect
          : analyticsStore.logConnect;
      logEvent(null);
      try {
        await vpnStore.manageConnection();
      } on AuthenticationRequiredException catch (_) {
        if (context.mounted) {
          Beamer.of(context).beamToNamed(Routes.platformLogin.path);
        }
      } on SubscriptionRequiredException catch (_) {
        if (!context.mounted) {
          return;
        }
        final subscriptionStore = getIt<SubscriptionStore>();
        final subscriptionPurchaseStore = getIt<SubscriptionPurchaseStore>();
        final remoteConfig = getIt<RemoteConfigStore>();
        final sessionStore = getIt<AuthSessionStore>();
        try {
          final subscription = await subscriptionStore.subscriptionFuture;
          if (!context.mounted) {
            return;
          }
          await handleOnBillingPage(
            context: context,
            manageSubscriptionPage: remoteConfig.manageSubscriptionPage,
            upgradeSubscriptionPage: remoteConfig.upgradeSubscriptionPage,
            gateway: subscription.gateway,
            subscriptionActive: subscription.active,
            accessToken: sessionStore.accessToken,
            onManageSubscription: subscriptionPurchaseStore.manageSubscription,
            manageSubscription: false,
          );
        } catch (_) {}
      } on TunnelSetupRequiredException catch (_) {
        if (!context.mounted) {
          return;
        }
        final abTestingStore = getIt<ABTestingStore>();
        final permissionsGranted = await showRequestTunnelPermissionsDialog(
          context,
          abTestingStore.tunnelConsentType,
        );
        if (permissionsGranted ?? false) {
          await vpnStore.setupTunnel();
          await vpnStore.manageConnection();
        }
      }
    }

    return Observer(
      builder: (_) {
        final disableSettings = !authSessionStore.isAuthenticated;

        final showReset = !remoteConfigStore.hideResetAppSetting && !Platform.isAndroid;
        final showBlocker =
            !dnsStore.hideMalwareContentBlocker || !dnsStore.hideNotSafeContentBlocker;
        final showProtocol = vpnProtocolStore.isProtocolPickerAvailable;

        final builders = <Widget Function(SettingsCardPosition)>[];
        if (showReset) {
          builders.add(
            (pos) => SettingsCard(
              title: LocaleKeys.resetAppTitle.tr(),
              subtitle: LocaleKeys.resetAppDesc.tr(),
              position: pos,
              trailing: SettingsActionButton(
                onPressed:
                    vpnStore.resetAppFuture?.status == FutureStatus.pending || disableSettings
                    ? null
                    : () => _onConfirmResetApp(
                        context: context,
                        analyticsStore: analyticsStore,
                        vpnStore: vpnStore,
                        handleToggleConnection: handleToggleConnection,
                      ),
                child: Text(LocaleKeys.resetBtn.tr()),
              ),
            ),
          );
        }

        builders.add(
          (pos) => SettingsCard(
            title: LocaleKeys.refreshIPAddress.tr(),
            subtitle: LocaleKeys.getNewIPAddress.tr(),
            position: pos,
            trailing: Observer(
              builder: (context) => refreshIPStore.refreshIPFuture.status == FutureStatus.pending
                  ? const LoadingIndicator()
                  : Switch(
                      value: refreshIPStore.refreshIPConnection,
                      onChanged: disableSettings
                          ? null
                          : (val) async {
                              await refreshIPStore.toggleRefreshIPWhenConnecting();
                              analyticsStore.logEvent(
                                val
                                    ? AnalyticsEvent.refreshIpEnable
                                    : AnalyticsEvent.refreshIpDisable,
                              );
                            },
                    ),
            ),
          ),
        );

        if (showBlocker) {
          builders.add((pos) => BlockerPicker(position: pos));
        }

        if (showProtocol) {
          builders.add((pos) => ProtocolPicker(position: pos));
        }

        final total = builders.length;
        if (total == 0) {
          return const SizedBox.shrink();
        }

        final cards = Column(
          children: [for (var i = 0; i < total; i++) builders[i](_cardPosition(i, total))],
        );

        return isDesktop
            ? Padding(
                padding: EdgeInsets.symmetric(horizontal: theme.spacing.xl3),
                child: cards,
              )
            : cards;
      },
    );
  }

  SettingsCardPosition _cardPosition(int index, int total) {
    if (total == 1) {
      return SettingsCardPosition.single;
    }
    if (index == 0) {
      return SettingsCardPosition.top;
    }
    if (index == total - 1) {
      return SettingsCardPosition.bottom;
    }
    return SettingsCardPosition.middle;
  }

  void _onConfirmResetApp({
    required BuildContext context,
    required AnalyticsStore analyticsStore,
    required VpnStore vpnStore,
    required Future<void> Function() handleToggleConnection,
  }) {
    analyticsStore.logEvent(AnalyticsEvent.resetApp);
    if (!vpnStore.isConnected) {
      _onResetApp(context, vpnStore, analyticsStore);
      return;
    }
    analyticsStore.logEvent(AnalyticsEvent.resetAppConfirmShown);
    shownConfirmationDialog(
      context,
      confirmText: LocaleKeys.resetBtn.tr(),
      cancelText: LocaleKeys.goBackButton.tr(),
      title: LocaleKeys.resetAppDialogTitle.tr(),
      supportingText: LocaleKeys.resetAppDialogContent.tr(),
      onConfirm: () {
        analyticsStore.logEvent(AnalyticsEvent.resetAppConfirm);
        _onResetApp(context, vpnStore, analyticsStore, handleToggleConnection);
      },
      onCancel: () {
        analyticsStore.logEvent(AnalyticsEvent.resetAppCancel);
      },
    );
  }

  Future<void> _onResetApp(
    BuildContext context,
    VpnStore vpnStore,
    AnalyticsStore analyticsStore, [
    Future<void> Function()? handleToggleConnection,
  ]) async {
    try {
      await vpnStore.resetApp();
      showSnackbar(
        LocaleKeys.resetAppSuccess.tr(),
        type: SnackbarType.success,
        action: handleToggleConnection != null
            ? IconButton(
                icon: const Icon(Icons.refresh, size: 16),
                onPressed: () {
                  snackbarKey.currentState?.clearSnackBars();
                  handleToggleConnection();
                },
              )
            : null,
      );
      analyticsStore.logEvent(AnalyticsEvent.resetAppSuccess);
    } catch (e, s) {
      showSnackbar(LocaleKeys.resetAppFailed.tr());
      analyticsStore
        ..logEvent(AnalyticsEvent.resetAppError)
        ..logError(err: e, stack: s);
    }
  }
}
