import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

Future<void> shownNoMailAppDialog(BuildContext context) => showDialog(
  context: context,
  builder: (context) => Dialog(
    backgroundColor: Colors.transparent,
    elevation: 0,
    constraints: const BoxConstraints(maxWidth: 350),
    child: AlertModal(
      screenType: ScreenType.mobile,
      type: AlertModalType.info,
      title: LocaleKeys.openEmailApp.tr(),
      supportingText: LocaleKeys.noEmailApp.tr(),
      primaryButton: ButtonPrimary(
        onPressed: () => Navigator.pop(context),
        child: Text(LocaleKeys.goBackButton.tr()),
      ),
    ),
  ),
);
