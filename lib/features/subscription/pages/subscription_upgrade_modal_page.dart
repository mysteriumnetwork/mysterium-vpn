import 'dart:math';

import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/extensions/extensions.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/auth/store/auth_session_store.dart';
import 'package:mysterium_vpn/features/remote_config/store/remote_config_store.dart';
import 'package:mysterium_vpn/features/subscription/pages/subscription_plans_modal_page.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_plans_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_purchase_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_store.dart';
import 'package:mysterium_vpn/features/subscription/views/subscription_status_container.dart';
import 'package:mysterium_vpn/features/subscription/views/widgets/subscription_privacy_and_terms.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart' hide ScreenType;

Future<void> showSubscriptionUpgradeModalPage(BuildContext context) async {
  getIt<AnalyticsStore>().logScreenViewed('subscription_upgrade_modal').ignore();
  final themeData = DesignSystemTheme.of(context);
  await showModal(
    context,
    builder: (context) => Theme(
      data: themeData,
      child: _SubscriptionUpgradeModalPage(
        onShowAllPlansPressed: () => showSubscriptionPlansModalPage(context),
      ),
    ),
  );
}

class _SubscriptionUpgradeModalPage extends StatefulWidget {
  const _SubscriptionUpgradeModalPage({required this.onShowAllPlansPressed});

  final VoidCallback onShowAllPlansPressed;

  @override
  State<_SubscriptionUpgradeModalPage> createState() => _SubscriptionUpgradeModalPageState();
}

