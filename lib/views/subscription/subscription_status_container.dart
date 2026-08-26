import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn/stores/subscription_purchase_store.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

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

    // Fire on mount (fireImmediately) AND on every false→true auth flip,
    // so a logout/login cycle while the container stays mounted (IndexedStack)
    // still re-runs the check. Guarded by hasShownExistingSubscriptionDialog.
    final authSessionStore = ref.watch(authSessionStorePOD);
    useReaction<bool>(() => authSessionStore.isAuthenticated, (isAuthed) {
      if (isAuthed) {
        _checkForExistingSubscription(subscriptionStore, context, ref);
      }
    }, fireImmediately: true);

    return Observer(
      builder: (context) {
        final theme = Theme.of(context);
        final storeState = subscriptionStore.storeState;
        final products = plansStore.future.value;

        final isVerifyingPayment = purchaseStore.subscriptionStatus == SubscriptionStatus.verifying;

        final isLoading =
            storeState == StoreState.loading ||
            subscriptionStore.subscriptionFuture.status == FutureStatus.pending ||
            plansStore.future.status == FutureStatus.pending;

        if (isLoading) {
          return Center(
            child: LoadingIndicator.message(
              S.current.connectingToPaymentProcesor,
              color: theme.palette.iconBrandSecondary,
            ),
          );
        } else if (storeState == StoreState.notAvailable || (products?.isEmpty ?? true)) {
          return Center(
            child: RetryOnErrorWidget(
              error: (products?.isEmpty ?? true)
                  ? S.current.productsNotAvailable
                  : S.current.unableToConnectToPaymentProcesor,
              onRetry: refreshAll,
            ),
          );
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
                      S.current.processingPayment,
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
      // Container only surfaces the success snackbar — callers (modals,
      // tab) decide whether to close, navigate, or stay put via their own
      // post-purchase hooks. Beaming to /main from here would tear down the
      // route tree even when the caller is already at /main (Products tab).
      showSnackbar(S.current.subscriptionActive, type: SnackbarType.success);
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
            title: S.current.subscriptionVerificationFailed,
            supportingText: S.current.failedToVerifySubs,
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
              child: Text(S.current.retryBtn),
            ),
            secondaryButton: ButtonSecondary(
              onPressed: () {
                analyticsStore.logEvent(AnalyticsEvent.subscriptionVerificationRetryCancel);
                Navigator.of(context).pop();
              },
              child: Text(S.current.cancelBtn),
            ),
          ),
        ),
      );
    }
  }

  if (status == SubscriptionStatus.canceled) {
    showSnackbar(S.current.subscriptionProcessCanceled);
  }
  if (status == SubscriptionStatus.error) {
    showSnackbar(S.current.failedToSubscribe);
  }

  if (status == SubscriptionStatus.pendingTransaction) {
    showSnackbar(S.current.pendingTransactionMessage);
  }
}

Future<void> _checkForExistingSubscription(
  SubscriptionStore store,
  BuildContext context,
  WidgetRef ref,
) async {
  // Once per session — a new login re-arms via the auth reaction.
  if (store.hasShownExistingSubscriptionDialog) {
    return;
  }
  final email = await store.checkForExistingSubscriber();
  if (email == null) {
    return;
  }

  Future.microtask(() {
    if (!context.mounted) {
      return;
    }
    // Re-check: two containers can observe the same resolved Future and race.
    if (store.hasShownExistingSubscriptionDialog) {
      return;
    }
    store.markExistingSubscriptionDialogShown();
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        constraints: const BoxConstraints(maxWidth: 350),
        child: AlertModal(
          screenType: ScreenType.mobile,
          type: AlertModalType.info,
          title: S.current.existingSubscriptionTitle,
          supportingText: S.current.existingSubscriptionDesc(email),
          primaryButton: ButtonPrimary(
            onPressed: () {
              Navigator.of(context).pop();
              unawaited(
                disconnectAndLogout(
                  vpnStore: ref.read(vpnStorePOD),
                  authStore: ref.read(authStorePOD),
                  analyticsStore: ref.read(analyticsStorePOD),
                ),
              );
            },
            child: Text(S.current.logout),
          ),
          secondaryButton: ButtonSecondary(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(S.current.stayButton),
          ),
        ),
      ),
    );
  });
}
