import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/vpn_location.dart';
import 'package:mysterium_vpn/common/hooks/current_ip_coordinates_hook.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/views/home/locations_map.dart';

/// Resolves a map marker within the selected IP type. A marker from an older
/// tab must never silently connect through the other network type.
/// City-gated plans can still connect to the country in that same catalog.
VPNLocation? resolveMapLocation({
  required VPNLocation location,
  required IPType ipType,
  required LocationsStore locationsStore,
  required bool cityLevelAllowed,
  required bool hasResolvedPlan,
}) {
  final catalog = ipType == IPType.datacenter
      ? locationsStore.dcLocationsFuture
      : locationsStore.residentialLocationsFuture;
  final target = location.ipType == ipType
      ? location
      : catalog.value?.allLocationsFlattened
            .where((it) => it.id == location.id && it.countryCode == location.countryCode)
            .firstOrNull;
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
  return cityGated ? locationsStore.findParent(target) ?? target : target;
}

class HomeMap extends HookConsumerWidget {
  const HomeMap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationsStore = ref.watch(locationsStorePOD);
    final locationsQueryStore = ref.watch(locationsQueryStorePOD);
    final selectedLocationStore = ref.watch(selectedLocationStorePOD);
    final vpnStore = ref.watch(vpnStorePOD);
    final subscriptionStore = ref.watch(subscriptionStorePOD);
    final selectedLocation = useComputedValue(() => selectedLocationStore.value);
    final locations = useComputedValue(
      () => locationsStore.locationsFuture.value?.allLocations.toList() ?? <VPNLocation>[],
    );
    final myLocation = useCurrentIPCoordinates();
    final connectedLocation = useComputedValue(
      () => vpnStore.isConnected ? vpnStore.location : null,
    );
    final handleToggleConnection = useHandleToggleConnection();

    void handleClearSelectedLocation() {
      selectedLocationStore.value = null;
    }

    void handleSelectLocation(VPNLocation location) {
      final resolved = resolveMapLocation(
        location: location,
        locationsStore: locationsStore,
        ipType: locationsQueryStore.ipType,
        cityLevelAllowed: subscriptionStore.cityLevelAllowed,
        hasResolvedPlan: subscriptionStore.hasResolvedPlan,
      );
      selectedLocationStore.value = resolved;
    }

    void handleDoubleTapLocation(VPNLocation location) {
      if (vpnStore.isLoading) {
        return;
      }
      final resolved = resolveMapLocation(
        location: location,
        locationsStore: locationsStore,
        ipType: locationsQueryStore.ipType,
        cityLevelAllowed: subscriptionStore.cityLevelAllowed,
        hasResolvedPlan: subscriptionStore.hasResolvedPlan,
      );
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
