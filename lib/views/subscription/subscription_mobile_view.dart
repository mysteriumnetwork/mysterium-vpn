import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/components/base_app_bar.dart';
import 'package:mysterium_vpn/components/base_layout.dart';
import 'package:mysterium_vpn/components/error_widget.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/service_providers.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/subscription/subscription_form.dart';

class SubscriptionMobileView extends ConsumerWidget {
  const SubscriptionMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStore = ref.watch(authStorePOD);
    final subscriptionStore = ref.watch(subscriptionStorePOD);
    final localDb = ref.watch(localDBPOD);
    return BaseLayout(
      header: Observer(
        builder: (context) => BaseAppBar(
          authStore: authStore,
          onBackButtonPressed:
              subscriptionStore.isSubscribed == false ? authStore.logout : context.beamBack,
        ),
      ),
      child: Observer(
        builder: (context) {
          if (subscriptionStore.isAvailable == StoreState.loading) {
            return LoadingIndicator(
              message: LocaleKeys.connectingToPaymentProcesor.tr(),
            );
          } else if (subscriptionStore.isAvailable == StoreState.notAvailable) {
            return RetryOnErrorWidget(
              error: LocaleKeys.unableToConnectToPaymentProcesor.tr(),
              onRetry: subscriptionStore.getSubscriptionsConfig,
            );
          } else {
            return SubscriptionForm(
              store: subscriptionStore,
              localDb: localDb,
            );
          }
        },
      ),
    );
  }
}
