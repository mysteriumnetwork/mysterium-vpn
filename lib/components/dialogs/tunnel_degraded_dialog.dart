import 'package:flutter/material.dart';
import 'package:mysterium_vpn/components/dialogs/confirmation_dialog.dart';
import 'package:mysterium_vpn/generated/l10n.dart';

/// Warns that the connected exit may be degraded. Resolves true when the user
/// asks for a refresh.
///
/// Not barrier-dismissible: `onCancel` fires only from the secondary button, so
/// a barrier tap would silently skip the analytics arm.
Future<bool> showTunnelDegradedDialog(BuildContext context, {required bool canRefresh}) async {
  var refresh = false;
  await shownConfirmationDialog(
    context,
    title: S.current.tunnelDegradedTitle,
    supportingText: canRefresh
        ? S.current.tunnelDegradedDesc
        : S.current.tunnelDegradedDescNoRefresh,
    confirmText: canRefresh ? S.current.tunnelDegradedRefresh : S.current.closeBtn,
    cancelText: S.current.closeBtn,
    showCancel: canRefresh,
    dismissible: false,
    onConfirm: () => refresh = canRefresh,
  );

  return refresh;
}
