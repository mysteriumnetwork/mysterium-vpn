import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/components/base_app_bar.dart';
import 'package:mysterium_vpn/components/base_layout.dart';
import 'package:mysterium_vpn/components/dialogs/dismiss_page_dialog.dart';
import 'package:mysterium_vpn/components/error_widget.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/service_providers.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/subscription/subscription_form.dart';

class SubscriptionMobileView extends HookConsumerWidget {
  const SubscriptionMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStore = ref.watch(authStorePOD);
    final subscriptionStore = ref.watch(subscriptionStorePOD);
    final localDb = ref.watch(localDBPOD);
    final analyticsStore = ref.read(analyticsStorePOD);

    useEffect(
      () {
        subscriptionStore.getSubscriptionsConfig();
        return null;
      },
      [],
    );
    return Observer(
      builder: (context) => PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) async {
          if (subscriptionStore.isSubscribed == false) {
            analyticsStore.logEvent(AnalyticsEvent.paymentExitPopup);
            final shouldPop = await shownDismissPageDialog(context);
            if (shouldPop ?? false) {
              analyticsStore.logEvent(AnalyticsEvent.paymentExitConfirm);
              authStore.logout();
            } else {
              analyticsStore.logEvent(AnalyticsEvent.paymentExitCancel);
            }
          } else {
            analyticsStore.logEvent(AnalyticsEvent.backButtonClick);
            Beamer.of(context).beamBack();
          }
        },
        child: BaseLayout(
          header: const BaseAppBar(),
          child: Observer(
            builder: (context) => subscriptionStore.isAvailable == StoreState.loading
                ? LoadingIndicator(
                    message: LocaleKeys.connectingToPaymentProcesor.tr(),
                  )
                : subscriptionStore.isAvailable == StoreState.notAvailable
                    ? RetryOnErrorWidget(
                        error: LocaleKeys.unableToConnectToPaymentProcesor.tr(),
                        onRetry: subscriptionStore.getSubscriptionsConfig,
                      )
                    : SubscriptionForm(
                        store: subscriptionStore,
                        localDb: localDb,
                        analyticsStore: analyticsStore,
                      ),
          ),
        ),
      ),
    );
  }
}
