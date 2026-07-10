import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/subscription_status.dart';
import 'package:mysterium_vpn/common/extensions/scroll_controller_extensions.dart';
import 'package:mysterium_vpn/common/hooks/handle_subscribe_to_product_hook.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/hooks/plan_data_hook.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/l10n/tr_bridge.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/subscription_plans_store.dart';
import 'package:mysterium_vpn/views/subscription/subscription_status_container.dart';
import 'package:mysterium_vpn/views/subscription/widgets/subscription_comparison_table.dart';
import 'package:mysterium_vpn/views/subscription/widgets/subscription_privacy_and_terms.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

Future<void> showSubscriptionPlansModalPage(BuildContext context) async {
  ProviderScope.containerOf(
    context,
    listen: false,
  ).read(analyticsStorePOD).logScreenViewed('subscription_plans_modal').ignore();
  await showModal(context, builder: (ctx) => const _SubscriptionPlansModalPage());
}

class _SubscriptionPlansModalPage extends HookConsumerWidget {
  const _SubscriptionPlansModalPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tableKey = useRef(GlobalKey()).value;

    final store = ref.watch(subscriptionPlansStorePOD);
    final purchaseStore = ref.watch(subscriptionPurchaseStorePOD);
    final subscriptionStore = ref.watch(subscriptionStorePOD);

