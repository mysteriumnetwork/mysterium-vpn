import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

class WorldMapTilesLayer extends HookConsumerWidget {
  const WorldMapTilesLayer({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);
    final remoteConfig = ref.watch(remoteConfigStorePOD);
    final mapConfig = useComputedValue(() => remoteConfig.mapConfig);
    final brightnessName = theme.brightness.name;
    final url =
        mapConfig.tileUrlTemplates['$brightnessName-new'] ??
        mapConfig.tileUrlTemplates[brightnessName];
    final cacheProvider = useMemoized(BuiltInMapCachingProvider.getOrCreateInstance);
    return Stack(
      children: [
        // fallback, local tiles layer
        TileLayer(
          urlTemplate: 'assets/map_tiles/$brightnessName/{z}/{x}/{y}.png',
          tileProvider: AssetTileProvider(),
          minNativeZoom: 3,
          maxNativeZoom: 4,
          tileBounds: kWorldBounds,
        ),
        if (url != null)
          TileLayer(
            urlTemplate: url,
            tileProvider: NetworkTileProvider(cachingProvider: cacheProvider),
            minNativeZoom: mapConfig.tileZoomLevels.min.toInt(),
            maxNativeZoom: mapConfig.tileZoomLevels.max.toInt(),
            minZoom: mapConfig.zoomLevels.min.toDouble(),
            maxZoom: mapConfig.zoomLevels.max.toDouble(),
            tileBounds: kWorldBounds,
          ),
      ],
    );
  }
}
