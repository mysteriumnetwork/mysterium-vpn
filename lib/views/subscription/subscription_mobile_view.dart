import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/common/extensions/enum.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/base_app_bar.dart';
import 'package:mysterium_vpn/components/base_layout.dart';
import 'package:mysterium_vpn/components/dialogs/confirmation_dialog.dart';
import 'package:mysterium_vpn/components/dialogs/dismiss_page_dialog.dart';
import 'package:mysterium_vpn/components/dialogs/retry_dialog.dart';
import 'package:mysterium_vpn/components/error_widget.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/service_providers.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/subscription_store.dart';
import 'package:mysterium_vpn/views/subscription/widgets/subscription_variants_container.dart';

class SubscriptionMobileView extends HookConsumerWidget {
  const SubscriptionMobileView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStore = ref.watch(authStorePOD);
    final subscriptionStore = ref.watch(subscriptionStorePOD);
    final localDb = ref.watch(localDBPOD);
    final analyticsStore = ref.read(analyticsStorePOD);
    final abTestingStore = ref.read(abTestingStorePOD);
    useEffect(
      () {
        subscriptionStore.getSubscriptionsConfig();
        checkForExistingSubscription(subscriptionStore, context, ref);
        return null;
      },
      [],
    );
    return Observer(
      builder: (_) => PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) async {
          if (didPop) {
            return;
          }
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
          header: BaseAppBar(
            showBackButton: subscriptionStore.subscriptonStatus != SubscriptionStatus.verifying,
          ),
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
                    : subscriptionStore.products.isEmpty
                        ? RetryOnErrorWidget(
                            error: LocaleKeys.productsNotAvailable.tr(),
                            onRetry: subscriptionStore.getSubscriptionsConfig,
                          )
                        : ReactionBuilder(
                            builder: (context) =>
                                reaction((_) => subscriptionStore.subscriptonStatus, (status) {
                              subscriptionStatusReaction(context, status, subscriptionStore);
                            }),
                            child: SubscriptionFormVariantContainer(
                              subscriptionStore: subscriptionStore,
                              localDb: localDb,
                              analyticsStore: analyticsStore,
                              subscribeToPackage: (String selectedProductId) => subscribeToPackage(
                                analyticsStore,
                                subscriptionStore,
                                subscriptionStore.products.map((e) => e.id).toList(),
                                selectedProductId,
                              ),
                              variant: abTestingStore.subscriptionFlowVariant,
                            ),
                          ),
          ),
        ),
      ),
    );
  }

  void subscriptionStatusReaction(
    BuildContext context,
    SubscriptionStatus? status,
    SubscriptionStore store,
  ) {
    if (context.mounted) {
      if (status == SubscriptionStatus.purchased) {
        showSnackbar(
          LocaleKeys.subscriptionActive.tr(),
          type: MessageType.success,
        );
        context.beamToReplacementNamed(Routes.main.toRoute);
      } else if (store.verifySubscriptionFuture?.error is ApiException &&
          (store.verifySubscriptionFuture?.error as ApiException).code == 409) {
        showSnackbar(
          (store.verifySubscriptionFuture?.error as ApiException).message,
        );
      } else if (status == SubscriptionStatus.notVerified ||
          status == SubscriptionStatus.verifyingError) {
        shownRetryDialog(
          onRetry: () async => store.retryVerificationProcess(),
          context: context,
          asset: Assets.subscription,
          title: LocaleKeys.subscriptionVerificationFailed.tr(),
          subtitle: LocaleKeys.failedToVerifySubs.tr(),
          dismissText: LocaleKeys.cancelBtn.tr(),
          onDismiss: () async => Navigator.of(context).pop(),
        );
      }
    }

    if (status == SubscriptionStatus.canceled) {
      showSnackbar(LocaleKeys.subscriptionProcessCanceled.tr());
    }
    if (status == SubscriptionStatus.error) {
      showSnackbar(
        LocaleKeys.failedToSubscribe.tr(),
      );
    }
  }

  Future<void> checkForExistingSubscription(
    SubscriptionStore store,
    BuildContext context,
    WidgetRef ref,
  ) async {
    final (exists, email) = await store.checkForExistingSubscription();
    if (!exists) {
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      shownConfirmationDialog(
        context,
        confirmText: LocaleKeys.logout.tr(),
        cancelText: LocaleKeys.stayButton.tr(),
        dismissible: false,
        icon: const SvgIcon(
          asset: Assets.warning,
        ),
        content: Text(
          LocaleKeys.existingSubscriptionTitle.tr(),
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w500,
            color: Palette.black,
          ),
          maxLines: 2,
          textAlign: TextAlign.center,
        ),
        title: LocaleKeys.existingSubscriptionDesc.tr(namedArgs: {'email': email ?? ''}),
        onConfirm: () => ref.read(authStorePOD).logout(email: email),
      );
    });
  }

  Future<void> subscribeToPackage(
    AnalyticsStore analyticsStore,
    SubscriptionStore store,
    List<String> productIds,
    String selectedProductId,
  ) async {
    final selectedProduct = store.products.firstWhere((element) => element.id == selectedProductId);
    analyticsStore.logEvent(
      AnalyticsEvent.subscriptionNew,
      parameters: {
        'item_ids': productIds,
      },
    );

    store.subscribeToPackage(product: selectedProduct.productDetails);
  }
}
