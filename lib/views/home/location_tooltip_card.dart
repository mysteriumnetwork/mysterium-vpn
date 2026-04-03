import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/extensions/vpn_location.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class LocationTooltipCard extends StatelessWidget {
  const LocationTooltipCard({required this.location, required this.connectedLocation, super.key});

  final VPNLocation location;
  final VPNLocation? connectedLocation;

  @override
  Widget build(BuildContext context) {
    final locationName = location.getName(context);
    if (location.id == connectedLocation?.id) {
      return const SizedBox.shrink();
    }
    final theme = Theme.of(context);
    final borderColor = theme.colorScheme.outlineVariant;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        IntrinsicWidth(
          child: Card(
            shadowColor: borderColor,
            elevation: 2,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(8),
              side: BorderSide(color: borderColor, width: 1.5),
            ),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Text(
                LocaleKeys.connectToTooltip.tr(namedArgs: {'countryNum': locationName}),
                style: theme.textStyles.textSm.regular.copyWith(color: theme.palette.textPrimary),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
        ),
        const SizedBox(height: 25),
      ],
    );
  }
}
