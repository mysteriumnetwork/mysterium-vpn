import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_cache/flutter_map_cache.dart';
import 'package:http_cache_file_store/http_cache_file_store.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:path_provider/path_provider.dart';

class WorldMapTilesLayer extends HookWidget {
  const WorldMapTilesLayer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final cacheState = _useCacheStore();
    final cache = cacheState.data;

    if (cache == null) {
      return const SizedBox.shrink();
    }

    return TileLayer(
      urlTemplate: switch (theme.brightness) {
        Brightness.dark => 'https://mysterium-vpn-test.web.app/dark/{z}/{x}/{y}.png',
        Brightness.light => 'https://mysterium-vpn-test.web.app/light/{z}/{x}/{y}.png',
      },
      tileProvider: CachedTileProvider(store: cache, maxStale: const Duration(days: 1)),
      minNativeZoom: 3,
      maxNativeZoom: 4,
      tileBounds: kWorldBounds,
      tileBuilder: (context, widget, image) => ColoredBox(
        color: theme.colorScheme.surface,
        child: Transform.scale(
          scale: 1.005,
          child: widget,
        ),
      ),
    );
  }
}

AsyncSnapshot<FileCacheStore> _useCacheStore() {
  final future = useMemoized(() async {
    final dir = await getApplicationSupportDirectory();
    final path = [dir.path, 'MapTiles'].join(Platform.pathSeparator);
    return FileCacheStore(path);
  });

  return useFuture(future);
}
