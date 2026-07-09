import 'package:flutter/material.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
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
  ButtonVariant confirmVariant = ButtonVariant.primary,
}) => showDialog(
  context: context,
  barrierDismissible: dismissible,
  builder: (context) {
    void handleConfirm() {
      Navigator.pop(context);
      onConfirm();
    }

    final confirmLabel = Text(confirmText ?? S.current.yes);
    final confirmButton = switch (confirmVariant) {
      ButtonVariant.primary => ButtonPrimary(onPressed: handleConfirm, child: confirmLabel),
      ButtonVariant.secondary => ButtonSecondary(onPressed: handleConfirm, child: confirmLabel),
      ButtonVariant.tertiary => ButtonTertiary(onPressed: handleConfirm, child: confirmLabel),
    };

    return Dialog(
      backgroundColor: Colors.transparent,
      elevation: 0,
      constraints: const BoxConstraints(maxWidth: 350),
      child: AlertModal(
        screenType: ScreenType.mobile,
        type: type,
        title: title,
        showIcon: showIcon,
        supportingText: supportingText,
        primaryButton: confirmButton,
        secondaryButton: showCancel
            ? ButtonSecondary(
                onPressed: () {
                  Navigator.pop(context);
                  onCancel?.call();
                },
                child: Text(cancelText ?? S.current.no),
              )
            : null,
      ),
    );
  },
);
