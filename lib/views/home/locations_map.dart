import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/hooks/map_controller_hook.dart';
import 'package:mysterium_vpn/components/location_marker.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/views/home/world_map_tiles_layer.dart';

class LocationsMap extends HookConsumerWidget {
  const LocationsMap({
    super.key,
    this.locations,
    this.position,
    this.connectedLocation,
  });

  final List<VPNLocation>? locations;
  final LatLng? position;
  final VPNLocation? connectedLocation;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    const zoom = 4.0;
    final pixelRatio = MediaQuery.of(context).devicePixelRatio;
    final theme = Theme.of(context);
    final controller = useMapController();

    useValueChanged<LatLng?, void>(position, (_, __) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final center = position;
        if (center == null || center == controller.camera.center) {
          return;
        }

        controller.move(center, controller.camera.zoom);
      });
    });

    final markers = useMemoized<List<Marker>>(
      () {
        if (locations == null) {
          return [];
        }

        return locations!
            .map((it) {
              final point = it.coordinates;
              if (point == null) {
                return null;
              }
              final isActive = connectedLocation?.code == it.code;
              final size = isActive ? const Size.square(32) : const Size.square(12);
              return Marker(
                point: point,
                height: size.height,
                width: size.width,
                child: LocationMarker(
                  size: size,
                  txt: it.code,
                  isActive: isActive,
                ),
              );
            })
            .nonNulls
            .toList();
      },
      [locations, pixelRatio, connectedLocation],
    );

    return FlutterMap(
      mapController: controller,
      options: MapOptions(
        initialZoom: zoom,
        initialCenter: position ?? const LatLng(0, 0),
        cameraConstraint: CameraConstraint.contain(bounds: kWorldBounds),
        backgroundColor: theme.colorScheme.surface,
        minZoom: zoom,
        maxZoom: zoom,
      ),
      children: [
        const WorldMapTilesLayer(),
        MarkerLayer(markers: markers),
      ],
    );
  }
}
