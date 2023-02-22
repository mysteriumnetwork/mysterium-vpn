// Flutter imports:
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
// Project imports:

class SvgIconButton extends StatelessWidget {
  const SvgIconButton({
    required this.asset,
    required this.onPressed,
    super.key,
  });

  final String asset;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) => IconButton(
        onPressed: onPressed,
        icon: SvgIcon(asset: asset),
      );
}
