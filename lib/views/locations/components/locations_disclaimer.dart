import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide Banner;
import 'package:mysterium_vpn/components/banners/banner.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';

class LocationsDisclaimer extends StatelessWidget {
  const LocationsDisclaimer({
    required this.text,
    super.key,
  });

  factory LocationsDisclaimer.residential() =>
      LocationsDisclaimer(text: LocaleKeys.ipTypeResidentialDisclaimer.tr());

  factory LocationsDisclaimer.dataCenter() =>
      LocationsDisclaimer(text: LocaleKeys.ipTypeDataCenterDisclaimer.tr());

  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Banner(
      color: theme.colorScheme.surfaceContainerHigh,
      borderRadius: BorderRadius.circular(12),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      title: SizedBox(
        width: double.infinity,
        child: EasyText(
          text,
          fontSize: 12,
          maxLines: 2,
          textAlign: TextAlign.left,
        ),
      ),
    );
  }
}
