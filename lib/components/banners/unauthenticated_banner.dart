import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide Banner;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/banners/banner.dart';
import 'package:mysterium_vpn/components/banners/banner_cta.dart';
import 'package:mysterium_vpn/components/banners/banner_title.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';

class UnauthenticatedBanner extends HookWidget {
  const UnauthenticatedBanner({super.key = K.unauthenticatedBanner});

  @override
  Widget build(BuildContext context) {
    void handlePressed() {
      Beamer.of(context).beamToNamed(Routes.platformLogin.path);
    }

    return Banner(
      title: BannerTitle(
        icon: SvgIcon(
          asset: Asset.icons.accountNameDark,
          width: 18,
          height: 18,
        ),
        text: LocaleKeys.unauthenticatedBannerTitle.tr(),
      ),
      cta: BannerCTA(
        text: LocaleKeys.unauthenticatedBannerBtn.tr(),
        onPressed: handlePressed,
      ),
      onPressed: handlePressed,
    );
  }
}
