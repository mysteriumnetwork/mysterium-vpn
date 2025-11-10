import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/dialogs/confirmation_dialog.dart';
import 'package:mysterium_vpn/components/dialogs/retry_dialog.dart';
import 'package:mysterium_vpn/components/error_widget.dart';
import 'package:mysterium_vpn/components/loading_barrier.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:styled_widget/styled_widget.dart';

class SubscriptionStatusContainer extends HookConsumerWidget {
  const SubscriptionStatusContainer({
    required this.child,
    super.key,
  });

  final Widget child;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionStore = ref.watch(subscriptionStorePOD);
    final products = useComputedValue(() => subscriptionStore.productsFuture.value);

    useEffect(
      () {
        if (products == null) {
          return;
        }
        if (products.isEmpty) {
          Future.microtask(() async {
            await subscriptionStore.refreshSubscriptionConfig();
            await subscriptionStore.refreshProducts();
          });
        }
        return null;
      },
      [products, subscriptionStore],
    );

    useEffect(
      () {
        _checkForExistingSubscription(subscriptionStore, context, ref);
        return null;
      },
      [ref, subscriptionStore, context],
    );

    return Observer(
      builder: (context) {
        final storeState = subscriptionStore.storeState;
        final products = subscriptionStore.productsFuture.value;

        final isVerifyingPayment =
            subscriptionStore.subscriptionStatus == SubscriptionStatus.verifying;
        final barrierContentColor =
            (context.c.isDarkMode ? Palette.white : Palette.purple).withValues(alpha: 0.8);

        final isLoading = storeState == StoreState.loading ||
            subscriptionStore.subscriptionFuture.status == FutureStatus.pending ||
            subscriptionStore.productsFuture.status == FutureStatus.pending;

        if (isLoading) {
          return LoadingIndicator(
            message: LocaleKeys.connectingToPaymentProcesor.tr(),
          ).padding(top: 36);
        } else if (storeState == StoreState.notAvailable || (products?.isEmpty ?? true)) {
          return RetryOnErrorWidget(
            error: (products?.isEmpty ?? true)
                ? LocaleKeys.productsNotAvailable.tr()
                : LocaleKeys.unableToConnectToPaymentProcesor.tr(),
            onRetry: subscriptionStore.refreshAll,
          ).padding(top: 36);
        }
        return ReactionBuilder(
          builder: (context) => reaction((_) => subscriptionStore.subscriptionStatus, (status) {
            _subscriptionStatusReaction(context, status, subscriptionStore);
          }),
          child: Stack(
            children: [
              child,
              if (isVerifyingPayment)
                Positioned.fill(
                  child: LoadingBarrier(
                    color: Theme.of(context).primaryColor,
                    child: LoadingIndicator(
                      radius: 30,
                      message: LocaleKeys.processingPayment.tr(),
                      messageColor: barrierContentColor,
                      indicatorColor: barrierContentColor,
                    ).padding(horizontal: 16),
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
) {
  if (context.mounted) {
    if (status == SubscriptionStatus.purchased) {
      showSnackbar(
        LocaleKeys.subscriptionActive.tr(),
        type: MessageType.success,
      );
      context.beamToReplacementNamed(Routes.main.path);
    } else if (store.subscriptionConfigFuture.error is ApiException &&
        (store.subscriptionConfigFuture.error as ApiException).code == 409) {
      showSnackbar(
        (store.subscriptionConfigFuture.error as ApiException).message,
      );
    } else if (status == SubscriptionStatus.notVerified ||
        status == SubscriptionStatus.verifyingError) {
      showRetryDialog(
        onRetry: (_) {
          Navigator.of(context).pop();
          store.retryVerificationProcess();
        },
        context: context,
        asset: Asset.icons.subscription,
        title: LocaleKeys.subscriptionVerificationFailed.tr(),
        subtitle: LocaleKeys.failedToVerifySubs.tr(),
        dismissText: LocaleKeys.cancelBtn.tr(),
        onDismiss: (context) => Navigator.of(context).pop(),
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

  if (status == SubscriptionStatus.pendingTransaction) {
    showSnackbar(
      LocaleKeys.pendingTransactionMessage.tr(),
    );
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

  void showDialog() {
    shownConfirmationDialog(
      context,
      confirmText: LocaleKeys.logout.tr(),
      cancelText: LocaleKeys.stayButton.tr(),
      dismissible: false,
      icon: SvgIcon(asset: Asset.icons.warning),
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
      title: LocaleKeys.existingSubscriptionDesc.tr(namedArgs: {'email': email}),
      onConfirm: () => ref.read(authStorePOD).logout(),
    );
  }

  Future.microtask(showDialog);
}
