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
    required this.subtitle,
    super.key,
  });

  final String asset;
  final String title;
  final String subtitle;
  final Widget actionWidget;
  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.all(
            Radius.circular(20),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SvgIcon(asset: asset).padding(right: 20),
            LayoutBuilder(
              builder: (_, constraints) => constraints.maxWidth > 500
                  ? Wrap(
                      alignment: WrapAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            EasyText(title, fontSize: 14).padding(bottom: 8),
                            EasyText(
                              subtitle,
                              color: Palette.lightBlack,
                            ).padding(bottom: 11),
                          ],
                        ),
                        actionWidget
                      ],
                    )
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        EasyText(title, fontSize: 14).padding(bottom: 8),
                        EasyText(
                          subtitle,
                          color: Palette.lightBlack,
                        ).padding(bottom: 11),
                        actionWidget
                      ],
                    ),
            ).expanded(),
          ],
        ),
      ).paddingDirectional(bottom: 10, horizontal: 20);
}
