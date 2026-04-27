import 'dart:io';

import 'package:beamer/beamer.dart';
import 'package:circle_flags/circle_flags.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/exceptions/exceptions.dart';
import 'package:mysterium_vpn/core/extensions/vpn_location.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/auth/store/auth_session_store.dart';
import 'package:mysterium_vpn/features/locations/store/locations_store.dart';
import 'package:mysterium_vpn/features/locations/store/selected_location_store.dart';
import 'package:mysterium_vpn/features/locations/store/unavailable_locations_store.dart';
import 'package:mysterium_vpn/features/remote_config/store/remote_config_store.dart';
import 'package:mysterium_vpn/features/subscription/pages/subscription_upgrade_modal_page.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_features_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_purchase_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_store.dart';
import 'package:mysterium_vpn/features/vpn/store/connection_display_store.dart';
import 'package:mysterium_vpn/features/vpn/store/vpn_protocol_store.dart';
import 'package:mysterium_vpn/features/vpn/store/vpn_store.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:vpn_api/vpn_api.dart';

class ConnectionTile extends StatelessWidget {
  const ConnectionTile({super.key});

  @override
  Widget build(BuildContext context) => Column(
    children: [const _ConnectionTileContent(), if (Env.flavor.isDev) const _DevProtocolLabel()],
  );
}

class _ConnectionTileContent extends StatelessWidget {
  const _ConnectionTileContent();

