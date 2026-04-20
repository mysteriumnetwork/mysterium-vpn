import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/subscription_status.dart';
import 'package:mysterium_vpn/common/extensions/scroll_controller_extensions.dart';
import 'package:mysterium_vpn/common/hooks/handle_subscribe_to_product_hook.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/hooks/plan_data_hook.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
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
  final themeData = DesignSystemTheme.of(context);
  await showModal(
    context,
    builder: (ctx) => Theme(data: themeData, child: const _SubscriptionPlansModalPage()),
  );
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
    final handleSubscribe = useHandleSubscribeToProduct();
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
        child: Column(
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
                          title: LocaleKeys.subscriptionAllPlansTitle.tr(),
                          titleStyle: theme.textStyles.textLg.semibold,
                        ),
                      ),
                      SizedBox(height: theme.spacing.xl2),
                      TabBar(
                        controller: tabController,
                        tabs: [
                          Tab(text: LocaleKeys.subscriptionAllPlansTabYear.tr()),
                          Tab(text: LocaleKeys.subscriptionAllPlansTabMonth.tr()),
                        ],
                      ),
                      Observer(
                        builder: (context) {
                          final monthly = store.monthlyProducts;
                          final annual = store.annualProducts;
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
                                    selectedProduct.value = productsRef.value.first;
                                  });
                                }

                                listener();
                                tabController.addListener(listener);
                                return () => tabController.removeListener(listener);
                              }, [tabController, selectedProduct, productsRef]);

                              return RadioGroup<PurchasableProduct>(
                                groupValue: selectedProduct.value,
                                onChanged: (value) => selectedProduct.value = value,
                                child: _SubscriptionPlans(
                                  products: products,
                                  allProducts: [...annual, ...monthly],
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
                            TextSpan(text: LocaleKeys.subscriptionPlanMoneyBack.tr()),
                          ],
                        ),
                        textAlign: TextAlign.center,
                        style: theme.textStyles.textXs.regular.copyWith(
                          color: theme.palette.textTertiary,
                        ),
                      ),
                      const SizedBox(height: 32),
                      Text(
                        LocaleKeys.subscriptionAllPlansCompareAll.tr(),
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
                    child: Text(LocaleKeys.redeemDiscountCode.tr()),
                  ),
                SizedBox(height: theme.spacing.ms),
                ButtonPrimary(
                  onPressed: subscriptionStore.isSubscribed == null ? null : handlePurchasePressed,
                  loading: isLoading.value ? const ButtonLoading() : null,
                  decoration: ButtonDecoration(
                    decorationColor: theme.palette.bgBrandPrimary,
                    padding: EdgeInsets.symmetric(vertical: theme.spacing.lg, horizontal: 18),
                  ),
                  child: Text(
                    (subscriptionStore.isSubscribed ?? false)
                        ? LocaleKeys.subscriptionAllPlansUpgrade.tr()
                        : LocaleKeys.subscriptionAllPlansPurchase.tr(),
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
                  child: Text(LocaleKeys.subscriptionAllPlansCompareAll.tr()),
                ),
                SizedBox(height: theme.spacing.xl),
                const SubscriptionPrivacyAndTerms(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _SubscriptionPlans extends HookWidget {
  const _SubscriptionPlans({
    required this.products,
    required this.allProducts,
    required this.onCompareFeaturesPressed,
  });

  final List<PurchasableProduct> products;
  final List<PurchasableProduct> allProducts;
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
                  child: _Plan(value: product, allProducts: allProducts),
                )
              else
                _Plan(value: product, allProducts: allProducts),
          ],
        ),
      ),
    );
  }
}

class _Plan extends HookWidget {
  const _Plan({required this.value, required this.allProducts});

  final PurchasableProduct value;
  final List<PurchasableProduct> allProducts;

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
      viewMoreLabel: LocaleKeys.viewAllFeaturesBtn.tr(),
      viewLessLabel: LocaleKeys.viewLessBtn.tr(),
    );
  }

  List<String> _getPreviewFeatures(SubscriptionPlansStore store, PurchasableProduct product) {
    final config = store.findConfig(product);
    final allFeatures = config.previewFeatures.map((it) => it.tr()).toList();

    // Basic plan: show 3 features, Pro/Plus plan: show 4 features
    final isBasic = config.name == LocaleKeys.subscriptionPlanNameBasic;
    final featureCount = isBasic ? 3 : 4;

    return allFeatures.take(featureCount).toList();
  }
}
