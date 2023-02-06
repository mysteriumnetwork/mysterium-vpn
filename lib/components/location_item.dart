import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/components/svg_icon_button.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:styled_widget/styled_widget.dart';

class LocationItem extends StatelessWidget {
  const LocationItem({Key? key, required this.location, required this.onPressed}) : super(key: key);

  final Location location;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          SvgIcon(asset: getCountryFlag(location.name)).padding(right: 20),
          EasyText(
            location.name,
            fontWeight: FontWeight.w700,
          ),
          const Spacer(),
          SvgIconButton(onPressed: onPressed, asset: Assets.next),
        ],
      ).padding(horizontal: 20),
    ).paddingDirectional(bottom: 10);
  }
}
