// Flutter imports:
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
// Project imports:

class SvgIconButton extends StatelessWidget {
  const SvgIconButton({
    required this.asset,
    required this.onPressed,
    super.key,
  });

  final SvgGenImage asset;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) => IconButton(
        style: IconButton.styleFrom(
          backgroundColor: Colors.transparent,
          padding: EdgeInsets.zero,
        ),
        onPressed: onPressed,
        icon: SvgIcon(asset: asset),
      );
}
