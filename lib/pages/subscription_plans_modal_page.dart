import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/extensions/scroll_controller_extensions.dart';
import 'package:mysterium_vpn/common/hooks/handle_subscribe_to_product_hook.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/hooks/plan_data_hook.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/subscription/subscription_status_container.dart';
import 'package:mysterium_vpn/views/subscription/widgets/subscription_comparison_table.dart';
import 'package:mysterium_vpn/views/subscription/widgets/subscription_privacy_and_terms.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

Future<void> showSubscriptionPlansModalPage(BuildContext context) async {
  ProviderScope.containerOf(context, listen: false)
      .read(analyticsStorePOD)
      .logScreenViewed('subscription_plans_modal')
      .ignore();
  await showModal(
    context,
    builder: (ctx) => Theme(
      data: DesignSystemTheme.of(context),
      child: const _SubscriptionPlansModalPage(),
    ),
  );
}

class _SubscriptionPlansModalPage extends HookConsumerWidget {
  const _SubscriptionPlansModalPage();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final tableKey = useRef(GlobalKey()).value;

    final store = ref.watch(subscriptionPlansStorePOD);
    final upgradeStore = ref.watch(subscriptionUpgradeStorePOD);
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
      if (status != null && !status.isLoading) {
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
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: theme.spacing.md),
                        child: ModalHeader(
                          emblem: const DecoratedIcon(icon: UntitledUI.shield_02),
                          title: LocaleKeys.subscriptionAllPlansTitle.tr(),
                          description: LocaleKeys.subscriptionAllPlansDescription.tr(),
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
                                }
                                    .sortedByCompare((it) => it.monthlyValue, compareNumsDesc),
                              );

                              final productsRef = useRef(products)..value = products;

                              useEffect(
                                () {
                                  void listener() {
                                    WidgetsBinding.instance.addPostFrameCallback((_) {
                                      selectedProduct.value = productsRef.value.first;
                                    });
                                  }

                                  listener();
                                  tabController.addListener(listener);
                                  return () => tabController.removeListener(listener);
                                },
                                [tabController, selectedProduct, productsRef],
                              );

                              return RadioGroup<PurchasableProduct>(
                                groupValue: selectedProduct.value,
                                onChanged: (value) => selectedProduct.value = value,
                                child: _SubscriptionPlans(
                                  products: products,
                                  onCompareFeaturesPressed: () =>
                                      scrollController.scrollToKey(tableKey),
                                ),
                              );
                            },
                          );
                        },
                      ),
                      SizedBox(height: theme.spacing.md),
                      Text(
                        LocaleKeys.subscriptionAllPlansCompareAll.tr(),
                        style: theme.textStyles.textMd.medium,
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
              children: [
                ButtonPrimary(
                  onPressed: handlePurchasePressed,
                  loading: isLoading.value ? const ButtonLoading() : null,
                  child: Text(
                    upgradeStore.currentProduct != null
                        ? LocaleKeys.subscriptionAllPlansUpgrade.tr()
                        : LocaleKeys.subscriptionAllPlansPurchase.tr(),
                  ),
                ),
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
    required this.onCompareFeaturesPressed,
  });

  final List<PurchasableProduct> products;
  final VoidCallback onCompareFeaturesPressed;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final lowest = products.lastOrNull;

    final direction = switch (ScreenType.of(context)) {
      < ScreenType.desktop => Axis.vertical,
      _ => Axis.horizontal,
    };

    return Padding(
      padding: EdgeInsets.all(theme.spacing.md),
      child: Flex(
        spacing: theme.spacing.s,
        mainAxisSize: switch (direction) {
          Axis.vertical => MainAxisSize.max,
          Axis.horizontal => MainAxisSize.min,
        },
        crossAxisAlignment: switch (direction) {
          Axis.vertical => CrossAxisAlignment.stretch,
          Axis.horizontal => CrossAxisAlignment.end,
        },
        direction: direction,
        children: [
          for (final product in products)
            Expanded(
              flex: switch (direction) {
                Axis.horizontal => 1,
                Axis.vertical => 0,
              },
              child: _Plan(
                value: product,
                lowest: lowest,
                onCompareFeaturesPressed: onCompareFeaturesPressed,
              ),
            ),
        ],
      ),
    );
  }
}

class _Plan extends HookWidget {
  const _Plan({
    required this.value,
    required this.lowest,
    required this.onCompareFeaturesPressed,
  });

  final PurchasableProduct value;
  final PurchasableProduct? lowest;
  final VoidCallback onCompareFeaturesPressed;

  @override
  Widget build(BuildContext context) {
    final data = usePlanData(value, otherProduct: lowest);

    return PlanCard.actions(
      data: data,
      onPressed: onCompareFeaturesPressed,
      text: LocaleKeys.subscriptionAllPlansCompare.tr(),
      value: value,
    );
  }
}
