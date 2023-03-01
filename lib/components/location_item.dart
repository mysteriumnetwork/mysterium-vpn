import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/connect_button.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/flag.dart';
import 'package:mysterium_vpn/components/ripple.dart';
import 'package:mysterium_vpn/models/location.dart';
import 'package:styled_widget/styled_widget.dart';

class LocationItem extends StatelessWidget {
  const LocationItem({
    required this.location,
    required this.onTap,
    super.key,
  });

  final Location location;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) => RippleWidget(
        onTap: onTap,
        radius: 15,
        child: Row(
          children: [
            Flag(countryCode: location.countryCode).padding(right: 20),
            EasyText(
              location.countryName,
              fontWeight: FontWeight.w700,
            ),
            const Spacer(),
            ConnectButton(
              onPressed: onTap,
              locationCode: location.countryCode,
            ),
          ],
        ).padding(horizontal: 20, vertical: 4),
      )
          .card(
            elevation: 4,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          )
          .paddingDirectional(bottom: 10);
}