class _SubscriptionUpgradeModalPageState extends State<_SubscriptionUpgradeModalPage> {
  final _store = getIt<SubscriptionPlansStore>();
  final _subscriptionStore = getIt<SubscriptionStore>();
  final _purchaseStore = getIt<SubscriptionPurchaseStore>();
  final _remoteConfigStore = getIt<RemoteConfigStore>();
  late final ScrollController _scrollController;
  bool _isLoading = false;
  late final ReactionDisposer _reactionDisposer;

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _reactionDisposer = reaction((_) => _purchaseStore.subscriptionStatus, (status) {
      if (mounted) {
        setState(() => _isLoading = status?.isLoading ?? false);
      }
      if (status?.isError ?? false) {
        showError(_purchaseStore.subscriptionError);
      }
      if (status == SubscriptionStatus.canceled) {
        return;
      }
      if (status != null && !status.isLoading) {
        if (status == SubscriptionStatus.purchased) {
          showSnackbar(LocaleKeys.subscriptionActive.tr());
        }
        if (mounted) {
          Navigator.of(context).pop();
        }
        _subscriptionStore.refreshAll().ignore();
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _reactionDisposer();
    super.dispose();
  }

  Future<void> _handleSubscribe(String id) async {
    if (!mounted) {
      return;
    }
    final analyticsStore = getIt<AnalyticsStore>();
    final plansStore = getIt<SubscriptionPlansStore>();
    final purchaseStore = getIt<SubscriptionPurchaseStore>();
    final subscriptionStore = getIt<SubscriptionStore>();
    final remoteConfigStore = getIt<RemoteConfigStore>();
    final sessionStore = getIt<AuthSessionStore>();
    final accessToken = await sessionStore.accessTokenFuture;
    final products = await plansStore.future;
    final gateway = subscriptionStore.subscriptionFuture.value?.gateway;
    final selectedProduct = products.firstWhereOrNull((it) => it.id == id);
    if (selectedProduct == null) {
      return;
    }
    if (selectedProduct.id == subscriptionStore.subscriptionFuture.value?.planId) {
      if (mounted) {
        showSnackbar("You're all set! You already have this plan active");
        Navigator.of(context).pop();
      }
      return;
    }
    analyticsStore.logEvent(
      AnalyticsEvent.subscriptionNew,
      parameters: {'item_ids': products.map((e) => e.id).toList()},
    );
    if (remoteConfigStore.gatewaysSupportingUpgrade.contains(gateway?.toLowerCase())) {
      final uri = remoteConfigStore.checkoutWebRedirectUrl.replace(
        queryParameters: {'plan': selectedProduct.id, 'access_token': accessToken ?? ''},
      );
      await openUrlLink(uri);
      if (mounted) {
        Navigator.of(context).pop();
      }
      return;
    }
    await purchaseStore.subscribeToPackage(product: selectedProduct.productDetails);
  }

  @override
  Widget build(BuildContext context) {
    final screenType = getScreenType(MediaQuery.sizeOf(context));
    final theme = Theme.of(context);

    void handleSeeAllPlans() {
      Navigator.of(context).pop();
      widget.onShowAllPlansPressed();
    }

    return ModalScaffold(
      autoApplyPadding: false,
      body: SubscriptionStatusContainer(
        child: Observer(
          builder: (context) {
            final product = _store.bestValueProducts.lastOrNull;
            final subscription = _subscriptionStore.subscriptionFuture.value;
            final subscriptionStatus = _subscriptionStore.subscriptionFuture.status;

            if (product == null || subscriptionStatus == FutureStatus.pending) {
              return const Center(child: LoadingIndicator());
            }

            if (subscriptionStatus == FutureStatus.rejected) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      UntitledUI.alert_circle,
                      size: 48,
                      color: Theme.of(context).palette.textTertiary,
                    ),
                    SizedBox(height: Theme.of(context).spacing.lg),
                    Text(
                      LocaleKeys.somethingWentWrong.tr(),
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textStyles.textMd.regular,
                    ),
                    SizedBox(height: Theme.of(context).spacing.lg),
                    ButtonPrimary(
                      onPressed: _subscriptionStore.refreshSubscription,
                      decoration: ButtonDecoration(
                        decorationColor: Theme.of(context).palette.bgBrandPrimary,
                      ),
                      child: Text(LocaleKeys.retryBtn.tr()),
                    ),
                  ],
                ),
              );
            }

            if (subscription == null) {
              return const Center(child: LoadingIndicator());
            }

            final hasPlan = subscription.active;
            final bestConfig = _store.findConfig(product);
            final allProducts = [..._store.annualProducts, ..._store.monthlyProducts];
            final monthlyComparison = allProducts.firstWhereOrNull(
              (p) => _store.findConfig(p).name == bestConfig.name && p.duration == 1,
            );
            final otherProduct = monthlyComparison ?? _store.purchasedProduct;

            // Inline PlanData computation (from usePlanData)
            final currentPlanGateway = _subscriptionStore.subscriptionFuture.value?.gateway;
            final useStorePrices =
                currentPlanGateway == null ||
                currentPlanGateway.isEmpty ||
                isMobilePaymentGateway(currentPlanGateway);
            final canUseSalesValues = _remoteConfigStore.pricingMonthly;
            final isBestValue = _store.bestValueProducts.any((it) => it.id == product.id);
            final config = _store.findConfig(product);
            final period = switch (product.duration) {
              1 => LocaleKeys.month,
              12 => LocaleKeys.year,
              _ => '',
            };
            final discount = otherProduct != null
                ? useStorePrices
                      ? otherProduct.periodDiscountPercentage(product)
                      : otherProduct.discountPercentageBackend(product)
                : 0;
            final price = useStorePrices ? product.moneyMonthly : product.moneyMonthlyBackend;
            final money = useStorePrices ? product.money : product.backendMoney;
            final oldPrice = otherProduct != null
                ? useStorePrices
                      ? otherProduct.moneyMonthly
                      : otherProduct.moneyMonthlyBackend
                : null;
            final planData = PlanData(
              fullPriceLabel: LocaleKeys.fullPriceLabel.tr(),
              discountedLabel: LocaleKeys.discountedPriceLabel.tr(),
              isOffer: true,
              name: config.name.tr(),
              monthlyFullPrice: canUseSalesValues ? oldPrice?.toString() : null,
              monthlyDiscountedPrice: canUseSalesValues ? price.toString() : null,
              fullPrice: '$money',
              bestValueBadge: isBestValue ? LocaleKeys.subscriptionPlanBestValue.tr() : null,
              promoBadge: discount > 0 && canUseSalesValues
                  ? LocaleKeys.subscriptionPlanSaveWith.tr(
                      namedArgs: {'percent': discount.toString(), 'planId': '1-${period.tr()}'},
                    )
                  : null,
              perMonth: LocaleKeys.perMonth.tr(),
              periodLabel: period.tr(),
            );
            final planWithDuration = '${planData.name} 1-${planData.periodLabel.capitalize()}';

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    padding: ModalPadding.insets(context),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (screenType != ScreenType.mobile) SizedBox(height: theme.spacing.xl2),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: theme.spacing.md),
                            child: ModalHeader(
                              emblem: const DecoratedIcon(
                                icon: UntitledUI.stars_02,
                                decoration: IconDecoration(
                                  padding: EdgeInsets.all(14),
                                  iconSize: 20,
                                ),
                              ),
                              title: hasPlan
                                  ? LocaleKeys.subscriptionUpgradeModalTitle.tr(
                                      args: [planData.name],
                                    )
                                  : LocaleKeys.getSubscriptionModalTitle.tr(
                                      args: [planWithDuration],
                                    ),
                              description: hasPlan
                                  ? LocaleKeys.subscriptionUpgradeModalDescription.tr()
                                  : LocaleKeys.getSubscriptionModalDesc.tr(),
                            ),
                          ),
                          SizedBox(height: theme.spacing.xl),
                          Center(
                            child: LayoutBuilder(
                              builder: (context, constraints) => Container(
                                width: min(constraints.maxWidth, 393),
                                padding: EdgeInsets.symmetric(horizontal: theme.spacing.md),
                                child: PlanCard.features(
                                  mode: PlanCardMode.highlight,
                                  data: planData,
                                  features: _store
                                      .findConfig(product)
                                      .previewFeatures
                                      .where(
                                        (feature) =>
                                            feature != 'subscriptionPlanPF4Basic' &&
                                            feature != 'subscriptionPlanPF5Plus',
                                      )
                                      .map((it) => it.tr())
                                      .toList(),
                                  viewMoreLabel: LocaleKeys.viewAllFeaturesBtn.tr(),
                                  viewLessLabel: LocaleKeys.viewLessBtn.tr(),
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: theme.spacing.lg),
                          Text.rich(
                            TextSpan(
                              children: [
                                WidgetSpan(
                                  child: Icon(
                                    UntitledUI.currency_dollar_circle,
                                    size: 16,
                                    color: theme.palette.textTertiary,
                                  ),
                                ),
                                CharacterSpan.space(),
                                TextSpan(text: LocaleKeys.subscriptionPlanMoneyBack.tr()),
                              ],
                            ),
                            textAlign: TextAlign.center,
                            style: theme.textStyles.textXs.regular.copyWith(
                              color: theme.palette.textTertiary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                ModalFooter(
                  spacing: 0,
                  children: [
                    if (_subscriptionStore.canRedeemCode)
                      ButtonTertiary(
                        size: ButtonSize.small,
                        decoration: ButtonDecoration(
                          foregroundColor: theme.palette.textPrimarySelected,
                          padding: EdgeInsets.zero,
                        ),
                        onPressed: () async {
                          try {
                            await _purchaseStore.redeemCode();
                          } catch (e) {
                            showError(e);
                          }
                        },
                        child: Text(LocaleKeys.redeemDiscountCode.tr()),
                      ),
                    SizedBox(height: theme.spacing.ms),
                    ButtonPrimary(
                      onPressed: () => _handleSubscribe(product.id),
                      loading: _isLoading ? const ButtonLoading() : null,
                      decoration: ButtonDecoration(
                        decorationColor: theme.palette.bgBrandPrimary,
                        padding: EdgeInsets.symmetric(vertical: theme.spacing.lg, horizontal: 18),
                      ),
                      child: Text(
                        hasPlan
                            ? LocaleKeys.subscriptionUpgradeCTA.tr(args: [planData.name])
                            : LocaleKeys.getSubscriptionPlanBtn.tr(args: [planWithDuration]),
                      ),
                    ),
                    SizedBox(height: theme.spacing.xl),
                    ButtonTertiary(
                      onPressed: handleSeeAllPlans,
                      decoration: ButtonDecoration(
                        foregroundColor: theme.palette.textPrimarySelected,
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(LocaleKeys.subscriptionUpgradeSeeAllPlans.tr()),
                    ),
                    SizedBox(height: theme.spacing.xl),
                    const SubscriptionPrivacyAndTerms(),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
