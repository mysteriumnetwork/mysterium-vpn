import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide Banner;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/banners/banner.dart';
import 'package:mysterium_vpn/components/banners/banner_body.dart';
import 'package:mysterium_vpn/components/banners/banner_cta.dart';
import 'package:mysterium_vpn/components/banners/banner_title.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

class SubscriptionBanner extends HookConsumerWidget {
  const SubscriptionBanner({super.key = K.subscriptionBanner});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final handleSubscribe = useHandleSubscribe();
    final subscriptionStore = ref.watch(subscriptionStorePOD);
    return Observer(
      builder: (context) => switch (subscriptionStore.subscriptionFuture.status) {
        FutureStatus.pending => Banner(
            title: BannerTitle(
              icon: const LoadingIndicator(
                radius: 16,
              ),
              text: LocaleKeys.checkSubsStatusTitle.tr(),
            ),
            body: BannerBody(
              text: LocaleKeys.checkSubsStatusDesc.tr(),
            ),
          ),
        FutureStatus.rejected => Banner(
            title: BannerTitle(
              iconAsset: Asset.icons.infoOutline,
              text: LocaleKeys.checkSubsStatusFailedTitle.tr(),
            ),
            body: BannerBody(
              text: LocaleKeys.checkSubsStatusFailedDesc.tr(),
            ),
            cta: BannerCTA(
              text: LocaleKeys.retryBtn.tr(),
              onPressed: subscriptionStore.refreshSubscription,
            ),
            onPressed: subscriptionStore.refreshSubscription,
            style: context.c.isDarkMode ? BannerStyle.warningDark : BannerStyle.warningLight,
          ),
        FutureStatus.fulfilled => Banner(
            title: BannerTitle(text: LocaleKeys.noSubscriptionTitle.tr()),
            cta: BannerCTA(
              key: K.subscriptionBannerCTA,
              text: LocaleKeys.noSubscriptionAction.tr(),
              onPressed: handleSubscribe,
            ),
            onPressed: handleSubscribe,
          )
      },
    );
  }
}
