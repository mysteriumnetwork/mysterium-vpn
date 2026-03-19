import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/hooks/current_ip_coordinates_hook.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/home/locations_map.dart';

class HomeMap extends HookConsumerWidget {
  const HomeMap({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locationsStore = ref.watch(locationsStorePOD);
    final selectedLocationStore = ref.watch(selectedLocationStorePOD);
    final vpnStore = ref.watch(vpnStorePOD);
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
      selectedLocationStore.value = location;
    }

    void handleDoubleTapLocation(VPNLocation location) {
      if ((vpnStore.isConnected && vpnStore.location?.id == location.id) || vpnStore.isLoading) {
        return;
      }
      handleToggleConnection(location: location);
      handleClearSelectedLocation();
    }

    useReaction(
      () => vpnStore.location,
      (location) {
        if (location == null) {
          return;
        }
        handleClearSelectedLocation();
      },
      fireImmediately: true,
    );

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
