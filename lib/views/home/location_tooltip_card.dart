import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/extensions/vpn_location.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/models.dart';

class LocationTooltipCard extends StatelessWidget {
  const LocationTooltipCard({
    required this.location,
    super.key,
  });

  final VPNLocation location;

  @override
  Widget build(BuildContext context) {
    final locationName = location.getName(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IntrinsicWidth(
          child: Card(
            shadowColor: const Color(0xFFD5D7DA),
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: const BorderSide(
                color: Color(0xFFD5D7DA),
                width: 1.5,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                LocaleKeys.connectToTooltip.tr(namedArgs: {'countryNum': locationName}),
                style: const TextStyle(
                  fontSize: 12,
                  color: Palette.black,
                ),
                maxLines: 1,
              ),
            ),
          ),
        ),
        const SizedBox(height: 25),
      ],
    );
  }
}
