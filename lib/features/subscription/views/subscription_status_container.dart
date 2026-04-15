import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/exceptions/exceptions.dart';
import 'package:mysterium_vpn/core/styles/style.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/auth/store/auth_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_plans_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_purchase_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_store.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/shared/components/dialogs/confirmation_dialog.dart';
import 'package:mysterium_vpn/shared/components/dialogs/retry_dialog.dart';
import 'package:mysterium_vpn/shared/components/error_widget.dart';
import 'package:mysterium_vpn/shared/components/loading_barrier.dart';
import 'package:mysterium_vpn/shared/components/loading_indicator.dart';
import 'package:mysterium_vpn/shared/components/svg_icon.dart';
import 'package:styled_widget/styled_widget.dart';

class SubscriptionStatusContainer extends StatefulWidget {
  const SubscriptionStatusContainer({required this.child, super.key});

  final Widget child;

  @override
  State<SubscriptionStatusContainer> createState() => _SubscriptionStatusContainerState();
}

class _SubscriptionStatusContainerState extends State<SubscriptionStatusContainer> {
  final _subscriptionStore = GetIt.I<SubscriptionStore>();
  final _plansStore = GetIt.I<SubscriptionPlansStore>();
  final _purchaseStore = GetIt.I<SubscriptionPurchaseStore>();
  final _analyticsStore = GetIt.I<AnalyticsStore>();

  late final ReactionDisposer _statusReactionDisposer;

  @override
  void initState() {
    super.initState();

    // Ensure plans are loaded on first mount
    Future.microtask(() async {
      if (!mounted) {
        return;
      }
      final products = await _plansStore.future;
      if (products.isEmpty) {
        await _subscriptionStore.refreshSubscriptionConfig();
        await _plansStore.refresh();
      }
    });

    // Check for existing subscription from another account
    Future.microtask(() async {
      if (!mounted) {
        return;
      }
      await _checkForExistingSubscription();
    });

    _statusReactionDisposer = reaction(
      (_) => _subscriptionStore.subscriptionStatus,
      _subscriptionStatusReaction,
    );
  }

  @override
  void dispose() {
    _statusReactionDisposer();
    super.dispose();
  }

  void _subscriptionStatusReaction(SubscriptionStatus? status) {
    if (context.mounted) {
      if (status == SubscriptionStatus.purchased) {
        showSnackbar(LocaleKeys.subscriptionActive.tr(), type: MessageType.success);
        context.beamToReplacementNamed(Routes.main.path);
      } else if (_subscriptionStore.subscriptionConfigFuture.error is ApiException &&
          (_subscriptionStore.subscriptionConfigFuture.error as ApiException).code == 409) {
        showSnackbar((_subscriptionStore.subscriptionConfigFuture.error as ApiException).message);
      } else if (status == SubscriptionStatus.notVerified ||
          status == SubscriptionStatus.verifyingError) {
        showRetryDialog(
          onRetry: () {
            Navigator.of(context).pop();
            _analyticsStore.logEvent(AnalyticsEvent.subscriptionVerificationRetryClick);
            _purchaseStore.retryVerificationProcess();
          },
          context: context,
          asset: Asset.icons.subscription,
          title: LocaleKeys.subscriptionVerificationFailed.tr(),
          subtitle: LocaleKeys.failedToVerifySubs.tr(),
          dismissText: LocaleKeys.cancelBtn.tr(),
          onDismiss: () {
            _analyticsStore.logEvent(AnalyticsEvent.subscriptionVerificationRetryCancel);
            Navigator.of(context).pop();
          },
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

  Future<void> _checkForExistingSubscription() async {
    final email = await _subscriptionStore.refreshOtherSubscriber();
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
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, color: Palette.black),
          maxLines: 2,
          textAlign: TextAlign.center,
        ),
        title: LocaleKeys.existingSubscriptionDesc.tr(namedArgs: {'email': email}),
        onConfirm: () => GetIt.I<AuthStore>().logout(),
      );
    }

    if (mounted) {
      Future.microtask(showDialog);
    }
  }

  Future<void> _refreshAll() async {
    await Future.wait([_subscriptionStore.refreshAll(), _plansStore.refresh()]);
  }

  @override
  Widget build(BuildContext context) => Observer(
    builder: (context) {
      final storeState = _subscriptionStore.storeState;
      final products = _plansStore.future.value;

      final isVerifyingPayment =
          _subscriptionStore.subscriptionStatus == SubscriptionStatus.verifying;
      final barrierContentColor = switch (Theme.of(context).brightness) {
        Brightness.dark => Palette.white,
        Brightness.light => Palette.purple,
      }.withValues(alpha: .8);

      final isLoading =
          storeState == StoreState.loading ||
          _subscriptionStore.subscriptionFuture.status == FutureStatus.pending ||
          _plansStore.future.status == FutureStatus.pending ||
          _subscriptionStore.subscriptionStatus == SubscriptionStatus.pending;

      if (isLoading) {
        return LoadingIndicator(
          message: LocaleKeys.connectingToPaymentProcesor.tr(),
        ).padding(top: 36);
      } else if (storeState == StoreState.notAvailable || (products?.isEmpty ?? true)) {
        return RetryOnErrorWidget(
          error: (products?.isEmpty ?? true)
              ? LocaleKeys.productsNotAvailable.tr()
              : LocaleKeys.unableToConnectToPaymentProcesor.tr(),
          onRetry: _refreshAll,
        ).padding(top: 36);
      }

      return Stack(
        children: [
          widget.child,
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
      );
    },
  );
}
