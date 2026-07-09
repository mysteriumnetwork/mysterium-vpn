import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/extensions/asset.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/views/locations/components/locations_refresh_button.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class LocationItemEmpty extends StatelessWidget {
  const LocationItemEmpty({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return RawMaterialButton(
      fillColor: theme.palette.bgPrimary,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      elevation: 0,
      focusElevation: 0,
      highlightElevation: 0,
      hoverElevation: 0,
      onPressed: null,
      child: Padding(
        padding: EdgeInsets.all(theme.spacing.ms),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          spacing: theme.spacing.xl,
          children: [
            Container(
              width: 30,
              height: 30,
              alignment: Alignment.centerRight,
              child: SvgIcon(height: 30, width: 30, asset: Asset.icons.fix(context)),
            ),
            Expanded(
              child: Text(
                S.current.noServersAvailable,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: theme.textStyles.textSm.medium,
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
