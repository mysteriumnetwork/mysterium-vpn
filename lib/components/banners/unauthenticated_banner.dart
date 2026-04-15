import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide Banner;
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';

class UnauthenticatedBanner extends StatelessWidget {
  const UnauthenticatedBanner({super.key = K.unauthenticatedBanner});

  @override
  Widget build(BuildContext context) {
    void handlePressed() {
      Beamer.of(context).beamToNamed(Routes.platformLogin.path);
    }

    return Banner(
      title: BannerTitle(
        icon: SvgIcon(asset: Asset.icons.accountNameDark, width: 18, height: 18),
        text: LocaleKeys.unauthenticatedBannerTitle.tr(),
      ),
      cta: BannerCTA(text: LocaleKeys.unauthenticatedBannerBtn.tr(), onPressed: handlePressed),
      onPressed: handlePressed,
    );
  }
}
