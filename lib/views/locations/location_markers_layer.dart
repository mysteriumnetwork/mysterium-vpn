import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:mysterium_vpn/common/extensions/vpn_location.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class LocationMarkersLayer extends HookWidget {
  const LocationMarkersLayer({
    required this.locations,
    required this.selectedLocation,
    required this.connectedLocation,
    required this.onLocationPressed,
    this.onLocationDoubleTapped,
    super.key,
  });

  final List<VPNLocation> locations;
  final VPNLocation? selectedLocation;
  final VPNLocation? connectedLocation;
  final Function(VPNLocation location, LatLng point)? onLocationPressed;
  final Function(VPNLocation location, LatLng point)? onLocationDoubleTapped;

  @override
  Widget build(BuildContext context) {
    final markers = _useLocationMarkers(
      data: locations,
      selectedLocation: selectedLocation,
      connectedLocation: connectedLocation,
      onLocationPressed: onLocationPressed,
      onLocationDoubleTapped: onLocationDoubleTapped,
    );

    return MarkerLayer(markers: markers);
  }
}

List<Marker> _useLocationMarkers({
  required List<VPNLocation> data,
  required VPNLocation? selectedLocation,
  required VPNLocation? connectedLocation,
  required Function(VPNLocation, LatLng)? onLocationPressed,
  required Function(VPNLocation, LatLng)? onLocationDoubleTapped,
}) {
  final remoteConfigStore = useProvider(remoteConfigStorePOD);
  final latLngStore = useProvider(latLngStorePOD);
  final onLocationPressedRef = useRef(onLocationPressed)..value = onLocationPressed;
  final onLocationDoubleTappedRef = useRef(onLocationDoubleTapped)..value = onLocationDoubleTapped;

  return useComputedValue<List<Marker>>(
    () {
      final cities = remoteConfigStore.showCitiesAndStates
          ? {
              ...data
                  .where(
                    (it) =>
                        !it.isCountry &&
                        remoteConfigStore.countriesWithCitiesOnMap.contains(
                          it.countryCode.toUpperCase(),
                        ),
                  )
                  .groupListsBy((it) => it.countryCode.toUpperCase())
                  .entries
                  .expand((entry) {
                if (entry.key == 'CA') {
                  return entry.value.sortedBy<num>((it) => -(it.nodeCount ?? 0)).take(15);
                }
                return entry.value;
              }),
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
          (it) =>
              it.countryCode == connectedLocation?.countryCode ||
              it.countryCode == selectedLocation?.countryCode,
        ),
        ?selectedLocation,
        if (connectedLocation != null && connectedLocation != selectedLocation) connectedLocation,
      };

      final markers = <Marker>[];
      Marker? labelMarker;

      for (final it in sorted) {
        final point = it.isCountry
            ? latLngStore.coordinatesForCountry(it.countryCode)
            : latLngStore.coordinatesForCity(it);

        if (point == null) {
          continue;
        }

        final isConnected = connectedLocation?.id == it.id;
        final isSelected = selectedLocation?.id == it.id;
        final isActive = isConnected || isSelected;
        // Connected location is never labelled even if also selected.
        final hasLabel = isSelected && !isConnected;

        markers.add(
          Marker(
            point: point,
            width: isActive ? 60 : 20,
            height: isActive ? 60 : 20,
            alignment: Alignment.center,
            child: MapLocationMarker(
              isConnected: isConnected,
              isSelected: isSelected,
              onPressed: () => onLocationPressedRef.value?.call(it, point),
              onDoubleTap: onLocationDoubleTappedRef.value != null
                  ? () => onLocationDoubleTappedRef.value?.call(it, point)
                  : null,
            ),
          ),
        );

        if (hasLabel) {
          labelMarker = Marker(
            point: point,
            width: 400,
            height: 45,
            alignment: Alignment.topCenter,
            child: IgnorePointer(
              child: Builder(
                builder: (context) => Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    IntrinsicWidth(child: MapLocationTooltip(label: it.getName(context))),
                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          );
        }
      }

      // Add label last so it renders on top of all pins.
      if (labelMarker != null) {
        markers.add(labelMarker);
      }

      return markers;
    },
    [
      onLocationPressedRef,
      latLngStore,
      data,
      selectedLocation?.id,
      connectedLocation?.id,
      remoteConfigStore.showCitiesAndStates,
      remoteConfigStore.countriesWithCitiesOnMap,
    ],
  );
}
