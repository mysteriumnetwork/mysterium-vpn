// Flutter imports:
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
// Project imports:

class SvgIconButton extends StatelessWidget {
  const SvgIconButton({Key? key, required this.asset, required this.onPressed}) : super(key: key);

  final String asset;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: SvgIcon(asset: asset),
    );
  }
}
