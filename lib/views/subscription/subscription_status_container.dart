import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/stores/subscription_purchase_store.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:styled_widget/styled_widget.dart';

class SubscriptionStatusContainer extends HookConsumerWidget {
  const SubscriptionStatusContainer({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionStore = ref.watch(subscriptionStorePOD);
    final plansStore = ref.watch(subscriptionPlansStorePOD);
    final purchaseStore = ref.watch(subscriptionPurchaseStorePOD);
    final analyticsStore = ref.watch(analyticsStorePOD);

    Future<void> refreshAll() async {
      await Future.wait([subscriptionStore.refreshAll(), plansStore.refresh()]);
    }

    useEffect(() {
      final ref = ProviderScope.containerOf(context, listen: false);
      final plansStore = ref.read(subscriptionPlansStorePOD);
      final subscriptionStore = ref.read(subscriptionStorePOD);
      Future.microtask(() async {
        final products = await plansStore.future;
        if (products.isEmpty) {
          await subscriptionStore.refreshSubscriptionConfig();
          await plansStore.refresh();
        }
      });

      return null;
    }, []);

    useEffect(() {
      _checkForExistingSubscription(subscriptionStore, context, ref);
      return null;
    }, [ref, subscriptionStore, context]);

    return Observer(
      builder: (context) {
        final theme = Theme.of(context);
        final storeState = subscriptionStore.storeState;
        final products = plansStore.future.value;

        final isVerifyingPayment = purchaseStore.subscriptionStatus == SubscriptionStatus.verifying;

        final isLoading =
            storeState == StoreState.loading ||
            subscriptionStore.subscriptionFuture.status == FutureStatus.pending ||
            plansStore.future.status == FutureStatus.pending ||
            purchaseStore.subscriptionStatus == SubscriptionStatus.pending;

        if (isLoading) {
          return LoadingIndicator.message(
            LocaleKeys.connectingToPaymentProcesor.tr(),
            color: theme.palette.iconBrandSecondary,
          ).center();
        } else if (storeState == StoreState.notAvailable || (products?.isEmpty ?? true)) {
          return RetryOnErrorWidget(
            error: (products?.isEmpty ?? true)
                ? LocaleKeys.productsNotAvailable.tr()
                : LocaleKeys.unableToConnectToPaymentProcesor.tr(),
            onRetry: refreshAll,
          ).center();
        }
        return ReactionBuilder(
          builder: (context) => reaction((_) => purchaseStore.subscriptionStatus, (status) {
            _subscriptionStatusReaction(
              context,
              status,
              subscriptionStore,
              purchaseStore,
              analyticsStore,
            );
          }),
          child: Stack(
            children: [
              child,
              if (isVerifyingPayment)
                LoadingBarrier(
                  color: theme.palette.bgPopover,
                  child: Center(
                    child: LoadingIndicator.message(
                      LocaleKeys.processingPayment.tr(),
                      color: theme.palette.iconBrandSecondary,
                      style: theme.textStyles.textMd.regular.copyWith(
                        color: theme.palette.iconBrandSecondary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

void _subscriptionStatusReaction(
  BuildContext context,
  SubscriptionStatus? status,
  SubscriptionStore store,
  SubscriptionPurchaseStore purchaseStore,
  AnalyticsStore analyticsStore,
) {
  if (context.mounted) {
    if (status == SubscriptionStatus.purchased) {
      showSnackbar(LocaleKeys.subscriptionActive.tr(), type: SnackbarType.success);
      context.beamToReplacementNamed(Routes.main.path);
    } else if (store.subscriptionConfigFuture.error is ApiException &&
        (store.subscriptionConfigFuture.error as ApiException).code == 409) {
      showSnackbar((store.subscriptionConfigFuture.error as ApiException).message);
    } else if (status == SubscriptionStatus.notVerified ||
        status == SubscriptionStatus.verifyingError) {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => Dialog(
          backgroundColor: Colors.transparent,
          elevation: 0,
          constraints: const BoxConstraints(maxWidth: 350),
          child: AlertModal(
            type: AlertModalType.error,
            title: LocaleKeys.subscriptionVerificationFailed.tr(),
            supportingText: LocaleKeys.failedToVerifySubs.tr(),
            onClose: () {
              analyticsStore.logEvent(AnalyticsEvent.subscriptionVerificationRetryCancel);
              Navigator.of(context).pop();
            },
            primaryButton: ButtonPrimary(
              onPressed: () {
                Navigator.of(context).pop();
                analyticsStore.logEvent(AnalyticsEvent.subscriptionVerificationRetryClick);
                purchaseStore.retryVerificationProcess();
              },
              child: Text(LocaleKeys.retryBtn.tr()),
            ),
            secondaryButton: ButtonSecondary(
              onPressed: () {
                analyticsStore.logEvent(AnalyticsEvent.subscriptionVerificationRetryCancel);
                Navigator.of(context).pop();
              },
              child: Text(LocaleKeys.cancelBtn.tr()),
            ),
          ),
        ),
      );
    }
  }

  if (status == SubscriptionStatus.canceled) {
    showSnackbar(LocaleKeys.subscriptionProcessCanceled.tr());
  }
  if (status == SubscriptionStatus.error) {
    showSnackbar(LocaleKeys.failedToSubscribe.tr());
  }

  if (status == SubscriptionStatus.pendingTransaction) {
    showSnackbar(LocaleKeys.pendingTransactionMessage.tr());
  }
}

Future<void> _checkForExistingSubscription(
  SubscriptionStore store,
  BuildContext context,
  WidgetRef ref,
) async {
  final email = await store.refreshOtherSubscriber();
  if (email == null) {
    return;
  }

  void showExistingSubscriptionDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        constraints: const BoxConstraints(maxWidth: 350),
        child: AlertModal(
          screenType: ScreenType.mobile,
          type: AlertModalType.error,
          title: LocaleKeys.existingSubscriptionTitle.tr(),
          supportingText: LocaleKeys.existingSubscriptionDesc.tr(namedArgs: {'email': email}),
          primaryButton: ButtonPrimary(
            onPressed: () {
              Navigator.of(context).pop();
              ref.read(authStorePOD).logout();
            },
            child: Text(LocaleKeys.logout.tr()),
          ),
          secondaryButton: ButtonSecondary(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(LocaleKeys.stayButton.tr()),
          ),
        ),
      ),
    );
  }

  Future.microtask(showExistingSubscriptionDialog);
}
