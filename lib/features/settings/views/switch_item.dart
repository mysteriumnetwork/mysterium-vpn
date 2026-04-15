import 'package:flutter/material.dart';
import 'package:mysterium_vpn/core/styles/style.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/shared/components/easy_text.dart';
import 'package:mysterium_vpn/shared/components/svg_icon.dart';
import 'package:styled_widget/styled_widget.dart';

class SwitchItem extends StatelessWidget {
  const SwitchItem({
    required this.asset,
    required this.title,
    required this.subtitle,
    required this.actionWidget,
    this.enabled = true,
    super.key,
  });

  final SvgGenImage asset;
  final String title;
  final String subtitle;
  final Widget actionWidget;
  final bool enabled;

  @override
  Widget build(BuildContext context) => IgnorePointer(
    ignoring: !enabled,
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: context.c.isDarkMode ? Palette.darkIndigo : Palette.grayContainer,
        borderRadius: const BorderRadius.all(Radius.circular(20)),
      ),
      child: Opacity(
        opacity: enabled ? 1 : 0.5,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgIcon(asset: asset).paddingDirectional(end: 20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                EasyText(
                  title,
                  fontSize: 14,
                  maxLines: 2,
                  fontWeight: FontWeight.w700,
                ).padding(bottom: 4),
                EasyText(subtitle, fontSize: 12, maxLines: 3).padding(bottom: 4),
              ],
            ).expanded(),
            actionWidget,
          ],
        ),
      ),
    ).paddingDirectional(bottom: 10, horizontal: 20),
  );
}
