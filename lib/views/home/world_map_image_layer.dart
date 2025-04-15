import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';

class WorldMapImageLayer extends StatelessWidget {
  const WorldMapImageLayer({super.key});
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final image = switch (theme.brightness) {
      Brightness.dark => Assets.mapDark,
      Brightness.light => Assets.mapLight,
    };

    return OverlayImageLayer(
      overlayImages: [
        OverlayImage(
          imageProvider: AssetImage(image),
          bounds: kWorldBounds,
        ),
      ],
    );
  }
}