    final theme = Theme.of(context);
    final tabController = useTabController(initialLength: 2);
    final scrollController = useScrollController();
    final selectedProduct = useState<PurchasableProduct?>(null);
    final handleSubscribe = useHandleSubscribeToProduct(
      onAfterRedirect: () => Navigator.of(context).pop(),
    );
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
          showSnackbar(S.current.subscriptionActive, type: SnackbarType.success);
        }
        Navigator.of(context).pop();
        subscriptionStore.refreshAll().ignore();
      }
    });

    Future<void> handlePurchasePressed() async {
      final product = selectedProduct.value;
      if (product == null) {
        return;
      }
      await handleSubscribe(product.id);
    }

    return ModalScaffold(
      autoApplyPadding: false,
      showGradient: false,
      body: SubscriptionStatusContainer(
        child: Observer(
          builder: (context) {
            // Block purchase flow when subscription data is unavailable
            if (subscriptionStore.subscriptionFuture.status == FutureStatus.rejected) {
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
                      S.current.somethingWentWrong,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textStyles.textMd.regular,
                    ),
                    SizedBox(height: Theme.of(context).spacing.lg),
                    ButtonPrimary(
                      onPressed: subscriptionStore.refreshSubscription,
                      child: Text(S.current.retryBtn),
                    ),
                  ],
                ),
              );
            }

            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    controller: scrollController,
                    padding: ModalPadding.insets(
                      context,
                      add: EdgeInsets.symmetric(vertical: theme.spacing.xl),
                    ),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          SizedBox(height: theme.spacing.xl),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: theme.spacing.md),
                            child: ModalHeader(
                              title: S.current.subscriptionAllPlansTitle,
                              titleStyle: theme.textStyles.textLg.semibold,
                            ),
                          ),
                          SizedBox(height: theme.spacing.xl2),
                          TabBar(
                            controller: tabController,
                            tabs: [
                              Tab(text: S.current.subscriptionAllPlansTabYear),
                              Tab(text: S.current.subscriptionAllPlansTabMonth),
                            ],
                          ),
                          Observer(
                            builder: (context) {
                              final monthly = store.monthlyProducts;
                              final annual = store.annualProducts;
                              final currentProduct = ref
                                  .watch(subscriptionUpgradeStorePOD)
                                  .currentProduct;
                              return HookBuilder(
                                builder: (context) {
                                  final products = useListenableSelector(
                                    tabController,
                                    () => switch (tabController.index) {
                                      1 => monthly,
                                      _ => annual,
                                    }.sortedByCompare((it) => it.monthlyValue, compareNumsDesc),
                                  );

                                  final productsRef = useRef(products)..value = products;

                                  useEffect(() {
                                    void listener() {
                                      WidgetsBinding.instance.addPostFrameCallback((_) {
                                        final firstSelectable = productsRef.value.firstWhereOrNull(
                                          (p) => p.id != currentProduct?.id,
                                        );
                                        selectedProduct.value =
                                            firstSelectable ?? productsRef.value.firstOrNull;
                                      });
                                    }

                                    listener();
                                    tabController.addListener(listener);
                                    return () => tabController.removeListener(listener);
                                  }, [tabController, selectedProduct, productsRef, currentProduct]);

                                  return RadioGroup<PurchasableProduct>(
                                    groupValue: selectedProduct.value,
                                    onChanged: (value) => selectedProduct.value = value,
                                    child: _SubscriptionPlans(
                                      products: products,
                                      allProducts: [...annual, ...monthly],
                                      currentProduct: currentProduct,
                                      onCompareFeaturesPressed: () =>
                                          scrollController.scrollToKey(tableKey),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                          SizedBox(height: theme.spacing.ms),
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
                                TextSpan(text: S.current.subscriptionPlanMoneyBack),
                              ],
                            ),
                            textAlign: TextAlign.center,
                            style: theme.textStyles.textXs.regular.copyWith(
                              color: theme.palette.textTertiary,
                            ),
                          ),
                          const SizedBox(height: 32),
                          Text(
                            S.current.subscriptionAllPlansCompareAll,
                            style: theme.textStyles.textMd.medium.copyWith(
                              color: theme.palette.textPrimary,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: theme.spacing.xl3),
                          SubscriptionComparisonTable(
                            key: tableKey,
                            onShowPlansPressed: () => scrollController.scrollToPosition(-1),
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
                        child: Text(S.current.redeemDiscountCode),
                      ),
                    SizedBox(height: theme.spacing.ms),
                    ButtonPrimary(
                      onPressed: handlePurchasePressed,
                      loading: isLoading.value ? const ButtonLoading() : null,

                      child: Text(
                        (subscriptionStore.isSubscribed ?? false)
                            ? S.current.subscriptionAllPlansUpgrade
                            : S.current.subscriptionAllPlansPurchase,
                      ),
                    ),
                    SizedBox(height: theme.spacing.xl),
                    ButtonTertiary(
                      onPressed: () {
                        scrollController.scrollToKey(tableKey);
                      },
                      decoration: ButtonDecoration(
                        foregroundColor: theme.palette.textPrimarySelected,
                        textStyle: theme.textStyles.textMd.semibold,
                        padding: EdgeInsets.zero,
                      ),
                      child: Text(S.current.subscriptionAllPlansCompareAll),
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

class _SubscriptionPlans extends HookWidget {
  const _SubscriptionPlans({
    required this.products,
    required this.allProducts,
    required this.currentProduct,
    required this.onCompareFeaturesPressed,
  });

  final List<PurchasableProduct> products;
  final List<PurchasableProduct> allProducts;
  final PurchasableProduct? currentProduct;
  final VoidCallback onCompareFeaturesPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final direction = switch (ScreenType.of(context)) {
      < ScreenType.desktop => Axis.vertical,
      _ => Axis.horizontal,
    };

    final isDesktop = direction == Axis.horizontal;

    return Padding(
      padding: EdgeInsets.all(theme.spacing.md),
      child: IntrinsicHeight(
        child: Flex(
          spacing: theme.spacing.s,
          mainAxisSize: switch (direction) {
            Axis.vertical => MainAxisSize.max,
            Axis.horizontal => MainAxisSize.max,
          },
          crossAxisAlignment: switch (direction) {
            Axis.vertical => CrossAxisAlignment.stretch,
            Axis.horizontal => CrossAxisAlignment.stretch,
          },
          direction: direction,
          children: [
            for (final product in products)
              if (isDesktop)
                Expanded(
                  child: _Plan(
                    value: product,
                    allProducts: allProducts,
                    isCurrentPlan: product.id == currentProduct?.id,
                  ),
                )
              else
                _Plan(
                  value: product,
                  allProducts: allProducts,
                  isCurrentPlan: product.id == currentProduct?.id,
                ),
          ],
        ),
      ),
    );
  }
}

class _Plan extends HookWidget {
  const _Plan({required this.value, required this.allProducts, required this.isCurrentPlan});

  final PurchasableProduct value;
  final List<PurchasableProduct> allProducts;
  final bool isCurrentPlan;

  @override
  Widget build(BuildContext context) {
    final store = ProviderScope.containerOf(context, listen: false).read(subscriptionPlansStorePOD);
    final upgradeStore = ProviderScope.containerOf(
      context,
      listen: false,
    ).read(subscriptionUpgradeStorePOD);

    final comparisonProduct = upgradeStore.getComparisonProduct(value, allProducts);

    final data = usePlanData(product: value, otherProduct: comparisonProduct, isOffer: false);
    final features = _getPreviewFeatures(store, value);

    return PlanCard.features(
      data: data,
      value: value,
      features: features,
      viewMoreLabel: S.current.viewAllFeaturesBtn,
      viewLessLabel: S.current.viewLessBtn,
      currentPlanLabel: isCurrentPlan ? S.current.subscriptionAllPlansCurrentPlan : null,
    );
  }

  List<String> _getPreviewFeatures(SubscriptionPlansStore store, PurchasableProduct product) {
    final config = store.findConfig(product);
    final allFeatures = config.previewFeatures.map(Tr.byKey).toList();

    // Basic plan: show 3 features, Pro/Plus plan: show 4 features
    final isBasic = config.name == 'subscriptionPlanNameBasic';
    final featureCount = isBasic ? 3 : 4;

    return allFeatures.take(featureCount).toList();
  }
}
