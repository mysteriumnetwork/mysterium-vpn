import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/list.dart';
import 'package:mysterium_vpn/common/extensions/vpn_location.dart';
import 'package:mysterium_vpn/common/hooks/current_ip_coordinates_hook.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/views/home/locations_map.dart';

/// A typed tab keeps the selected IP type, even for a stale marker.
/// The standalone map (no [ipType]) can fall back to Datacenter.
VPNLocation? resolveMapLocation({
  required VPNLocation location,
  required IPType? ipType,
  required LocationsStore locationsStore,
  required bool cityLevelAllowed,
  required bool hasResolvedPlan,
  bool residentialIPsAllowed = true,
}) {
  VPNLocation? target = location;
  if (ipType != null && location.ipType != ipType) {
    final catalog = ipType == IPType.datacenter
        ? locationsStore.dcLocationsFuture
        : locationsStore.residentialLocationsFuture;
    target = catalog.value?.allLocationsFlattened
        .where((it) => it.id == location.id && it.countryCode == location.countryCode)
        .firstOrNull;
  }
  if (target == null) {
    return null;
  }

  final cityGated =
      !target.isCountry &&
      LocationMode.isUnsupportedByPlan(
        location: target,
        hasResolvedPlan: hasResolvedPlan,
        residentialIPsAllowed: true,
        cityLevelAllowed: cityLevelAllowed,
      );
  final resolved = cityGated ? locationsStore.findParent(target) ?? target : target;
  if (ipType != null ||
      resolved.ipType != IPType.residential ||
      (residentialIPsAllowed && resolved.isAvailable)) {
    return resolved;
  }

  final alternatives = locationsStore.dcLocationsFuture.value?.allLocationsFlattened.where(
    (it) => it.countryCode == resolved.countryCode && it.isAvailable,
  );
  return alternatives?.where((it) => it.id == resolved.id).firstOrNull ??
      alternatives?.where((it) => it.isCountry).firstOrNull ??
      resolved;
}

class HomeMap extends HookConsumerWidget {
  const HomeMap({required this.followLocationTabs, super.key});

  final bool followLocationTabs;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationsStore = ref.watch(locationsStorePOD);
    final locationsQueryStore = ref.watch(locationsQueryStorePOD);
    final selectedLocationStore = ref.watch(selectedLocationStorePOD);
    final vpnStore = ref.watch(vpnStorePOD);
    final subscriptionStore = ref.watch(subscriptionStorePOD);
    final selectedLocation = useComputedValue(() => selectedLocationStore.value);
    final locations = useComputedValue(() {
      if (followLocationTabs) {
        return locationsStore.locationsFuture.value?.allLocations.toList() ?? <VPNLocation>[];
      }
      return [
        ...?locationsStore.residentialLocationsFuture.value?.allLocations,
        ...?locationsStore.dcLocationsFuture.value?.allLocations,
      ].distinctBy((it) => (it.id, it.countryCode)).toList();
    }, [followLocationTabs]);
    final myLocation = useCurrentIPCoordinates();
    final connectedLocation = useComputedValue(() {
      final location = vpnStore.isConnected ? vpnStore.location : null;
      // A pin from the previous catalog can overlap and intercept a tap on
      // the current catalog's pin.
      return !followLocationTabs || location?.ipType == locationsQueryStore.ipType
          ? location
          : null;
    }, [followLocationTabs]);
    final handleToggleConnection = useHandleToggleConnection();

    void handleClearSelectedLocation() {
      selectedLocationStore.value = null;
    }

    VPNLocation? resolve(VPNLocation location) => resolveMapLocation(
      location: location,
      locationsStore: locationsStore,
      ipType: followLocationTabs ? locationsQueryStore.ipType : null,
      cityLevelAllowed: subscriptionStore.cityLevelAllowed,
      hasResolvedPlan: subscriptionStore.hasResolvedPlan,
      residentialIPsAllowed: subscriptionStore.residentialIPsAllowed,
    );

    void handleSelectLocation(VPNLocation location) {
      selectedLocationStore.value = resolve(location);
    }

    void handleDoubleTapLocation(VPNLocation location) {
      if (vpnStore.isLoading) {
        return;
      }
      final resolved = resolve(location);
      if (resolved == null || (vpnStore.isConnected && resolved.covers(vpnStore.location))) {
        return;
      }
      handleToggleConnection(location: resolved);
      handleClearSelectedLocation();
    }

    useReaction(() => vpnStore.location, (location) {
      if (location == null) {
        return;
      }
      handleClearSelectedLocation();
    }, fireImmediately: true);

    return LocationsMap(
      locations: locations,
      position: myLocation,
      selectedLocation: selectedLocation,
      connectedLocation: connectedLocation,
      onLocationPressed: handleSelectLocation,
      onLocationDoubleTapped: isDesktop() ? handleDoubleTapLocation : null,
      onTapOutside: handleClearSelectedLocation,
    );
  }
}
