import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mysterium_vpn/common/extensions/vpn_location.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/components/location_marker.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

class LocationMarkersLayer extends HookWidget {
  const LocationMarkersLayer({
    required this.locations,
    required this.selectedLocation,
    required this.connectedLocation,
    required this.onLocationPressed,
    super.key,
  });

  final List<VPNLocation> locations;
  final VPNLocation? selectedLocation;
  final VPNLocation? connectedLocation;
  final Function(VPNLocation location, LatLng point)? onLocationPressed;

  @override
  Widget build(BuildContext context) {
    final markers = _useLocationMarkers(
      data: locations,
      selectedLocation: selectedLocation,
      connectedLocation: connectedLocation,
      onLocationPressed: onLocationPressed,
    );

    return MarkerLayer(markers: markers);
  }
}

List<Marker> _useLocationMarkers({
  required List<VPNLocation> data,
  required VPNLocation? selectedLocation,
  required VPNLocation? connectedLocation,
  required Function(VPNLocation, LatLng)? onLocationPressed,
}) {
  final remoteConfigStore = useProvider(remoteConfigStorePOD);
  final latLngStore = useProvider(latLngStorePOD);
  final onLocationPressedRef = useRef(onLocationPressed)..value = onLocationPressed;

  return useComputedValue<List<Marker>>(
    () {
      final cities = remoteConfigStore.showCitiesAndStates
          ? {
              ...data.where(
                (it) =>
                    !it.isCountry &&
                    remoteConfigStore.countriesWithCitiesOnMap
                        .contains(it.countryCode.toUpperCase()),
              ),
            }
          : const <VPNLocation>{};

      final countries = {
        ...data.where(
          (it) =>
              it.isCountry &&
              cities.none((city) => city.countryCode.toUpperCase() == it.countryCode.toUpperCase()),
        ),
      };

      final sorted = {
        ...cities,
        ...countries.whereNot(
          (it) => it.id == connectedLocation?.id || it.id == selectedLocation?.id,
        ),
        if (selectedLocation != null) selectedLocation,
        if (connectedLocation != null && connectedLocation != selectedLocation) connectedLocation,
      };

      return sorted
          .map((it) {
            final point = it.isCountry
                ? latLngStore.coordinatesForCountry(it.countryCode)
                : latLngStore.coordinatesForCity(it);

            if (point == null) {
              return null;
            }

            final isConnected = connectedLocation?.id == it.id;
            final isSelected = selectedLocation?.id == it.id;
            final size = isConnected || isSelected ? const Size.square(60) : const Size.square(20);

            return Marker(
              point: point,
              height: size.height,
              width: size.width,
              child: LocationMarker(
                size: size,
                isConnected: isConnected,
                isSelected: isSelected,
                onPressed: () => onLocationPressedRef.value?.call(it, point),
              ),
            );
          })
          .nonNulls
          .toList();
    },
    [
      onLocationPressedRef,
      latLngStore,
      data,
      selectedLocation?.id,
      connectedLocation?.id,
    ],
  );
}
