// Flutter imports:
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
// Project imports:

class SvgIconButton extends StatelessWidget {
  const SvgIconButton({
    required this.asset,
    required this.onPressed,
    this.size,
    this.color,
    this.visualDensity,
    this.tapTargetSize,
    super.key,
  });

  final SvgGenImage asset;
  final VoidCallback? onPressed;

  final double? size;
  final Color? color;
  final VisualDensity? visualDensity;
  final MaterialTapTargetSize? tapTargetSize;

  @override
  Widget build(BuildContext context) => IconButton(
    visualDensity: visualDensity,
    style: IconButton.styleFrom(
      backgroundColor: Colors.transparent,
      padding: EdgeInsets.zero,
      tapTargetSize: tapTargetSize,
    ),
    onPressed: onPressed,
    icon: SvgIcon(asset: asset, width: size, height: size, color: color),
  );
}
