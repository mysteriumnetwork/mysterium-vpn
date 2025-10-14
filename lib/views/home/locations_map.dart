import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/extensions/vpn_location.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/hooks/map_controller_hook.dart';
import 'package:mysterium_vpn/common/hooks/responsive_value_hook.dart';
import 'package:mysterium_vpn/components/location_marker.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/home/home_state.dart';
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
    final analyticsStore = ref.watch(analyticsStorePOD);
    final theme = Theme.of(context);
    final controller = useMapController();
    final screenType = useScreenType();

    void handleMove(LatLng point) {
      final zoom = controller.camera.zoom;
      var offset = Offset.zero;
      if (screenType == ScreenType.mobile) {
        offset = switch (ref.read(homeStateProvider).panelState) {
          PanelState.closed => Offset.zero,
          PanelState.snap => const Offset(0, -100),
          PanelState.open => const Offset(0, -120),
        };
      }
      controller.move(point, zoom, offset: offset);
    }

    void handlePressed(VPNLocation location, LatLng point) {
      handleMove(point);
      onLocationPressed?.call(location);
      analyticsStore.logMapLocationClick(location.id, point);
    }

    final locations = useMemoized(
      () =>
          this.locations?.flattenBy((it) => it.children ?? const <VPNLocation>[]).toList() ??
          const <VPNLocation>[],
      [this.locations],
    );

    final markers = _useLocationMarkers(
      data: locations,
      activeLocation: activeLocation,
      onLocationPressed: handlePressed,
    );

    useValueChanged<LatLng?, void>(position, (_, __) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final center = position;
        if (center == null || center == controller.camera.center) {
          return;
        }

        handleMove(center);
      });
    });

    useEffect(
      () => controller.mapEventStream
          .where((it) => it is MapEventMove)
          .cast<MapEventMove>()
          .listen(
            (it) => ref.read(analyticsStorePOD).logMapScroll(from: it.oldCamera, to: it.camera),
          )
          .cancel,
      [controller],
    );

    return FlutterMap(
      mapController: controller,
      options: MapOptions(
        initialZoom: kTileZoomLevels.max,
        initialCenter: position ?? const LatLng(0, 0),
        cameraConstraint: CameraConstraint.contain(bounds: kWorldBounds),
        backgroundColor: theme.colorScheme.surface,
        minZoom: kMapZoomLevels.min,
        maxZoom: kMapZoomLevels.max,
        onTap: (_, __) => onTapOutside?.call(),
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        ),
      ),
      children: [
        const WorldMapTilesLayer(),
        MarkerLayer(markers: markers),
      ],
    );
  }
}

List<Marker> _useLocationMarkers({
  required List<VPNLocation> data,
  required VPNLocation? activeLocation,
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
        ...countries.where((it) => it.id != activeLocation?.id),
        ...countries.where((it) => it.id == activeLocation?.id),
      };

      return sorted
          .map((it) {
            final point = it.isCountry
                ? latLngStore.coordinatesForCountry(it.countryCode)
                : latLngStore.coordinatesForCity(it);

            if (point == null) {
              return null;
            }

            final isActive = activeLocation?.id == it.id;
            final size = isActive ? const Size.square(56) : const Size.square(32);

            return Marker(
              point: point,
              height: size.height,
              width: size.width,
              child: _GestureHandler(
                onPressed: () => onLocationPressedRef.value?.call(it, point),
                child: LocationMarker(size: size * .7, isActive: isActive),
              ),
            );
          })
          .nonNulls
          .toList();
    },
    [onLocationPressedRef, latLngStore, data, activeLocation?.id],
  );
}

class _GestureHandler extends StatelessWidget {
  const _GestureHandler({
    required this.onPressed,
    required this.child,
  });

  final Widget child;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Stack(
        children: [
          Center(child: child),
          Positioned.fill(
            child: Material(
              type: MaterialType.transparency,
              shape: const CircleBorder(),
              color: Colors.transparent,
              shadowColor: Colors.transparent,
              surfaceTintColor: Colors.transparent,
              child: InkWell(
                onTap: () {
                  HapticFeedback.lightImpact();
                  onPressed();
                },
                customBorder: const CircleBorder(),
              ),
            ),
          ),
        ],
      );
}
