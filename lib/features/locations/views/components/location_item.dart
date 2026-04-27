import 'dart:io';

import 'package:circle_flags/circle_flags.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/extensions/vpn_location.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/auth/store/auth_session_store.dart';
import 'package:mysterium_vpn/features/locations/store/locations_query_store.dart';
import 'package:mysterium_vpn/features/locations/store/unavailable_locations_store.dart';
import 'package:mysterium_vpn/features/remote_config/store/remote_config_store.dart';
import 'package:mysterium_vpn/features/subscription/pages/subscription_upgrade_modal_page.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_features_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_store.dart';
import 'package:mysterium_vpn/features/vpn/store/vpn_store.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// Expandable location item with per-item expansion state.
///
/// Expansion priority:
///   1. Search match -- always expands, overrides everything
///   2. Manual user toggle -- only valid while [mapSelectedCountryCode] stays
///      the same; auto-invalidates when selection changes
///   3. Auto -- expand the priority country, collapse the rest
class ExpandableLocationItem extends StatelessWidget {
  const ExpandableLocationItem({
    required this.location,
    required this.onTap,
    this.mapSelectedCountryCode,
    this.expansionOverride,
    this.onExpansionChanged,
    super.key,
  });

  final VPNLocation location;
  final void Function(VPNLocation) onTap;
  final String? mapSelectedCountryCode;

  /// Manual expansion override managed by the parent list (survives recycling).
  final bool? expansionOverride;

  /// Called when the user manually toggles expansion.
  final ValueChanged<bool>? onExpansionChanged;

  @override
  Widget build(BuildContext context) {
    final locationsQueryStore = getIt<LocationsQueryStore>();
    final vpnStore = getIt<VpnStore>();
    final subscriptionStore = getIt<SubscriptionStore>();
    final subscriptionFeaturesStore = getIt<SubscriptionFeaturesStore>();
    final unavailableLocationsStore = getIt<UnavailableLocationsStore>();
    final remoteConfig = getIt<RemoteConfigStore>();

    return Observer(
      builder: (context) {
        final query = locationsQueryStore.searchTrimmed;
        final children = location.children ?? const <VPNLocation>[];
        final showCitiesAndStates = remoteConfig.showCitiesAndStates && children.isNotEmpty;
        final locationHasStates = remoteConfig.countriesWithStates.contains(location.countryCode);

        final subscription = subscriptionStore.subscriptionFuture.value;

        final locationMode = LocationMode.from(
          location: location,
          residentialIPsAllowed: subscriptionFeaturesStore.residentialIPsAllowed,
          unavailableLocations: unavailableLocationsStore.unavailableLocations,
          subscription: subscription,
          isConnected: vpnStore.isConnected,
          isLoading: vpnStore.isLoading,
          vpnLocation: vpnStore.location,
          connectingLocation: vpnStore.connectingLocation,
        );

        final countryStatus = switch (locationMode) {
          LocationMode.connecting => IpCardStatus.connecting,
          LocationMode.connected => IpCardStatus.connected,
          LocationMode.unavailable => IpCardStatus.disabled,
          _ => IpCardStatus.idle,
        };

        final subtitle = showCitiesAndStates
            ? locationHasStates
                  ? LocaleKeys.locationItemStatesCount.plural(
                      children.length,
                      namedArgs: {'statesNum': children.length.toString()},
                    )
                  : LocaleKeys.locationItemCityCount.plural(children.length)
            : LocaleKeys.locationItemNodeCount.plural(location.nodeCount ?? 0);

        Future<void> handleUpgradePlan() async {
          final sub = await subscriptionStore.subscriptionFuture;
          final isCorrectGateway = switch (sub.gateway) {
            'google' => Platform.isAndroid,
            'apple' => Platform.isIOS || Platform.isMacOS,
            _ => true,
          };
          if (!isCorrectGateway) {
            showError(LocaleKeys.activeSubsPaidVia.tr(namedArgs: {'store': sub.gatewayName}));
            return;
          }
          final gateway = sub.gateway?.toLowerCase();
          final supportsUpgrade =
              remoteConfig.gatewaysSupportingUpgrade.contains(gateway) ||
              isMobilePaymentGateway(gateway);
          if (!supportsUpgrade || Platform.isWindows) {
            final uri = Uri.parse(remoteConfig.upgradeSubscriptionPage);
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

        final items = !showCitiesAndStates
            ? <IpCardItem>[]
            : children.map((child) {
                final childMode = LocationMode.from(
                  location: child,
                  residentialIPsAllowed: subscriptionFeaturesStore.residentialIPsAllowed,
                  unavailableLocations: unavailableLocationsStore.unavailableLocations,
                  subscription: subscription,
                  isConnected: vpnStore.isConnected,
                  isLoading: vpnStore.isLoading,
                  vpnLocation: vpnStore.location,
                  connectingLocation: vpnStore.connectingLocation,
                );
                final childPlusUpgrade = childMode == LocationMode.unsupportedByPlan;
                final status = switch (childMode) {
                  LocationMode.connecting => IpCardStatus.connecting,
                  LocationMode.connected => IpCardStatus.selected,
                  LocationMode.unavailable => IpCardStatus.disabled,
                  _ => IpCardStatus.idle,
                };
                return IpCardItem(
                  name: child.getName(context),
                  subtitle: LocaleKeys.locationItemNodeCount.plural(child.nodeCount ?? 0),
                  status: status,
                  plusUpgrade: childPlusUpgrade,
                  onTap: switch (childMode) {
                    LocationMode.unsupportedByPlan => handleUpgradePlan,
                    LocationMode.unavailable || LocationMode.connecting => null,
                    _ => vpnStore.isLoading ? null : () => onTap(child),
                  },
                );
              }).toList();

        final needsUpgrade = locationMode == LocationMode.unsupportedByPlan;

        final onConnect = switch (locationMode) {
          LocationMode.unsupportedByPlan => handleUpgradePlan,
          LocationMode.unavailable || LocationMode.connecting => null,
          _ => vpnStore.isLoading ? null : () => onTap(location),
        };

        final isExpanded = () {
          if (!showCitiesAndStates) {
            return false;
          }
          final matchesQuery =
              query.isNotEmpty &&
              children.any((it) => it.queried(query, context.locale.languageCode) != null);
          if (matchesQuery) {
            return true;
          }
          if (expansionOverride != null) {
            return expansionOverride!;
          }
          if (mapSelectedCountryCode != null) {
            return mapSelectedCountryCode == location.countryCode;
          }
          return false;
        }();

        return ExpandableIpCard(
          name: location.getName(context),
          subtitle: subtitle,
          countryIcon: CircleFlag(location.countryCode, size: 24),
          items: items,
          status: countryStatus,
          plusUpgrade: needsUpgrade,
          expanded: isExpanded,
          onExpansionChanged: onExpansionChanged,
          onConnect: onConnect,
        );
      },
    );
  }
}
