import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class UnauthenticatedBanner extends HookWidget {
  const UnauthenticatedBanner({super.key = K.unauthenticatedBanner});

  @override
  Widget build(BuildContext context) {
    void handlePressed() {
      Beamer.of(context).beamToNamed(Routes.platformLogin.path);
    }

    return AlertModal(
      type: AlertModalType.info,
      title: LocaleKeys.unauthenticatedBannerTitle.tr(),
      primaryButton: ButtonPrimary(
        size: ButtonSize.small,
        onPressed: handlePressed,
        child: Text(LocaleKeys.unauthenticatedBannerBtn.tr()),
      ),
    );
  }
}