  @override
  Widget build(BuildContext context) => Observer(
    builder: (context) {
      final connectionDisplayStore = getIt<ConnectionDisplayStore>();
      final vpnStore = getIt<VpnStore>();
      final analyticsStore = getIt<AnalyticsStore>();
      final selectedLocationStore = getIt<SelectedLocationStore>();
      final locationsStore = getIt<LocationsStore>();
      final unavailableLocationsStore = getIt<UnavailableLocationsStore>();
      final subscriptionFeaturesStore = getIt<SubscriptionFeaturesStore>();
      final subscriptionStore = getIt<SubscriptionStore>();

      final hasDifferentSelection = connectionDisplayStore.hasDifferentSelection;
      final selectedLocation = selectedLocationStore.value;
      final connectedLocation = vpnStore.location;
      final isConnected = vpnStore.isConnected;
      final isLoading = connectionDisplayStore.isLoading;
      final ipInfo = connectionDisplayStore.connectionIP;
      final targetLocation = connectionDisplayStore.targetLocation;
      final intent = connectionDisplayStore.connectionIntent;
      final displayLocation = connectionDisplayStore.displayLocation;
      final parentLocation = connectionDisplayStore.parentLocation;
      final isLocationAvailable = connectionDisplayStore.isLocationAvailable;
      final connectionRated = connectionDisplayStore.connectionRated;
      final vpnStatus = vpnStore.vpnStatus;
      final subscription = subscriptionStore.subscriptionFuture.value;

      final needsUpgrade = () {
        final intentLocation = hasDifferentSelection ? selectedLocation : displayLocation;
        return intentLocation != null &&
            LocationMode.from(
                  location: intentLocation,
                  residentialIPsAllowed: subscriptionFeaturesStore.residentialIPsAllowed,
                  unavailableLocations: unavailableLocationsStore.unavailableLocations,
                  subscription: subscription,
                  isConnected: isConnected,
                  isLoading: isLoading,
                  vpnLocation: connectedLocation,
                  connectingLocation: null,
                ) ==
                LocationMode.unsupportedByPlan;
      }();

      final isMobile = MediaQuery.sizeOf(context).width <= 600;

      final MainIpCardStatus status;
      var noConnectionTitle = LocaleKeys.connectBestServer.tr();
      var noConnectionDescription = LocaleKeys.orSelectCountryManually.tr();
      final upgradeLabel = needsUpgrade ? LocaleKeys.subscriptionUpgrade.tr() : null;
      var connectLabel = upgradeLabel ?? LocaleKeys.connect.tr();
      var disconnectLabel = upgradeLabel ?? LocaleKeys.disconnect.tr();

      if (hasDifferentSelection && connectedLocation != null) {
        final connected = connectedLocation;
        final connectedParent = locationsStore.findParent(connected);
        final connectedCountry = connectedParent?.getName(context) ?? connected.getName(context);
        final connectedCity = connectedParent != null ? connected.getName(context) : '';
        final connectedServiceQuality = connected.ipType == IPType.residential
            ? LocaleKeys.residential.tr()
            : LocaleKeys.highSpeed.tr();
        final connectedIpPoolCount = connected.nodeCount ?? 0;

        final isSelectedUnavailable = unavailableLocationsStore.unavailableLocations.contains(
          selectedLocation,
        );
        final switchLabel = isSelectedUnavailable
            ? LocaleKeys.locationUnavailableAction.tr()
            : LocaleKeys.switchToLocationBtn.tr(
                namedArgs: {'switchLocation': selectedLocation!.getName(context)},
              );

        if (isMobile) {
          status = MainIpCardNewIpPreview(
            country: connectedCountry,
            countryIcon: CircleFlag(connected.countryCode, size: 32),
            city: connectedCity,
            ipAddress: ipInfo ?? '',
            serviceQuality: connectedServiceQuality,
            ipPoolCount: connectedIpPoolCount,
            previewCountry: selectedLocation!.getName(context),
            previewCountryIcon: CircleFlag(selectedLocation.countryCode, size: 32),
            switchLabel: switchLabel,
          );
        } else {
          final selectedParent = locationsStore.findParent(selectedLocation!);
          final selectedCountry =
              selectedParent?.getName(context) ?? selectedLocation.getName(context);
          final selectedCity = selectedParent != null ? selectedLocation.getName(context) : '';

          status = MainIpCardConnected(
            country: selectedCountry,
            countryIcon: CircleFlag(selectedLocation.countryCode, size: 32),
            city: selectedCity,
            ipAddress: ipInfo ?? '',
            serviceQuality: connectedServiceQuality,
            ipPoolCount: connectedIpPoolCount,
          );
          if (!needsUpgrade) {
            disconnectLabel = switchLabel;
          }
        }
      } else {
        final country = parentLocation?.getName(context) ?? displayLocation?.getName(context) ?? '';
        final city = parentLocation != null ? displayLocation?.getName(context) ?? '' : '';
        final ipType = displayLocation?.ipType;
        final ipPoolCount =
            (isConnected ? connectedLocation?.nodeCount : displayLocation?.nodeCount) ?? 0;
        final countryIcon = displayLocation != null
            ? CircleFlag(displayLocation.countryCode, size: 32)
            : const SizedBox(width: 32, height: 32);
        final serviceQuality = ipType == IPType.residential
            ? LocaleKeys.residential.tr()
            : LocaleKeys.highSpeed.tr();

        if (displayLocation == null) {
          status = const MainIpCardNotConnected();
        } else if (!isLocationAvailable) {
          status = const MainIpCardNotConnected();
        } else if (isConnected) {
          status = MainIpCardConnected(
            country: country,
            countryIcon: countryIcon,
            city: city,
            ipAddress: ipInfo ?? '',
            serviceQuality: serviceQuality,
            ipPoolCount: ipPoolCount,
          );
        } else if (isLoading) {
          status = MainIpCardConnecting(
            country: country,
            countryIcon: countryIcon,
            serviceQuality: serviceQuality,
          );
        } else {
          status = MainIpCardLocationSelected(
            country: country,
            countryIcon: countryIcon,
            serviceQuality: serviceQuality,
          );
        }

        if (displayLocation != null && !isLocationAvailable) {
          noConnectionTitle = LocaleKeys.locationUnavailableTitle.tr(
            args: [displayLocation.getName(context)],
          );
          noConnectionDescription = LocaleKeys.locationUnavailableSubtitle.tr();
          connectLabel = LocaleKeys.locationUnavailableAction.tr();
        }
      }

      final onToggle = isLoading
          ? null
          : needsUpgrade
          ? () => _handleUpgradePlan(context)
          : () => _handleToggleConnection(context, location: targetLocation, intent: intent);

      Future<void> onRefreshIP() async {
        analyticsStore.logRefreshIP(connectionDisplayStore.connectionIP);
        selectedLocationStore.value = null;
        await vpnStore.manageConnection(refreshIP: true);
      }

      void onDismissPreview() {
        selectedLocationStore.value = null;
      }

      void onThumbsUp() {
        showRateConnectionDialog(context, RateConnectionRequestModeEnum.like);
      }

      void onThumbsDown() {
        showRateConnectionDialog(context, RateConnectionRequestModeEnum.dislike);
      }

      final connectionRating = switch (connectionRated) {
        RateConnectionRequestModeEnum.like => ConnectionRating.thumbsUp,
        RateConnectionRequestModeEnum.dislike => ConnectionRating.thumbsDown,
        _ => ConnectionRating.none,
      };

      return MainIpCard(
        status: status,
        connectLabel: connectLabel,
        disconnectLabel: disconnectLabel,
        connectingLabel: vpnStatus == VpnConnectionStatus.disconnecting
            ? LocaleKeys.disconnecting.tr()
            : LocaleKeys.connecting.tr(),
        noConnectionTitle: noConnectionTitle,
        noConnectionDescription: noConnectionDescription,
        connectionRatingLabel: LocaleKeys.rateConnection.tr(),
        onConnect: onToggle,
        onDisconnect: onToggle,
        onRefreshIp: onRefreshIP,
        onThumbsUp: onThumbsUp,
        onThumbsDown: onThumbsDown,
        onDismissPreview: onDismissPreview,
        onSwitchCountry: onToggle,
        refreshIpTooltip: LocaleKeys.refreshIP.tr(),
        connectionRating: connectionRating,
      );
    },
  );
}

