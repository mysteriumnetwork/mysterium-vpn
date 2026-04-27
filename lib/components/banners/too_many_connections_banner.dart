import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/exceptions/exceptions.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/auth/store/auth_session_store.dart';
import 'package:mysterium_vpn/features/remote_config/store/remote_config_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_purchase_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_store.dart';
import 'package:mysterium_vpn/features/vpn/store/connections_limit_store.dart';
import 'package:mysterium_vpn/features/vpn/store/vpn_store.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class TooManyConnectionsBanner extends StatelessWidget {
  const TooManyConnectionsBanner({super.key});

  Future<void> _handleDisconnect(BuildContext context) async {
    final vpnStore = getIt<VpnStore>();
    final analyticsStore = getIt<AnalyticsStore>();
    final connectionsLimitStore = getIt<ConnectionsLimitStore>();

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
      return;
    } on SubscriptionRequiredException catch (_) {
      final sessionStore = getIt<AuthSessionStore>();
      final subscriptionStore = getIt<SubscriptionStore>();
      final subscriptionPurchaseStore = getIt<SubscriptionPurchaseStore>();
      final remoteConfigStore = getIt<RemoteConfigStore>();
      final accessToken = sessionStore.accessToken;
      try {
        final subscription = await subscriptionStore.subscriptionFuture;
        if (context.mounted) {
          await handleOnBillingPage(
            context: context,
            manageSubscriptionPage: remoteConfigStore.manageSubscriptionPage,
            upgradeSubscriptionPage: remoteConfigStore.upgradeSubscriptionPage,
            gateway: subscription.gateway,
            subscriptionActive: subscription.active,
            accessToken: accessToken,
            onManageSubscription: subscriptionPurchaseStore.manageSubscription,
            manageSubscription: false,
          );
        }
      } on SubscriptionRequiredException catch (_) {
        // ignore
      }
      return;
    } on TunnelSetupRequiredException catch (_) {
      if (context.mounted) {
        final permissionsGranted = await showRequestTunnelPermissionsDialog(context);
        if (permissionsGranted ?? false) {
          await vpnStore.setupTunnel();
          await vpnStore.manageConnection();
        }
        return;
      }
    }

    connectionsLimitStore.connectionLimitReached = false;
  }

  @override
  Widget build(BuildContext context) {
    final vpnStore = getIt<VpnStore>();

    return Observer(
      builder: (context) {
        final isConnected = vpnStore.isConnected;

        return AlertModal(
          type: AlertModalType.warning,
          title: LocaleKeys.tooManyConnectionsBannerTitle.tr(),
          supportingText: isConnected
              ? LocaleKeys.tooManyConnectionsBannerDescConnected.tr()
              : LocaleKeys.tooManyConnectionsBannerDesc.tr(),
          primaryButton: ButtonPrimary(
            size: ButtonSize.small,
            onPressed: () => _handleDisconnect(context),
            child: Text(
              isConnected
                  ? LocaleKeys.tooManyConnectionsBannerCTADisconnect.tr()
                  : LocaleKeys.tooManyConnectionsBannerCTAReconnect.tr(),
            ),
          ),
        );
      },
    );
  }
}
