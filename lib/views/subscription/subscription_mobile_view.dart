import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/components/base_layout.dart';
import 'package:mysterium_vpn/components/error_widget.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/subscription/subscription_app_bar.dart';
import 'package:mysterium_vpn/views/subscription/subscription_form.dart';
import 'package:styled_widget/styled_widget.dart';

class SubscriptionMobileView extends ConsumerWidget {
  const SubscriptionMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStore = ref.watch(authStorePOD);
    final subscriptionStore = ref.watch(subscriptionStorePOD);

    return BaseLayout(
      header: SubscriptionAppBar(authStore: authStore),
      child: Observer(
        builder: (context) => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (subscriptionStore.isAvailable == StoreState.loading)
              LoadingIndicator(
                message: LocaleKeys.connectingToPaymentProcesor.tr(),
              )
            else if (subscriptionStore.isAvailable == StoreState.notAvailable)
              RetryOnErrorWidget(
                error: LocaleKeys.unableToConnectToPaymentProcesor.tr(),
                onRetry: subscriptionStore.checkAvailability,
              )
            else
              SubscriptionForm(
                store: subscriptionStore,
              ).expanded()
          ],
        ),
      ),
    );
  }
}
