import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/core/constants/constants.dart';
import 'package:mysterium_vpn/features/remote_config/store/remote_config_store.dart';
import 'package:mysterium_vpn/service_locator.dart';

class WorldMapTilesLayer extends StatelessWidget {
  const WorldMapTilesLayer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final remoteConfig = getIt<RemoteConfigStore>();

    return Observer(
      builder: (context) {
        final mapConfig = remoteConfig.mapConfig;
        final brightnessName = theme.brightness.name;
        final url =
            mapConfig.tileUrlTemplates['$brightnessName-new'] ??
            mapConfig.tileUrlTemplates[brightnessName];
        final cacheProvider = BuiltInMapCachingProvider.getOrCreateInstance();
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
      },
    );
  }
}
