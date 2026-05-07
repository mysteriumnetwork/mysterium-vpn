import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
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
          title: LocaleKeys.logoutConfirmationTitle.tr(),
          supportingText: supportingText ?? LocaleKeys.logoutConfirmationDesc.tr(),
          primaryButton: ButtonSecondary(
            onPressed: () {
              Navigator.pop(context);
              onConfirm();
            },
            child: Text(
              LocaleKeys.logout.tr(),
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
            child: Text(LocaleKeys.cancelBtn.tr()),
          ),
        );
      },
    ),
  ),
);
