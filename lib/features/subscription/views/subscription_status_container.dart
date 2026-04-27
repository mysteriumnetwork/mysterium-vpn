import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/exceptions/exceptions.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/auth/store/auth_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_plans_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_purchase_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_store.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
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
        showSnackbar(LocaleKeys.subscriptionActive.tr(), type: SnackbarType.success);
        context.beamToReplacementNamed(Routes.main.path);
      } else if (_subscriptionStore.subscriptionConfigFuture.error is ApiException &&
          (_subscriptionStore.subscriptionConfigFuture.error as ApiException).code == 409) {
        showSnackbar((_subscriptionStore.subscriptionConfigFuture.error as ApiException).message);
      } else if (status == SubscriptionStatus.notVerified ||
          status == SubscriptionStatus.verifyingError) {
        showModal(
          context,
          builder: (context) => AlertModal(
            type: AlertModalType.error,
            title: LocaleKeys.subscriptionVerificationFailed.tr(),
            supportingText: LocaleKeys.failedToVerifySubs.tr(),
            onClose: () {
              _analyticsStore.logEvent(AnalyticsEvent.subscriptionVerificationRetryCancel);
              Navigator.of(context).pop();
            },
            primaryButton: ButtonPrimary(
              onPressed: () {
                Navigator.of(context).pop();
                _analyticsStore.logEvent(AnalyticsEvent.subscriptionVerificationRetryClick);
                _purchaseStore.retryVerificationProcess();
              },
              child: Text(LocaleKeys.retryBtn.tr()),
            ),
            secondaryButton: ButtonSecondary(
              onPressed: () {
                _analyticsStore.logEvent(AnalyticsEvent.subscriptionVerificationRetryCancel);
                Navigator.of(context).pop();
              },
              child: Text(LocaleKeys.cancelBtn.tr()),
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

  Future<void> _checkForExistingSubscription() async {
    final email = await _subscriptionStore.refreshOtherSubscriber();
    if (email == null) {
      return;
    }

    void showExistingSubscriptionDialog() {
      showModal(
        context,
        allowDismiss: false,
        builder: (context) => Padding(
          padding: EdgeInsets.symmetric(horizontal: Theme.of(context).spacing.xl3),
          child: AlertModal(
            type: AlertModalType.warning,
            title: LocaleKeys.existingSubscriptionTitle.tr(),
            supportingText: LocaleKeys.existingSubscriptionDesc.tr(namedArgs: {'email': email}),
            primaryButton: ButtonPrimary(
              onPressed: () {
                Navigator.of(context).pop();
                GetIt.I<AuthStore>().logout();
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

    if (mounted) {
      Future.microtask(showExistingSubscriptionDialog);
    }
  }

  Future<void> _refreshAll() async {
    await Future.wait([_subscriptionStore.refreshAll(), _plansStore.refresh()]);
  }

  @override
  Widget build(BuildContext context) => Observer(
    builder: (context) {
      final theme = Theme.of(context);
      final storeState = _subscriptionStore.storeState;
      final products = _plansStore.future.value;

      final isVerifyingPayment =
          _subscriptionStore.subscriptionStatus == SubscriptionStatus.verifying;

      final isLoading =
          storeState == StoreState.loading ||
          _subscriptionStore.subscriptionFuture.status == FutureStatus.pending ||
          _plansStore.future.status == FutureStatus.pending ||
          _subscriptionStore.subscriptionStatus == SubscriptionStatus.pending;

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
          onRetry: _refreshAll,
        ).center();
      }

      return Stack(
        children: [
          widget.child,
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
      );
    },
  );
}
