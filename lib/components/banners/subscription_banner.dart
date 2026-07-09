import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
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
        FutureStatus.pending => StateCard(
          icon: UntitledUI.shopping_cart_02,
          message: S.current.checkSubsStatusTitle,
        ),
        FutureStatus.rejected => AlertModal(
          type: AlertModalType.error,
          title: S.current.checkSubsStatusFailedTitle,
          supportingText: S.current.checkSubsStatusFailedDesc,
          primaryButton: ButtonSecondary(
            size: ButtonSize.small,
            onPressed: subscriptionStore.refreshSubscription,
            child: Text(S.current.retryBtn),
          ),
        ),
        FutureStatus.fulfilled => StateCard(
          icon: UntitledUI.shopping_cart_02,
          message: S.current.noSubscriptionTitle,
          actionLabel: S.current.noSubscriptionAction,
          actionKey: K.subscriptionBannerCTA,
          onActionPressed: handleSubscribe,
        ),
      },
    );
  }
}
