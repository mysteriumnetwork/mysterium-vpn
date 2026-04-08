import 'package:circle_flags/circle_flags.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/vpn_location.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart' hide ScreenType;

/// Expandable location item with per-item expansion state.
///
/// Expansion priority:
///   1. Search match — always expands, overrides everything
///   2. Manual user toggle — only valid while [mapSelectedCountryCode] stays
///      the same; auto-invalidates when selection changes
///   3. Auto — expand the priority country, collapse the rest
class ExpandableLocationItem extends HookConsumerWidget {
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
  Widget build(BuildContext context, WidgetRef ref) {
    final vpnStore = ref.watch(vpnStorePOD);
    final subscriptionStore = ref.watch(subscriptionStorePOD);
    final subscriptionFeaturesStore = ref.watch(subscriptionFeaturesStorePOD);
    final unavailableLocationsStore = ref.watch(unavailableLocationsStorePOD);
    final remoteConfig = ref.watch(remoteConfigStorePOD);
    final locationsQueryStore = ref.watch(locationsQueryStorePOD);
    final query = useComputedValue(() => locationsQueryStore.searchTrimmed);
    final handleUpgradePlan = useHandleUpgradePlan();

    final children = location.children ?? const <VPNLocation>[];
    final showCitiesAndStates = remoteConfig.showCitiesAndStates && children.isNotEmpty;
    final locationHasStates = remoteConfig.countriesWithStates.contains(location.countryCode);

    final isExpanded = useMemoized(() {
      if (!showCitiesAndStates) {
        return false;
      }

      // Rule 1: search match always expands
      final matchesQuery =
          query.isNotEmpty &&
          children.any((it) => it.queried(query, context.locale.languageCode) != null);
      if (matchesQuery) {
        return true;
      }

      // Rule 2: explicit user toggle (managed by parent, survives recycling)
      if (expansionOverride != null) {
        return expansionOverride!;
      }

      // Rule 3: auto-expand the selected/connected country, collapse the rest
      if (mapSelectedCountryCode != null) {
        return mapSelectedCountryCode == location.countryCode;
      }

      return false;
    }, [query, mapSelectedCountryCode, expansionOverride, showCitiesAndStates, children]);

    final onTapComputed = useComputedValue(() => vpnStore.isLoading ? null : onTap, [onTap]);

    final locationMode = useComputedValue(
      () => _LocationMode.from(
        location: location,
        residentialIPsAllowed: subscriptionFeaturesStore.residentialIPsAllowed,
        unavailableLocations: unavailableLocationsStore.unavailableLocations,
        subscription: subscriptionStore.subscriptionFuture.value,
        isConnected: vpnStore.isConnected,
        isLoading: vpnStore.isLoading,
        vpnLocation: vpnStore.location,
        connectingLocation: vpnStore.connectingLocation,
      ),
      [location],
    );

    final countryStatus = useComputedValue(
      () => switch (locationMode) {
        _LocationMode.connecting => IpCardStatus.connecting,
        _LocationMode.connected => IpCardStatus.connected,
        _LocationMode.unavailable => IpCardStatus.disabled,
        _ => IpCardStatus.idle,
      },
      [locationMode],
    );

    final subtitle = showCitiesAndStates
        ? locationHasStates
              ? LocaleKeys.locationItemStatesCount.plural(
                  children.length,
                  namedArgs: {'statesNum': children.length.toString()},
                )
              : LocaleKeys.locationItemCityCount.plural(children.length)
        : LocaleKeys.locationItemNodeCount.plural(location.nodeCount ?? 0);

    final subscription = useComputedValue(() => subscriptionStore.subscriptionFuture.value);

    final items = useComputedValue(() {
      if (!showCitiesAndStates) {
        return <IpCardItem>[];
      }
      return children.map((child) {
        final childMode = _LocationMode.from(
          location: child,
          residentialIPsAllowed: subscriptionFeaturesStore.residentialIPsAllowed,
          unavailableLocations: unavailableLocationsStore.unavailableLocations,
          subscription: subscription,
          isConnected: vpnStore.isConnected,
          isLoading: vpnStore.isLoading,
          vpnLocation: vpnStore.location,
          connectingLocation: vpnStore.connectingLocation,
        );
        final childPlusUpgrade = childMode == _LocationMode.unsupportedByPlan;
        final status = switch (childMode) {
          _LocationMode.connecting => IpCardStatus.connecting,
          _LocationMode.connected => IpCardStatus.selected,
          _LocationMode.unavailable => IpCardStatus.disabled,
          _ => IpCardStatus.idle,
        };
        return IpCardItem(
          name: child.getName(context),
          subtitle: LocaleKeys.locationItemNodeCount.plural(child.nodeCount ?? 0),
          status: status,
          plusUpgrade: childPlusUpgrade,
          onTap: switch (childMode) {
            _LocationMode.unsupportedByPlan => handleUpgradePlan,
            _LocationMode.unavailable || _LocationMode.connecting => null,
            _ => vpnStore.isLoading ? null : () => onTap(child),
          },
        );
      }).toList();
    }, [children, showCitiesAndStates, onTap, subscription, locationMode]);

    final needsUpgrade = locationMode == _LocationMode.unsupportedByPlan;

    return ExpandableIpCard(
      name: location.getName(context),
      subtitle: subtitle,
      countryIcon: CircleFlag(location.countryCode, size: 24),
      items: items,
      status: countryStatus,
      plusUpgrade: needsUpgrade,
      expanded: isExpanded,
      onExpansionChanged: onExpansionChanged,
      onConnect: switch (locationMode) {
        _LocationMode.unsupportedByPlan => handleUpgradePlan,
        _LocationMode.unavailable || _LocationMode.connecting => null,
        _ => onTapComputed == null ? null : () => onTapComputed(location),
      },
    );
  }
}

enum _LocationMode {
  connecting,
  connected,
  available,
  unavailable,
  unsubscribed,
  unsupportedByPlan;

  static _LocationMode from({
    required VPNLocation location,
    required bool residentialIPsAllowed,
    required Iterable<VPNLocation> unavailableLocations,
    required Subscription? subscription,
    required bool isConnected,
    required bool isLoading,
    required VPNLocation? vpnLocation,
    required VPNLocation? connectingLocation,
  }) {
    if (isLoading && (location == vpnLocation || location == connectingLocation)) {
      return _LocationMode.connecting;
    }
    if (isConnected && location == vpnLocation) {
      return _LocationMode.connected;
    }
    if (subscription == null || !subscription.active) {
      return _LocationMode.unsubscribed;
    }
    if (location.ipType == IPType.residential) {
      if (!residentialIPsAllowed || !location.isAvailable) {
        return _LocationMode.unsupportedByPlan;
      }
    }
    if (unavailableLocations.contains(location) || !location.isAvailable) {
      return _LocationMode.unavailable;
    }
    return _LocationMode.available;
  }
}
