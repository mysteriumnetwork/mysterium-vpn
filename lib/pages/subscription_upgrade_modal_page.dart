import 'dart:math';

import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/screen_type.dart';
import 'package:mysterium_vpn/common/enums/subscription_status.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/hooks/handle_subscribe_to_product_hook.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/hooks/plan_data_hook.dart';
import 'package:mysterium_vpn/common/hooks/screen_type_hook.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/pages/subscription_plans_modal_page.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/subscription/subscription_status_container.dart';
import 'package:mysterium_vpn/views/subscription/widgets/subscription_privacy_and_terms.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart' hide ScreenType;

Future<void> showSubscriptionUpgradeModalPage(BuildContext context) async {
  ProviderScope.containerOf(
    context,
    listen: false,
  ).read(analyticsStorePOD).logScreenViewed('subscription_upgrade_modal').ignore();
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

class _SubscriptionUpgradeModalPage extends HookConsumerWidget {
  const _SubscriptionUpgradeModalPage({required this.onShowAllPlansPressed});

  final VoidCallback onShowAllPlansPressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(subscriptionPlansStorePOD);
    final subscriptionStore = ref.watch(subscriptionStorePOD);
    final purchaseStore = ref.watch(subscriptionPurchaseStorePOD);

    final theme = Theme.of(context);
    final scrollController = useScrollController();
    final isLoading = useState(false);

    useReaction(() => purchaseStore.subscriptionStatus, (status) {
      isLoading.value = status?.isLoading ?? false;
      if (status?.isError ?? false) {
        showError(purchaseStore.subscriptionError);
      }
      if (status == SubscriptionStatus.canceled) {
        return;
      }
      if (status != null && !status.isLoading) {
        if (status == SubscriptionStatus.purchased) {
          showSnackbar(LocaleKeys.subscriptionActive.tr());
        }
        if (context.mounted) {
          Navigator.of(context).pop();
        }
        subscriptionStore.refreshAll().ignore();
      }
    });

    void handleSeeAllPlans() {
      Navigator.of(context).pop();
      onShowAllPlansPressed();
    }

    final screenType = useScreenType();

    return ModalScaffold(
      autoApplyPadding: false,
      body: SubscriptionStatusContainer(
        child: Observer(
          builder: (context) {
            final product = store.bestValueProducts.lastOrNull;
            final subscription = subscriptionStore.subscriptionFuture.value;
            final subscriptionStatus = subscriptionStore.subscriptionFuture.status;

            // Handle loading state
            if (product == null || subscriptionStatus == FutureStatus.pending) {
              return const Center(child: LoadingIndicator());
            }

            // Handle error state - future was rejected
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
                      onPressed: subscriptionStore.refreshSubscription,
                      decoration: ButtonDecoration(
                        decorationColor: Theme.of(context).palette.bgBrandPrimary,
                      ),
                      child: Text(LocaleKeys.retryBtn.tr()),
                    ),
                  ],
                ),
              );
            }

            // Subscription data should be available at this point
            if (subscription == null) {
              return const Center(child: LoadingIndicator());
            }
            final hasPlan = subscription.active;
            return HookBuilder(
              builder: (context) {
                // Find the monthly version of the best value product for comparison
                final bestConfig = store.findConfig(product);
                final allProducts = [...store.annualProducts, ...store.monthlyProducts];
                final monthlyComparison = allProducts.firstWhereOrNull(
                  (p) => store.findConfig(p).name == bestConfig.name && p.duration == 1,
                );

                final planData = usePlanData(
                  product: product,
                  otherProduct: monthlyComparison ?? store.purchasedProduct,
                  isOffer: true,
                );
                final planWithDuration = '${planData.name} 1-${planData.periodLabel.capitalize()}';
                final handleSubscribe = useHandleSubscribeToProduct();

                Future<void> handlePurchase() async {
                  await handleSubscribe(product.id);
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: SingleChildScrollView(
                        controller: scrollController,
                        padding: ModalPadding.insets(context),
                        child: Align(
                          alignment: Alignment.topCenter,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              if (screenType != ScreenType.mobile)
                                SizedBox(height: theme.spacing.xl2),
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
                                      features: store
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
                        if (subscriptionStore.canRedeemCode)
                          ButtonTertiary(
                            size: ButtonSize.small,
                            decoration: ButtonDecoration(
                              foregroundColor: theme.palette.textPrimarySelected,
                              padding: EdgeInsets.zero,
                            ),
                            onPressed: () async {
                              try {
                                await purchaseStore.redeemCode();
                              } catch (e) {
                                showError(e);
                              }
                            },
                            child: Text(LocaleKeys.redeemDiscountCode.tr()),
                          ),
                        SizedBox(height: theme.spacing.ms),
                        ButtonPrimary(
                          onPressed: handlePurchase,
                          loading: isLoading.value ? const ButtonLoading() : null,
                          decoration: ButtonDecoration(
                            decorationColor: theme.palette.bgBrandPrimary,
                            padding: EdgeInsets.symmetric(
                              vertical: theme.spacing.lg,
                              horizontal: 18,
                            ),
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
            );
          },
        ),
      ),
    );
  }
}
