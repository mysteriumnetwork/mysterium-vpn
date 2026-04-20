import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/extensions/vpn_location.dart';
import 'package:mysterium_vpn/common/hooks/current_ip_coordinates_hook.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/views/home/locations_map.dart';

/// Resolves the best available VPN location when connecting from the map.
/// Priority: residential (if allowed and available) > datacenter > original (triggers paywall).
@visibleForTesting
VPNLocation resolveMapLocation({
  required VPNLocation location,
  required LocationsStore locationsStore,
  required bool residentialIPsAllowed,
}) {
  if (location.ipType == IPType.datacenter) {
    return location;
  }

  if (residentialIPsAllowed && location.isAvailable) {
    return location;
  }

  final dcAlternative = locationsStore.dcLocationsFuture.value?.allLocations
      .where((it) => it.countryCode == location.countryCode && it.isCountry == location.isCountry)
      .firstOrNull;

  if (dcAlternative != null && dcAlternative.isAvailable) {
    return dcAlternative;
  }

  return location;
}

class HomeMap extends HookConsumerWidget {
  const HomeMap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationsStore = ref.watch(locationsStorePOD);
    final selectedLocationStore = ref.watch(selectedLocationStorePOD);
    final vpnStore = ref.watch(vpnStorePOD);
    final subscriptionFeaturesStore = ref.watch(subscriptionFeaturesStorePOD);
    final selectedLocation = useComputedValue(() => selectedLocationStore.value);
    final locations = useComputedValue(
      () => [
        ...?locationsStore.residentialLocationsFuture.value?.allLocations,
        ...?locationsStore.dcLocationsFuture.value?.allLocations,
      ].distinctBy((it) => it.id).toList(),
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
        residentialIPsAllowed: subscriptionFeaturesStore.residentialIPsAllowed,
      );
      selectedLocationStore.value = resolved;
    }

    void handleDoubleTapLocation(VPNLocation location) {
      if ((vpnStore.isConnected && vpnStore.location?.id == location.id) || vpnStore.isLoading) {
        return;
      }
      final resolved = resolveMapLocation(
        location: location,
        locationsStore: locationsStore,
        residentialIPsAllowed: subscriptionFeaturesStore.residentialIPsAllowed,
      );
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
