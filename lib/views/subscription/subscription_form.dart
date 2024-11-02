import 'dart:io';

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
import 'package:mysterium_vpn/components/dialogs/confirmation_dialog.dart';
import 'package:mysterium_vpn/components/dialogs/retry_dialog.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/error_widget.dart';
import 'package:mysterium_vpn/components/loading_barrier.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/services/data/local/local_db_service.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/subscription_store.dart';
import 'package:mysterium_vpn/views/consent/agreements.dart';
import 'package:mysterium_vpn/views/subscription/product_list.dart';
import 'package:mysterium_vpn/views/subscription/subscription_button.dart';
import 'package:styled_widget/styled_widget.dart';

enum SubscriptionFormStatus {
  freeTrial,
  expired,
  manage,
}

class SubscriptionForm extends HookConsumerWidget {
  const SubscriptionForm({
    required this.store,
    required this.localDb,
    required this.analyticsStore,
    super.key,
  });
  final SubscriptionStore store;
  final LocalDBService localDb;
  final AnalyticsStore analyticsStore;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subsFormStatus = useMemoized(
      () => getSubscriptionFormStatus(
        active: store.subscription?.active ?? false,
        purchaseProductId: store.purchasedProductId,
      ),
      [store.subscription?.active],
    );

    useEffect(
      () {
        checkForExistingSubscription(store, context, ref);
        return null;
      },
      [],
    );

    return Observer(
      builder: (context) => Stack(
        children: [
          Column(
            children: [
              EasyText(
                LocaleKeys.selectPackage.tr(),
                fontSize: 20,
                fontWeight: FontWeight.w900,
              ),
              SizedBox(height: getMediaHeight(context) * 0.015),
              if (store.products.isEmpty)
                RetryOnErrorWidget(
                  error: LocaleKeys.productsNotAvailable.tr(),
                  onRetry: store.getSubscriptionsConfig,
                )
              else
                SubscriptionProductsList(
                  products: store.products,
                ).padding(bottom: getMediaHeight(context) * 0.02),
              EasyText(
                subsFormStatus == SubscriptionFormStatus.manage
                    ? LocaleKeys.manageSubsTittle.tr()
                    : subsFormStatus == SubscriptionFormStatus.expired
                        ? LocaleKeys.subsExpiredTittle.tr()
                        : LocaleKeys.freeTrialTitle.tr(),
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ).padding(bottom: getMediaHeight(context) * 0.005),
              EasyText(
                subsFormStatus == SubscriptionFormStatus.manage
                    ? LocaleKeys.manageSubsDesc.tr()
                    : subsFormStatus == SubscriptionFormStatus.expired
                        ? LocaleKeys.subsExpiredDesc.tr()
                        : LocaleKeys.freeTrialDesc.tr(),
                maxLines: 3,
                fontSize: 14,
                textAlign: TextAlign.center,
              ).padding(bottom: getMediaHeight(context) * 0.025),
              ReactionBuilder(
                builder: (context) => reaction((_) => store.subscriptonStatus, (status) {
                  subscriptionStatusReaction(context, status);
                }),
                child: SubscriptionButton(
                  onPressed: (status) =>
                      subscribeToPackage(status, store.products.map((e) => e.id).toList()),
                  isLoading: store.subscriptonStatus == SubscriptionStatus.verifying,
                  subsFormStatus: subsFormStatus,
                  selectedProductId: store.selectedProductId,
                  purchasedProductId: store.purchasedProductId,
                ),
              ),
              Visibility(
                visible: Platform.isIOS,
                child: TextButton(
                  onPressed: () {
                    analyticsStore.logEvent(AnalyticsEvent.redeemOpen);
                    store.redeemCode();
                  },
                  child: const EasyText(
                    'Redeem Code',
                    color: Palette.purple,
                  ),
                ).padding(top: 10),
              ),
              SizedBox(height: getMediaHeight(context) * 0.025),
              Agreements(
                analyticsStore: analyticsStore,
              ),
              SizedBox(height: getMediaHeight(context) * 0.025),
            ],
          ).scrollable().padding(horizontal: 20),
          if (store.subscriptonStatus == SubscriptionStatus.verifying)
            LoadingBarrier(
              color: Palette.darkBlue,
              child: Center(
                child: LoadingIndicator(
                  radius: 50,
                  strokeWidth: 3,
                  message: LocaleKeys.processingPayment.tr(),
                  messageColor: Palette.black,
                )
                    .decorated(
                      color: Palette.white,
                      borderRadius: BorderRadius.circular(10),
                    )
                    .padding(all: 20)
                    .constrained(width: getMediaWidth(context) * 0.8, height: 200),
              ),
            ),
        ],
      ),
    );
  }

  void subscriptionStatusReaction(BuildContext context, SubscriptionStatus? status) {
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

  SubscriptionFormStatus getSubscriptionFormStatus({
    required String? purchaseProductId,
    required bool active,
  }) {
    if (purchaseProductId != null && purchaseProductId.isNotEmpty) {
      return active ? SubscriptionFormStatus.manage : SubscriptionFormStatus.expired;
    }
    return SubscriptionFormStatus.freeTrial;
  }

  Future<void> subscribeToPackage(
    SubscriptionFormStatus subsFormStatus,
    List<String> productIds,
  ) async {
    if (subsFormStatus == SubscriptionFormStatus.expired) {
      analyticsStore.logEvent(AnalyticsEvent.subscriptionRenew);
    } else if (subsFormStatus == SubscriptionFormStatus.manage) {
      store.selectedProductId == store.purchasedProductId
          ? analyticsStore.logEvent(AnalyticsEvent.subscriptionManage)
          : analyticsStore.logEvent(AnalyticsEvent.subscriptionChange);
    } else {
      analyticsStore.logEvent(
        AnalyticsEvent.subscriptionNew,
        parameters: {
          'item_ids': productIds,
        },
      );
    }
    store.subscribeToPackage();
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
}
