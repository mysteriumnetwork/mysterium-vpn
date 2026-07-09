import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/dialogs/confirmation_dialog.dart';
import 'package:mysterium_vpn/generated/l10n.dart';

Future<bool?> showRequestTunnelPermissionsDialog(BuildContext context) async {
  var granted = false;
  await shownConfirmationDialog(
    context,
    title: S.current.setupTunnerPermissionsDialogTitle,
    supportingText:
        '${S.current.setupTunnerPermissionsDialogDesc}\n\n'
        '${S.current.setupTunnerPermissionsDialogDisclaimer}',
    showIcon: false,
    showCancel: false,
    confirmText: S.current.allowBtn,
    onConfirm: () => granted = true,
  );
  return granted;
}
