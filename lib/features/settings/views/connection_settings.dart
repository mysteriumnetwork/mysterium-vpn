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
import 'package:mysterium_vpn/core/extensions/asset.dart';
import 'package:mysterium_vpn/core/styles/style.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/auth/store/auth_session_store.dart';
import 'package:mysterium_vpn/features/remote_config/store/ab_testing_store.dart';
import 'package:mysterium_vpn/features/remote_config/store/remote_config_store.dart';
import 'package:mysterium_vpn/features/settings/views/action_button.dart';
import 'package:mysterium_vpn/features/settings/views/protocol_picker.dart';
import 'package:mysterium_vpn/features/settings/views/switch_item.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_purchase_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_store.dart';
import 'package:mysterium_vpn/features/vpn/store/dns_store.dart';
import 'package:mysterium_vpn/features/vpn/store/refresh_ip_store.dart';
import 'package:mysterium_vpn/features/vpn/store/vpn_protocol_store.dart';
import 'package:mysterium_vpn/features/vpn/store/vpn_store.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:styled_widget/styled_widget.dart';

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
        return Column(
          children: [
            Visibility(
              visible: !remoteConfigStore.hideResetAppSetting && !Platform.isAndroid,
              child: SettingItem(
                asset: Asset.icons.resetAppSetting(context),
                title: LocaleKeys.resetAppTitle.tr(),
                subtitle: EasyText(
                  LocaleKeys.resetAppDesc.tr(),
                  fontSize: 12,
                  fontWeight: FontWeight.w400,
                  maxLines: 3,
                ),
                actionWidget: SettingActionButton(
                  action: vpnStore.resetAppFuture?.status == FutureStatus.pending || disableSettings
                      ? null
                      : () => _onConfirmResetApp(
                          context: context,
                          analyticsStore: analyticsStore,
                          vpnStore: vpnStore,
                          handleToggleConnection: handleToggleConnection,
                        ),
                  backgroundColor: Palette.purple,
                  child: Text(LocaleKeys.resetAppTitle.tr()),
                ),
              ),
            ),
            SwitchItem(
              asset: Asset.icons.refreshIpSetting(context),
              title: LocaleKeys.refreshIPAddress.tr(),
              subtitle: LocaleKeys.getNewIPAddress.tr(),
              actionWidget: Observer(
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
            Visibility(
              visible: !dnsStore.hideMalwareContentBlocker,
              child: SwitchItem(
                enabled: !dnsStore.notSafeContentBlocker,
                asset: Asset.icons.locker(context),
                title: LocaleKeys.malwareBlocker.tr(),
                subtitle: '',
                actionWidget: Observer(
                  builder: (context) =>
                      dnsStore.malwareContentBlockerFuture.status == FutureStatus.pending
                      ? const LoadingIndicator()
                      : Switch(
                          value: dnsStore.malwareContentBlocker,
                          onChanged: disableSettings
                              ? null
                              : (val) async {
                                  await dnsStore.toggleMalwareBlocker();
                                  analyticsStore.logEvent(
                                    val ? AnalyticsEvent.malwareOn : AnalyticsEvent.malwareOff,
                                  );
                                },
                        ),
                ),
              ),
            ),
            Visibility(
              visible: !dnsStore.hideNotSafeContentBlocker,
              child: SwitchItem(
                asset: Asset.icons.stop(context),
                title: LocaleKeys.contentBlockerTitle.tr(),
                subtitle: LocaleKeys.contentBlockerDesc.tr(),
                actionWidget: Observer(
                  builder: (context) =>
                      dnsStore.notSafeContentBlockerFuture.status == FutureStatus.pending
                      ? const LoadingIndicator()
                      : Switch(
                          value: dnsStore.notSafeContentBlocker,
                          onChanged: disableSettings
                              ? null
                              : (val) async {
                                  await dnsStore.toggleNotSafeContentBlocker();
                                  analyticsStore.logEvent(
                                    val ? AnalyticsEvent.nsfwOn : AnalyticsEvent.nsfwOff,
                                  );
                                },
                        ),
                ),
              ),
            ),
            Visibility(
              visible: !remoteConfigStore.hideKillSwitch,
              child: SwitchItem(
                asset: Asset.icons.refreshIpSetting(context),
                title: LocaleKeys.killSwitch.tr(),
                subtitle: LocaleKeys.killSwitchDesc.tr(),
                actionWidget: Row(
                  children: [
                    EasyText(
                      LocaleKeys.on.tr(),
                      color: Palette.lightBlue,
                    ).paddingDirectional(end: 5),
                    SvgIcon(asset: Asset.icons.checkmark),
                  ],
                ),
              ),
            ),
            Visibility(
              visible: vpnProtocolStore.isProtocolPickerAvailable,
              child: SettingItem(
                asset: Asset.icons.protocol(context),
                title: LocaleKeys.protocol.tr(),
                actionWidget: const ProtocolPicker(),
              ),
            ),
          ],
        );
      },
    );
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
    shownConfirmationDialog(
      context,
      confirmText: LocaleKeys.resetBtn.tr(),
      cancelText: LocaleKeys.goBackButton.tr(),
      title: LocaleKeys.resetAppDialogTitle.tr(),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            LocaleKeys.resetAppDialogContent.tr(),
            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Palette.black),
            maxLines: 4,
            textAlign: TextAlign.center,
          ),
        ],
      ),
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
        type: MessageType.success,
        action: handleToggleConnection != null
            ? SnackBarAction(
                label: LocaleKeys.reconnectBtn.tr(),
                backgroundColor: Palette.black,
                textColor: Palette.white,
                onPressed: () async {
                  snackbarKey.currentState?.clearSnackBars();
                  await handleToggleConnection();
                },
              )
            : null,
      );
      analyticsStore.logEvent(AnalyticsEvent.resetAppSuccess);
    } catch (e, s) {
      showSnackbar(LocaleKeys.resetAppFailed.tr());
      analyticsStore.logError(err: e, stack: s);
    }
  }
}
