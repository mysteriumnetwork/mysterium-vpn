import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/shared/components/banners/banner.dart';
import 'package:mysterium_vpn/shared/components/easy_text.dart';
import 'package:mysterium_vpn/shared/components/svg_icon.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';

class BannerTitle extends HookWidget {
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
