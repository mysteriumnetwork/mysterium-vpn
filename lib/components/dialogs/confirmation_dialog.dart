import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

Future<void> shownConfirmationDialog(
  BuildContext context, {
  required String title,
  required VoidCallback onConfirm,
  String? supportingText,
  AlertModalType type = AlertModalType.warning,
  bool showIcon = true,
  VoidCallback? onCancel,
  bool dismissible = true,
  bool showCancel = true,
  String? confirmText,
  String? cancelText,
}) => showDialog(
  context: context,
  barrierDismissible: dismissible,
  builder: (context) => Dialog(
    backgroundColor: Colors.transparent,
    elevation: 0,
    constraints: const BoxConstraints(maxWidth: 350),
    child: AlertModal(
      screenType: ScreenType.mobile,
      type: type,
      title: title,
      showIcon: showIcon,
      supportingText: supportingText,
      primaryButton: ButtonPrimary(
        onPressed: () {
          Navigator.pop(context);
          onConfirm();
        },
        child: Text(confirmText ?? LocaleKeys.yes.tr()),
      ),
      secondaryButton: showCancel
          ? ButtonSecondary(
              onPressed: () {
                Navigator.pop(context);
                onCancel?.call();
              },
              child: Text(cancelText ?? LocaleKeys.no.tr()),
            )
          : null,
    ),
  ),
);
