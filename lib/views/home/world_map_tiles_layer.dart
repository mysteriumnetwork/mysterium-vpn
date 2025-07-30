import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';

class WorldMapTilesLayer extends HookWidget {
  const WorldMapTilesLayer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return TileLayer(
      urlTemplate: switch (theme.brightness) {
        Brightness.dark => 'assets/map_tiles/dark/{z}/{x}/{y}.png',
        Brightness.light => 'assets/map_tiles/light/{z}/{x}/{y}.png',
      },
      tileProvider: AssetTileProvider(),
      minNativeZoom: 3,
      maxNativeZoom: 4,
      tileBounds: kWorldBounds,
    );
  }
}
