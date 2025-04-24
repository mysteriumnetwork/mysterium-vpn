import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/components/banners/banner.dart';
import 'package:mysterium_vpn/components/easy_text.dart';

class BannerTitle extends HookWidget {
  const BannerTitle({
    required this.text,
    this.icon,
    super.key,
  });

  final String text;
  final Widget? icon;

  @override
  Widget build(BuildContext context) => Row(
        mainAxisSize: MainAxisSize.min,
        spacing: 6,
        children: [
          if (icon != null) icon!,
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
