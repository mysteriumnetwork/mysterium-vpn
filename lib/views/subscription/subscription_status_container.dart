import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/exceptions/exceptions.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/dialogs/confirmation_dialog.dart';
import 'package:mysterium_vpn/components/dialogs/retry_dialog.dart';
import 'package:mysterium_vpn/components/error_widget.dart';
import 'package:mysterium_vpn/components/loading_barrier.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/subscription_store.dart';
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

    useEffect(
      () {
        if (subscriptionStore.products.isEmpty) {
          subscriptionStore.getSubscriptionsConfig();
        }
        _checkForExistingSubscription(subscriptionStore, context, ref);
        return null;
      },
      [],
    );

    return Observer(
      builder: (context) {
        final isVerifyingPayment =
            subscriptionStore.subscriptonStatus == SubscriptionStatus.verifying;
        if (subscriptionStore.isAvailable == StoreState.loading) {
          return LoadingIndicator(
            message: LocaleKeys.connectingToPaymentProcesor.tr(),
          );
        } else if (subscriptionStore.isAvailable == StoreState.notAvailable ||
            subscriptionStore.products.isEmpty) {
          return RetryOnErrorWidget(
            error: subscriptionStore.isAvailable == StoreState.loading
                ? LocaleKeys.unableToConnectToPaymentProcesor.tr()
                : LocaleKeys.productsNotAvailable.tr(),
            onRetry: subscriptionStore.getSubscriptionsConfig,
          );
        }
        return ReactionBuilder(
          builder: (context) => reaction((_) => subscriptionStore.subscriptonStatus, (status) {
            _subscriptionStatusReaction(context, status, subscriptionStore);
          }),
          child: Stack(
            children: [
              child,
              if (isVerifyingPayment)
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
  final (exists, email) = await store.checkForExistingSubscription();
  if (!exists) {
    return;
  }

  void showDialog() {
    shownConfirmationDialog(
      context,
      confirmText: LocaleKeys.logout.tr(),
      cancelText: LocaleKeys.stayButton.tr(),
      dismissible: false,
      icon: const SvgIcon(asset: Assets.warning),
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
  }

  Future.microtask(showDialog);
}
