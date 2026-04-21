import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:styled_widget/styled_widget.dart';

Future<bool?> showRequestTunnelPermissionsDialog(BuildContext context) async =>
    showDialog<bool>(context: context, builder: (context) => const _RequestTunnelPermissions());

class _RequestTunnelPermissions extends StatelessWidget {
  const _RequestTunnelPermissions();

  @override
  Widget build(BuildContext context) => Dialog(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
    child: Container(
      constraints: const BoxConstraints(maxWidth: 500),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            LocaleKeys.setupTunnerPermissionsDialogTitle.tr(),

            textAlign: TextAlign.center,
            maxLines: 2,
            style: Theme.of(
              context,
            ).textStyles.textLg.bold.copyWith(color: Theme.of(context).palette.textPrimary),
          ).padding(bottom: 20),
          Text(
            LocaleKeys.setupTunnerPermissionsDialogDesc.tr(),
            style: Theme.of(
              context,
            ).textStyles.textSm.medium.copyWith(color: Theme.of(context).palette.textSecondary),
            textAlign: TextAlign.center,
            maxLines: 4,
          ).padding(bottom: 4),
          Text(
            LocaleKeys.setupTunnerPermissionsDialogDisclaimer.tr(),
            style: Theme.of(
              context,
            ).textStyles.textSm.medium.copyWith(color: Theme.of(context).palette.textTertiary),
            textAlign: TextAlign.center,
            maxLines: 4,
          ).padding(bottom: 40),
          ButtonPrimary(
            child: Text(LocaleKeys.allowPermissionsBtn.tr()),
            onPressed: () => Navigator.pop(context, true),
          ),
        ],
      ).padding(horizontal: 20, vertical: 40),
    ),
  );
}
