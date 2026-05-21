import 'dart:math';

import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/subscription_status.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/hooks/handle_subscribe_to_product_hook.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/hooks/plan_data_hook.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/subscription/widgets/subscription_privacy_and_terms.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

/// Renders the "best value" upgrade content (header + plan card + CTAs +
/// footer) shared by the upgrade modal page and the Products tab. Wrap with
/// `SubscriptionStatusContainer` when used outside a modal.
class SubscriptionUpgradeView extends HookConsumerWidget {
  const SubscriptionUpgradeView({
    required this.onShowAllPlansPressed,
    super.key,
    this.onPurchaseComplete,
    this.contentPadding,
  });

  /// Invoked when the user taps "See all plans".
  final VoidCallback onShowAllPlansPressed;

  /// Fires on purchase success, web-checkout hand-off, or "already on this
  /// plan". Modal callers pass [Navigator.pop]; tab callers leave it null.
  final VoidCallback? onPurchaseComplete;

  /// Padding applied to the scrollable content. Defaults to
  /// `ModalPadding.insets(context)` to match modal usage.
  final EdgeInsetsGeometry? contentPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(subscriptionPlansStorePOD);
    final subscriptionStore = ref.watch(subscriptionStorePOD);
    final purchaseStore = ref.watch(subscriptionPurchaseStorePOD);

    final theme = Theme.of(context);
    final scrollController = useScrollController();

    // useReaction captures its callback once; ref keeps the latest.
    final onPurchaseCompleteRef = useRef(onPurchaseComplete)..value = onPurchaseComplete;

    // SubscriptionStatusContainer handles snackbars/verification dialogs.
    useReaction(() => purchaseStore.subscriptionStatus, (status) {
      if (status?.isError ?? false) {
        showError(purchaseStore.subscriptionError);
      }
      if (status == SubscriptionStatus.purchased) {
        onPurchaseCompleteRef.value?.call();
        subscriptionStore.refreshAll().ignore();
      }
    });

    final screenType = ScreenType.of(context);

    return Observer(
      builder: (context) {
        final product = store.bestValueProducts.lastOrNull;
        final subscription = subscriptionStore.subscriptionFuture.value;
        final subscriptionStatus = subscriptionStore.subscriptionFuture.status;

        if (product == null || subscriptionStatus == FutureStatus.pending) {
          return const Center(child: LoadingIndicator());
        }

        if (subscriptionStatus == FutureStatus.rejected) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(UntitledUI.alert_circle, size: 48, color: theme.palette.textTertiary),
                SizedBox(height: theme.spacing.lg),
                Text(
                  LocaleKeys.somethingWentWrong.tr(),
                  textAlign: TextAlign.center,
                  style: theme.textStyles.textMd.regular,
                ),
                SizedBox(height: theme.spacing.lg),
                ButtonPrimary(
                  onPressed: subscriptionStore.refreshSubscription,
                  decoration: ButtonDecoration(decorationColor: theme.palette.bgBrandPrimary),
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
        return HookBuilder(
          builder: (context) {
            final monthlyComparison = useMemoized(() {
              final bestConfig = store.findConfig(product);
              final allProducts = [...store.annualProducts, ...store.monthlyProducts];
              return allProducts.firstWhereOrNull(
                (p) => store.findConfig(p).name == bestConfig.name && p.duration == 1,
              );
            }, [product, store.annualProducts, store.monthlyProducts]);

            final features = useMemoized(
              () => store
                  .findConfig(product)
                  .previewFeatures
                  .where(
                    (feature) =>
                        feature != 'subscriptionPlanPF4Basic' &&
                        feature != 'subscriptionPlanPF5Plus',
                  )
                  .map((it) => it.tr())
                  .toList(),
              [product, context.locale],
            );

            final planData = usePlanData(
              product: product,
              otherProduct: monthlyComparison ?? store.purchasedProduct,
              isOffer: true,
            );
            final planWithDuration = '${planData.name} 1-${planData.periodLabel.capitalize()}';
            final handleSubscribe = useHandleSubscribeToProduct(
              onAfterRedirect: onPurchaseComplete,
            );

            Future<void> handlePurchase() async {
              await handleSubscribe(product.id);
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: contentPadding ?? ModalPadding.insets(context),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          if (screenType >= ScreenType.tablet) SizedBox(height: theme.spacing.xl2),
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
                                  features: features,
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
                    Observer(
                      builder: (context) => ButtonPrimary(
                        onPressed: handlePurchase,
                        loading: (purchaseStore.subscriptionStatus?.isLoading ?? false)
                            ? const ButtonLoading()
                            : null,

                        child: Text(
                          hasPlan
                              ? LocaleKeys.subscriptionUpgradeCTA.tr(args: [planData.name])
                              : LocaleKeys.getSubscriptionPlanBtn.tr(args: [planWithDuration]),
                        ),
                      ),
                    ),
                    SizedBox(height: theme.spacing.xl),
                    ButtonTertiary(
                      onPressed: onShowAllPlansPressed,
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
    );
  }
}
