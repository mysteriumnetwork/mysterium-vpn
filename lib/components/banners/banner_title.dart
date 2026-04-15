import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';

class BannerTitle extends StatelessWidget {
  const BannerTitle({required this.text, this.iconAsset, this.iconSize, this.icon, super.key});

  final String text;
  final SvgGenImage? iconAsset;
  final double? iconSize;
  final Widget? icon;

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    spacing: 6,
    children: [
      if (iconAsset != null)
        SvgIcon(
          asset: iconAsset!,
          width: iconSize,
          height: iconSize,
          color: BannerStyle.of(context).foregroundColor,
        )
      else
        ?icon,
      Flexible(
        child: EasyText(
          text,
          fontWeight: FontWeight.w700,
          fontSize: 14,
          color: BannerStyle.of(context).foregroundColor,
        ),
      ),
    ],
  );
}
