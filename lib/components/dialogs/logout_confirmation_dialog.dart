import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

Future<void> showLogoutConfirmationDialog(
  BuildContext context, {
  required VoidCallback onConfirm,
  VoidCallback? onCancel,
  String? supportingText,
}) => showDialog(
  context: context,
  builder: (context) => Dialog(
    backgroundColor: Colors.transparent,
    elevation: 0,
    constraints: const BoxConstraints(maxWidth: 350),
    child: Builder(
      builder: (context) {
        final theme = Theme.of(context);
        return AlertModal(
          screenType: ScreenType.mobile,
          showIcon: false,
          title: S.current.logoutConfirmationTitle,
          supportingText: supportingText ?? S.current.logoutConfirmationDesc,
          primaryButton: ButtonSecondary(
            key: K.logoutConfirmButton,
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: Text(
              S.current.logout,
              style: theme.textStyles.textSm.semibold.copyWith(
                color: theme.palette.textErrorPrimary,
              ),
            ),
          ),
          secondaryButton: ButtonSecondary(
            onPressed: () {
              Navigator.pop(context);
              onCancel?.call();
            },
            child: Text(S.current.cancelBtn),
          ),
        );
      },
    ),
  ),
);
