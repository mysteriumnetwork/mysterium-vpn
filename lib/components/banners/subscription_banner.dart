import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class SubscriptionBanner extends HookConsumerWidget {
  const SubscriptionBanner({super.key = K.subscriptionBanner});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final handleSubscribe = useHandleSubscribe();
    final subscriptionStore = ref.watch(subscriptionStorePOD);

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
            onPressed: handleSubscribe,
            child: Text(LocaleKeys.noSubscriptionAction.tr()),
          ),
        ),
      },
    );
  }
}
