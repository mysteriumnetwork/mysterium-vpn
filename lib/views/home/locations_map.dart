import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/hooks/map_controller_hook.dart';
import 'package:mysterium_vpn/components/location_marker.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/home/world_map_tiles_layer.dart';

class LocationsMap extends HookConsumerWidget {
  const LocationsMap({
    super.key,
    this.locations,
    this.position,
    this.activeLocation,
    this.onLocationPressed,
    this.onTapOutside,
  });

  final List<VPNLocation>? locations;
  final LatLng? position;
  final VPNLocation? activeLocation;
  final Function(VPNLocation location)? onLocationPressed;
  final VoidCallback? onTapOutside;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const zoom = 4.0;
    final theme = Theme.of(context);
    final controller = useMapController();

    void handlePressed(VPNLocation location, LatLng point) {
      controller.move(point, controller.camera.zoom);
      onLocationPressed?.call(location);
    }

    final markers = _useLocationMarkers(
      locations: locations,
      activeLocation: activeLocation,
      onLocationPressed: handlePressed,
    );

    useValueChanged<LatLng?, void>(position, (_, __) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final center = position;
        if (center == null || center == controller.camera.center) {
          return;
        }

        controller.move(center, controller.camera.zoom);
      });
    });

    return FlutterMap(
      mapController: controller,
      options: MapOptions(
        initialZoom: zoom,
        initialCenter: position ?? const LatLng(0, 0),
        cameraConstraint: CameraConstraint.contain(bounds: kWorldBounds),
        backgroundColor: theme.colorScheme.surface,
        minZoom: zoom,
        maxZoom: zoom,
        onTap: (_, __) => onTapOutside?.call(),
      ),
      children: [
        const WorldMapTilesLayer(),
        MarkerLayer(markers: markers),
      ],
    );
  }
}

List<Marker> _useLocationMarkers({
  required List<VPNLocation>? locations,
  required VPNLocation? activeLocation,
  required Function(VPNLocation, LatLng)? onLocationPressed,
}) {
  final latLngStore = useProvider(latLngStorePOD);
  final onLocationPressedRef = useRef(onLocationPressed)..value = onLocationPressed;

  return useComputedValue<List<Marker>>(
    () {
      if (locations == null || latLngStore.coordinatesFuture.value == null) {
        return [];
      }

      return locations
          .map((it) {
            final point = latLngStore.coordinatesFor(it.code);
            if (point == null) {
              return null;
            }

            final isActive = activeLocation?.code == it.code;
            final size = isActive ? const Size.square(32) : const Size.square(12);

            return Marker(
              point: point,
              height: size.height,
              width: size.width,
              child: InkWell(
                onTap: () => onLocationPressedRef.value?.call(it, point),
                child: LocationMarker(
                  size: size,
                  txt: it.code,
                  isActive: isActive,
                ),
              ),
            );
          })
          .nonNulls
          .toList();
    },
    [onLocationPressedRef, latLngStore, locations, activeLocation],
  );
}
