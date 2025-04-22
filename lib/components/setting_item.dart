import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:styled_widget/styled_widget.dart';

class SettingItem extends StatelessWidget {
  const SettingItem({
    required this.asset,
    required this.actionWidget,
    required this.title,
    this.description,
    this.subtitle,
    super.key,
  });

  final String asset;
  final String title;
  final Widget actionWidget;
  final Widget? description;
  final Widget? subtitle;
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.brightness == Brightness.dark
              ? Palette.mediumBlack
              : const Color(0xFFF5F3FD),
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgIcon(asset: asset).paddingDirectional(end: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                description ??
                    EasyText(
                      title,
                    ),
                if (subtitle != null) subtitle!.padding(top: 4),
                const SizedBox(height: 8),
                actionWidget,
              ],
            ).expanded(),
          ],
        ),
      ).paddingDirectional(bottom: 10, horizontal: 20);
}
