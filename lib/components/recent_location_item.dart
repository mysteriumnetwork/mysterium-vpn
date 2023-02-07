import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/components/svg_icon_button.dart';
import 'package:mysterium_vpn/models/recent_location.dart';
import 'package:styled_widget/styled_widget.dart';

class RecentLocationItem extends StatelessWidget {
  const RecentLocationItem({Key? key, required this.location, required this.onPressed})
      : super(key: key);

  final RecentLocation location;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SvgIcon(asset: getCountryFlag(location.name)),
              SvgIconButton(onPressed: onPressed, asset: Assets.next),
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
      ).padding(horizontal: 12),
    ).paddingDirectional(end: 15);
  }
}
