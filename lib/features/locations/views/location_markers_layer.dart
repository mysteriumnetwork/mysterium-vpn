import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:latlong2/latlong.dart';
import 'package:mysterium_vpn/core/extensions/vpn_location.dart';
import 'package:mysterium_vpn/features/locations/store/latlng_store.dart';
import 'package:mysterium_vpn/features/remote_config/store/remote_config_store.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class LocationMarkersLayer extends StatelessWidget {
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
  Widget build(BuildContext context) => Observer(
    builder: (context) {
      final markers = _buildLocationMarkers(
        data: locations,
        selectedLocation: selectedLocation,
        connectedLocation: connectedLocation,
        onLocationPressed: onLocationPressed,
        onLocationDoubleTapped: onLocationDoubleTapped,
      );
      return MarkerLayer(markers: markers);
    },
  );
}

List<Marker> _buildLocationMarkers({
  required List<VPNLocation> data,
  required VPNLocation? selectedLocation,
  required VPNLocation? connectedLocation,
  required Function(VPNLocation, LatLng)? onLocationPressed,
  required Function(VPNLocation, LatLng)? onLocationDoubleTapped,
}) {
  final remoteConfigStore = getIt<RemoteConfigStore>();
  final latLngStore = getIt<LatLngStore>();

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
          onPressed: () => onLocationPressed?.call(it, point),
          onDoubleTap: onLocationDoubleTapped != null
              ? () => onLocationDoubleTapped.call(it, point)
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
}
