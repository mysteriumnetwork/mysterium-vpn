import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/flag.dart';
import 'package:mysterium_vpn/components/svg_icon_button.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:styled_widget/styled_widget.dart';

class LocationItem extends StatelessWidget {
  const LocationItem({Key? key, required this.location, required this.onTap}) : super(key: key);

  final Location location;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
      clipBehavior: Clip.hardEdge,
      child: InkWell(
        onTap: onTap,
        child: Row(
          children: [
            Flag(country: location.name).padding(right: 20),
            EasyText(
              location.name,
              fontWeight: FontWeight.w700,
            ),
            const Spacer(),
            SvgIconButton(onPressed: onTap, asset: Assets.next),
          ],
        ).padding(horizontal: 20, vertical: 4),
      ),
    )
        .card(
          elevation: 4,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15.0)),
        )
        .paddingDirectional(bottom: 10);
  }
}
