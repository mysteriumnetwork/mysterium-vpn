import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/extensions/asset.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/views/locations/components/locations_refresh_button.dart';

class LocationItemEmpty extends StatelessWidget {
  const LocationItemEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RawMaterialButton(
      fillColor: theme.colorScheme.primaryContainer,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      hoverElevation: 0,
      onPressed: null,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: 20,
          children: [
            Container(
              width: 30,
              height: 30,
              alignment: Alignment.centerRight,
              child: SvgIcon(
                height: 30,
                width: 30,
                asset: Asset.icons.fix(context),
              ),
            ),
            Expanded(
              child: EasyText(
                LocaleKeys.noServersAvailable.tr(),
                fontSize: 14,
                fontWeight: FontWeight.w500,
                maxLines: 2,
              ),
            ),
            LocationsRefreshButton(
              minimumSize: const Size(100, 38),
              borderRadius: BorderRadius.circular(10),
              outlinedButton: true,
            ),
          ],
        ),
      ),
    );
  }
}
