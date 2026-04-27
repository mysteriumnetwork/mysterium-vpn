import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/subscription/pages/subscription_upgrade_modal_page.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_store.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class SubscriptionBanner extends StatelessWidget {
  const SubscriptionBanner({super.key = K.subscriptionBanner});

  @override
  Widget build(BuildContext context) {
    final subscriptionStore = getIt<SubscriptionStore>();

    return Observer(
      builder: (context) => switch (subscriptionStore.subscriptionFuture.status) {
        FutureStatus.pending => AlertModal(
          type: AlertModalType.info,
          title: LocaleKeys.checkSubsStatusTitle.tr(),
          supportingText: LocaleKeys.checkSubsStatusDesc.tr(),
        ),
        FutureStatus.rejected => AlertModal(
          type: AlertModalType.error,
          title: LocaleKeys.checkSubsStatusFailedTitle.tr(),
          supportingText: LocaleKeys.checkSubsStatusFailedDesc.tr(),
          primaryButton: ButtonPrimary(
            size: ButtonSize.small,
            onPressed: subscriptionStore.refreshSubscription,
            child: Text(LocaleKeys.retryBtn.tr()),
          ),
        ),
        FutureStatus.fulfilled => AlertModal(
          type: AlertModalType.warning,
          title: LocaleKeys.noSubscriptionTitle.tr(),
          primaryButton: ButtonPrimary(
            key: K.subscriptionBannerCTA,
            size: ButtonSize.small,
            onPressed: () => showSubscriptionUpgradeModalPage(context),
            child: Text(LocaleKeys.noSubscriptionAction.tr()),
          ),
        ),
      },
    );
  }
}
