import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide Banner;
import 'package:mysterium_vpn/components/banners/banner.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';

class LocationsDCDisclaimer extends StatelessWidget {
  const LocationsDCDisclaimer({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Banner(
      color: theme.colorScheme.surfaceContainerHigh,
      title: EasyText(
        LocaleKeys.locationsDataCenterDisclaimer.tr(),
        fontSize: 12,
        maxLines: 2,
      ),
    );
  }
}
