import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:latlong2/latlong.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/hooks/map_controller_hook.dart';
import 'package:mysterium_vpn/common/hooks/responsive_value_hook.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/home/home_state.dart';
import 'package:mysterium_vpn/views/home/world_map_tiles_layer.dart';
import 'package:mysterium_vpn/views/locations/location_markers_layer.dart';

class LocationsMap extends HookConsumerWidget {
  const LocationsMap({
    super.key,
    this.locations,
    this.selectedLocation,
    this.connectedLocation,
    this.position,
    this.onLocationPressed,
    this.onLocationDoubleTapped,
    this.onTapOutside,
  });

  final List<VPNLocation>? locations;
  final VPNLocation? selectedLocation;
  final VPNLocation? connectedLocation;
  final LatLng? position;
  final Function(VPNLocation location)? onLocationPressed;
  final Function(VPNLocation location)? onLocationDoubleTapped;
  final VoidCallback? onTapOutside;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsStore = ref.watch(analyticsStorePOD);
    final remoteConfigStore = ref.watch(remoteConfigStorePOD);
    final theme = Theme.of(context);
    final controller = useMapController();
    final screenType = useScreenType();
    final mapConfig = useComputedValue(() => remoteConfigStore.mapConfig);

    void handleMove(LatLng point) {
      final zoom = controller.camera.zoom;
      var offset = Offset.zero;
      if (screenType == ScreenType.mobile) {
        offset = switch (ref.read(homeStateProvider).panelState) {
          PanelState.closed => const Offset(0, -100),
          PanelState.snap => const Offset(0, -180),
          PanelState.open => const Offset(0, -180),
        };
      }
      controller.move(point, zoom, offset: offset);
    }

    void handlePressed(VPNLocation location, LatLng point) {
      handleMove(point);
      onLocationPressed?.call(location);
      analyticsStore.logMapLocationClick(location.id, point);
    }

    void handleDoubleTapped(VPNLocation location, LatLng point) {
      onLocationDoubleTapped?.call(location);
    }

    final locations = useMemoized(
      () =>
          this.locations?.flattenBy((it) => it.children ?? const <VPNLocation>[]).toList() ??
          const <VPNLocation>[],
      [this.locations],
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
        initialZoom: mapConfig.initialZoom.toDouble(),
        initialCenter: position ?? const LatLng(0, 0),
        cameraConstraint: CameraConstraint.contain(bounds: kWorldBounds),
        backgroundColor: theme.palette.mapBackgroundColor,
        minZoom: mapConfig.zoomLevels.min.toDouble(),
        maxZoom: mapConfig.zoomLevels.max.toDouble(),
        onTap: (_, __) => onTapOutside?.call(),
        interactionOptions: const InteractionOptions(
          flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
        ),
      ),
      children: [
        const WorldMapTilesLayer(),
        LocationMarkersLayer(
          locations: locations,
          selectedLocation: selectedLocation,
          connectedLocation: connectedLocation,
          onLocationPressed: handlePressed,
          onLocationDoubleTapped: onLocationDoubleTapped != null ? handleDoubleTapped : null,
        ),
      ],
    );
  }
}
