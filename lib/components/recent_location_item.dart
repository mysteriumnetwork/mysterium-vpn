import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/flag.dart';
import 'package:mysterium_vpn/components/svg_icon_button.dart';
import 'package:mysterium_vpn/models/recent_location.dart';
import 'package:styled_widget/styled_widget.dart';

class RecentLocationItem extends StatelessWidget {
  const RecentLocationItem({
    required this.location,
    required this.onTap,
    super.key,
  });

  final RecentLocation location;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => Material(
        color: Colors.transparent,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        clipBehavior: Clip.hardEdge,
        child: InkWell(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flag(country: location.name),
                  SvgIconButton(onPressed: onTap, asset: Assets.next),
                ],
              ),
              EasyText(
                location.name,
                fontWeight: FontWeight.w700,
              ),
              EasyText(
                location.duration.toHoursMinutes(),
              ),
            ],
          ).padding(horizontal: 12).width(100),
        ),
      )
          .card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          )
          .paddingDirectional(end: 10);
}
