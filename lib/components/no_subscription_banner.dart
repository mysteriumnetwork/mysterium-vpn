import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide Banner;
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/components/banners/banner.dart';
import 'package:mysterium_vpn/components/banners/banner_cta.dart';
import 'package:mysterium_vpn/components/banners/banner_title.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';

class NoSubscriptionBanner extends HookWidget {
  const NoSubscriptionBanner({super.key});

  @override
  Widget build(BuildContext context) {
    final handleSubscribe = useHandleSubscribe();

    return Banner(
      title: BannerTitle(text: LocaleKeys.noSubscriptionTitle.tr()),
      cta: BannerCTA(text: LocaleKeys.noSubscriptionAction.tr(), onPressed: handleSubscribe),
      onPressed: handleSubscribe,
    );
  }
}
