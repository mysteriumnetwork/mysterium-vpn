import 'dart:async';

import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:latlong2/latlong.dart';
import 'package:mysterium_vpn/core/constants/constants.dart';
import 'package:mysterium_vpn/core/extensions/extensions.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/home/views/home_state.dart';
import 'package:mysterium_vpn/features/home/views/world_map_tiles_layer.dart';
import 'package:mysterium_vpn/features/locations/views/location_markers_layer.dart';
import 'package:mysterium_vpn/features/remote_config/store/remote_config_store.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class LocationsMap extends StatefulWidget {
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
  State<LocationsMap> createState() => _LocationsMapState();
}

class _LocationsMapState extends State<LocationsMap> {
  final _analyticsStore = getIt<AnalyticsStore>();
  final _remoteConfigStore = getIt<RemoteConfigStore>();
  late final MapController _controller = MapController();
  StreamSubscription<MapEvent>? _mapEventSubscription;

  @override
  void initState() {
    super.initState();
    _mapEventSubscription = _controller.mapEventStream
        .where((it) => it is MapEventMove)
        .cast<MapEventMove>()
        .listen((it) => _analyticsStore.logMapScroll(from: it.oldCamera, to: it.camera));
  }

  @override
  void didUpdateWidget(covariant LocationsMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.position != oldWidget.position && widget.position != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        final center = widget.position;
        if (center == null || center == _controller.camera.center) {
          return;
        }
        _handleMove(center);
      });
    }
  }

  @override
  void dispose() {
    _mapEventSubscription?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _handleMove(LatLng point) {
    final zoom = _controller.camera.zoom;
    var offset = Offset.zero;
    final screenType = ScreenType.of(context);
    if (screenType == ScreenType.mobile) {
      offset = switch (HomeStateScope.read(context).panelState) {
        PanelState.closed => const Offset(0, -100),
        PanelState.snap => const Offset(0, -180),
        PanelState.open => const Offset(0, -180),
      };
    }
    _controller.move(point, zoom, offset: offset);
  }

  void _handlePressed(VPNLocation location, LatLng point) {
    _handleMove(point);
    widget.onLocationPressed?.call(location);
    _analyticsStore.logMapLocationClick(location.id, point);
  }

  void _handleDoubleTapped(VPNLocation location, LatLng point) {
    widget.onLocationDoubleTapped?.call(location);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Observer(
      builder: (context) {
        final mapConfig = _remoteConfigStore.mapConfig;
        final locations =
            widget.locations?.flattenBy((it) => it.children ?? const <VPNLocation>[]).toList() ??
            const <VPNLocation>[];

        return FlutterMap(
          mapController: _controller,
          options: MapOptions(
            initialZoom: mapConfig.initialZoom.toDouble(),
            initialCenter: widget.position ?? const LatLng(0, 0),
            cameraConstraint: CameraConstraint.contain(bounds: kWorldBounds),
            backgroundColor: theme.palette.bgMapBackground,
            minZoom: mapConfig.zoomLevels.min.toDouble(),
            maxZoom: mapConfig.zoomLevels.max.toDouble(),
            onTap: (_, _) => widget.onTapOutside?.call(),
            interactionOptions: const InteractionOptions(
              flags: InteractiveFlag.all & ~InteractiveFlag.rotate,
            ),
          ),
          children: [
            const WorldMapTilesLayer(),
            LocationMarkersLayer(
              locations: locations,
              selectedLocation: widget.selectedLocation,
              connectedLocation: widget.connectedLocation,
              onLocationPressed: _handlePressed,
              onLocationDoubleTapped: widget.onLocationDoubleTapped != null
                  ? _handleDoubleTapped
                  : null,
            ),
          ],
        );
      },
    );
  }
}
