import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

void showSnackbar(String message, {SnackbarType type = SnackbarType.error, Widget? action}) {
  final snackBar = SnackBar(
    elevation: 0,
    backgroundColor: Colors.transparent,
    padding: EdgeInsets.zero,
    behavior: SnackBarBehavior.floating,
    duration: action != null ? const Duration(seconds: 10) : const Duration(seconds: 4),
    content: Snackbar(message: message, type: type, action: action),
  );

  snackbarKey.currentState
    ?..clearSnackBars()
    ..showSnackBar(snackBar);
}

void showError(Object? error) {
  showSnackbar(error?.toString() ?? S.current.somethingWentWrong);
}
