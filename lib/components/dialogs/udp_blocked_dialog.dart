import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/dialogs/confirmation_dialog.dart';
import 'package:mysterium_vpn/generated/l10n.dart';

/// Offers a move to OpenVPN after UDP was found blocked on the current
/// network. Resolves true when the user accepts the switch.
Future<bool> showUdpBlockedDialog(BuildContext context) async {
  var switched = false;
  await shownConfirmationDialog(
    context,
    title: S.current.udpBlockedTitle,
    supportingText: S.current.udpBlockedDesc,
    confirmText: S.current.udpBlockedConfirm,
    cancelText: S.current.notNowBtn,
    onConfirm: () => switched = true,
  );
  return switched;
}
