// Flutter imports:
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
// Project imports:

class SvgIcon extends StatelessWidget {
  const SvgIcon({
    required this.asset,
    super.key,
    this.width,
    this.height,
    this.color,
  });

  final SvgGenImage asset;
  final double? width;
  final double? height;
  final Color? color;

  @override
  Widget build(BuildContext context) => Directionality(
        textDirection: TextDirection.ltr,
        child: Center(
          child: asset.svg(
            width: width,
            height: height,
            colorFilter: color != null ? ColorFilter.mode(color!, BlendMode.srcIn) : null,
            matchTextDirection: true,
          ),
        ),
      );
}
