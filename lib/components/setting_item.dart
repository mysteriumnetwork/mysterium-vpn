import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
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

  final SvgGenImage asset;
  final String title;
  final Widget actionWidget;
  final Widget? description;
  final Widget? subtitle;

  @override
  Widget build(BuildContext context) => Container(
    width: double.infinity,
    padding: const EdgeInsets.all(20),
    decoration: BoxDecoration(
      color: context.c.isDarkMode ? Palette.darkIndigo : const Color(0xFFF5F3FD),
      borderRadius: const BorderRadius.all(Radius.circular(20)),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SvgIcon(asset: asset).paddingDirectional(end: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            description ?? EasyText(title, fontWeight: FontWeight.w700, fontSize: 14),
            if (subtitle != null) subtitle!.padding(top: 4),
            const SizedBox(height: 8),
            actionWidget,
          ],
        ).expanded(),
      ],
    ),
  ).paddingDirectional(bottom: 10, horizontal: 20);
}