Future<void> _handleToggleConnection(
  BuildContext context, {
  VPNLocation? location,
  UserIntent? intent,
}) async {
  final vpnStore = getIt<VpnStore>();
  final analyticsStore = getIt<AnalyticsStore>();

  final logEvent = vpnStore.isConnected ? analyticsStore.logDisconnect : analyticsStore.logConnect;
  logEvent(location, intent: intent);

  try {
    await vpnStore.manageConnection(location: location, intent: intent);
  } on AuthenticationRequiredException catch (_) {
    if (context.mounted) {
      Beamer.of(context).beamToNamed(Routes.platformLogin.path);
    }
  } on SubscriptionRequiredException catch (_) {
    if (context.mounted) {
      await _handleSubscribe(context);
    }
  } on TunnelSetupRequiredException catch (_) {
    if (context.mounted) {
      final permissionsGiven = await _handleSetupTunnel(context);
      if (permissionsGiven) {
        await vpnStore.manageConnection(location: location, intent: intent);
      }
    }
  }
}

Future<void> _handleSubscribe(BuildContext context, {bool manageSubscription = false}) async {
  final sessionStore = getIt<AuthSessionStore>();
  final subscriptionStore = getIt<SubscriptionStore>();
  final subscriptionPurchaseStore = getIt<SubscriptionPurchaseStore>();
  final remoteConfigStore = getIt<RemoteConfigStore>();

  final accessToken = sessionStore.accessToken;

  try {
    final subscription = await subscriptionStore.subscriptionFuture;
    if (!context.mounted) {
      return;
    }
    await handleOnBillingPage(
      context: context,
      manageSubscriptionPage: remoteConfigStore.manageSubscriptionPage,
      upgradeSubscriptionPage: remoteConfigStore.upgradeSubscriptionPage,
      gateway: subscription.gateway,
      subscriptionActive: subscription.active,
      accessToken: accessToken,
      onManageSubscription: subscriptionPurchaseStore.manageSubscription,
      manageSubscription: manageSubscription,
    );
  } on SubscriptionRequiredException catch (_) {
    // ignore and let the flow continue
  }
}

Future<void> _handleUpgradePlan(BuildContext context) async {
  final subscriptionStore = getIt<SubscriptionStore>();
  final subscription = await subscriptionStore.subscriptionFuture;
  final remoteConfigStore = getIt<RemoteConfigStore>();

  final isCorrectGateway = switch (subscription.gateway) {
    'google' => Platform.isAndroid,
    'apple' => Platform.isIOS || Platform.isMacOS,
    _ => true,
  };

  if (!isCorrectGateway) {
    showError(LocaleKeys.activeSubsPaidVia.tr(namedArgs: {'store': subscription.gatewayName}));
    return;
  }
  final gateway = subscription.gateway?.toLowerCase();
  final supportsUpgrade =
      remoteConfigStore.gatewaysSupportingUpgrade.contains(gateway) ||
      isMobilePaymentGateway(gateway);

  if (!supportsUpgrade || Platform.isWindows) {
    final uri = Uri.parse(remoteConfigStore.upgradeSubscriptionPage);
    final sessionStore = getIt<AuthSessionStore>();
    final token = await sessionStore.accessTokenFuture;
    final httpsUri = Uri(
      scheme: uri.scheme,
      host: uri.host,
      path: uri.path,
      queryParameters: {'access_token': token ?? ''},
    );

    openUrlLink(httpsUri).ignore();
    return;
  }
  if (!context.mounted) {
    return;
  }

  await showSubscriptionUpgradeModalPage(context);
}

Future<bool> _handleSetupTunnel(BuildContext context) async {
  final vpnStore = getIt<VpnStore>();

  final permissionsGranted = await showRequestTunnelPermissionsDialog(context);
  if (permissionsGranted ?? false) {
    await vpnStore.setupTunnel();
    return true;
  }
  return false;
}

class _DevProtocolLabel extends StatelessWidget {
  const _DevProtocolLabel();

  @override
  Widget build(BuildContext context) {
    final vpnProtocol = getIt<VpnProtocolStore>();
    final palette = Theme.of(context).palette;
    return Observer(
      builder: (context) => Align(
        alignment: Alignment.centerLeft,
        child: Text(
          'Protocol: ${vpnProtocol.protocol.name}',
          style: TextStyle(fontSize: 8, color: palette.textSecondary, fontWeight: FontWeight.w800),
        ),
      ),
    );
  }
}
