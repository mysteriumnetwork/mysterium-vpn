import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/dialogs/confirmation_dialog.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';

Future<bool?> showRequestTunnelPermissionsDialog(BuildContext context) async {
  var granted = false;
  await shownConfirmationDialog(
    context,
    title: LocaleKeys.setupTunnerPermissionsDialogTitle.tr(),
    supportingText:
        '${LocaleKeys.setupTunnerPermissionsDialogDesc.tr()}\n\n'
        '${LocaleKeys.setupTunnerPermissionsDialogDisclaimer.tr()}',
    showIcon: false,
    showCancel: false,
    confirmText: LocaleKeys.allowBtn.tr(),
    onConfirm: () => granted = true,
  );
  return granted;
}
