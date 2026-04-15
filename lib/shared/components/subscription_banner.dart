import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart' hide Banner;
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/core/exceptions/exceptions.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/auth/store/auth_session_store.dart';
import 'package:mysterium_vpn/features/remote_config/store/remote_config_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_purchase_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_store.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn/shared/components/banners/banner.dart';
import 'package:mysterium_vpn/shared/components/banners/banner_body.dart';
import 'package:mysterium_vpn/shared/components/banners/banner_cta.dart';
import 'package:mysterium_vpn/shared/components/banners/banner_title.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class SubscriptionBanner extends StatelessWidget {
  const SubscriptionBanner({super.key = K.subscriptionBanner});

  Future<void> _handleSubscribe(BuildContext context) async {
    final sessionStore = getIt<AuthSessionStore>();
    final subscriptionStore = getIt<SubscriptionStore>();
    final subscriptionPurchaseStore = getIt<SubscriptionPurchaseStore>();
    final remoteConfigStore = getIt<RemoteConfigStore>();

    final accessToken = sessionStore.accessToken;

    try {
      final subscription = await subscriptionStore.subscriptionFuture;
      if (!context.mounted) {
        return;
      }
      await handleOnBillingPage(
        context: context,
        manageSubscriptionPage: remoteConfigStore.manageSubscriptionPage,
        upgradeSubscriptionPage: remoteConfigStore.upgradeSubscriptionPage,
        gateway: subscription.gateway,
        subscriptionActive: subscription.active,
        accessToken: accessToken,
        onManageSubscription: subscriptionPurchaseStore.manageSubscription,
        manageSubscription: false,
      );
    } on SubscriptionRequiredException catch (_) {
      // ignore and let the flow continue
    }
  }

  @override
  Widget build(BuildContext context) {
    final subscriptionStore = getIt<SubscriptionStore>();
    final theme = Theme.of(context);
    return Observer(
      builder: (context) => switch (subscriptionStore.subscriptionFuture.status) {
        FutureStatus.pending => Banner(
          title: BannerTitle(
            icon: const LoadingIndicator(size: 16),
            text: LocaleKeys.checkSubsStatusTitle.tr(),
          ),
          body: BannerBody(text: LocaleKeys.checkSubsStatusDesc.tr()),
        ),
        FutureStatus.rejected => Banner(
          title: BannerTitle(
            iconAsset: Asset.icons.infoOutline,
            text: LocaleKeys.checkSubsStatusFailedTitle.tr(),
          ),
          body: BannerBody(text: LocaleKeys.checkSubsStatusFailedDesc.tr()),
          cta: BannerCTA(
            text: LocaleKeys.retryBtn.tr(),
            onPressed: subscriptionStore.refreshSubscription,
          ),
          onPressed: subscriptionStore.refreshSubscription,
          style: theme.brightness == Brightness.dark
              ? BannerStyle.warningDark
              : BannerStyle.warningLight,
        ),
        FutureStatus.fulfilled => Banner(
          title: BannerTitle(text: LocaleKeys.noSubscriptionTitle.tr()),
          cta: BannerCTA(
            key: K.subscriptionBannerCTA,
            text: LocaleKeys.noSubscriptionAction.tr(),
            onPressed: () => _handleSubscribe(context),
          ),
          onPressed: () => _handleSubscribe(context),
        ),
      },
    );
  }
}
