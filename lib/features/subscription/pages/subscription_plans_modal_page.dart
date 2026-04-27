import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/core/extensions/scroll_controller_extensions.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/remote_config/store/remote_config_store.dart';
import 'package:mysterium_vpn/features/subscription/pages/subscription_checkout_outcome.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_checkout_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_plans_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_purchase_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_store.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_upgrade_store.dart';
import 'package:mysterium_vpn/features/subscription/views/subscription_status_container.dart';
import 'package:mysterium_vpn/features/subscription/views/widgets/subscription_comparison_table.dart';
import 'package:mysterium_vpn/features/subscription/views/widgets/subscription_privacy_and_terms.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

Future<void> showSubscriptionPlansModalPage(BuildContext context) async {
  GetIt.I<AnalyticsStore>().logScreenViewed('subscription_plans_modal').ignore();
  await showModal(context, builder: (ctx) => const _SubscriptionPlansModalPage());
}

class _SubscriptionPlansModalPage extends StatefulWidget {
  const _SubscriptionPlansModalPage();

  @override
  State<_SubscriptionPlansModalPage> createState() => _SubscriptionPlansModalPageState();
}

class _SubscriptionPlansModalPageState extends State<_SubscriptionPlansModalPage>
    with SingleTickerProviderStateMixin {
  final _store = GetIt.I<SubscriptionPlansStore>();
  final _purchaseStore = GetIt.I<SubscriptionPurchaseStore>();
  final _subscriptionStore = GetIt.I<SubscriptionStore>();
  final _checkoutStore = GetIt.I<SubscriptionCheckoutStore>();

  final _tableKey = GlobalKey();
  late final TabController _tabController;
  late final ScrollController _scrollController;

  PurchasableProduct? _selectedProduct;

  late final ReactionDisposer _checkoutDisposer;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _scrollController = ScrollController();

    _checkoutDisposer = reaction((_) => _checkoutStore.outcome, (CheckoutOutcome? outcome) {
      if (outcome == null || !mounted) {
        return;
      }
      handleCheckoutOutcome(context, _checkoutStore, outcome);
    });

    _tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    final products = _tabController.index == 1 ? _store.monthlyProducts : _store.annualProducts;
    final sorted = products.sortedByCompare((it) => it.monthlyValue, compareNumsDesc);
    if (sorted.isNotEmpty) {
      setState(() => _selectedProduct = sorted.first);
    }
  }

  @override
  void dispose() {
    _checkoutDisposer();
    _tabController
      ..removeListener(_onTabChanged)
      ..dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _handlePurchasePressed() async {
    final product = _selectedProduct;
    if (product == null) {
      return;
    }
    await _checkoutStore.subscribe(product.id);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return ModalScaffold(
      autoApplyPadding: false,
      showGradient: false,
      body: SubscriptionStatusContainer(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
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
                        controller: _tabController,
                        tabs: [
                          Tab(text: LocaleKeys.subscriptionAllPlansTabYear.tr()),
                          Tab(text: LocaleKeys.subscriptionAllPlansTabMonth.tr()),
                        ],
                      ),
                      Observer(
                        builder: (context) {
                          final monthly = _store.monthlyProducts;
                          final annual = _store.annualProducts;
                          final products = _tabController.index == 1 ? monthly : annual;
                          final sorted = products.sortedByCompare(
                            (it) => it.monthlyValue,
                            compareNumsDesc,
                          );
                          return RadioGroup<PurchasableProduct>(
                            groupValue: _selectedProduct,
                            onChanged: (value) => setState(() => _selectedProduct = value),
                            child: _SubscriptionPlans(
                              products: sorted,
                              allProducts: [...annual, ...monthly],
                              onCompareFeaturesPressed: () =>
                                  _scrollController.scrollToKey(_tableKey),
                            ),
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
                        key: _tableKey,
                        onShowPlansPressed: () => _scrollController.scrollToPosition(-1),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Observer(
              builder: (context) => ModalFooter(
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
                    onPressed: _handlePurchasePressed,
                    loading: _checkoutStore.isLoading ? const ButtonLoading() : null,
                    decoration: ButtonDecoration(
                      decorationColor: theme.palette.bgBrandPrimary,
                      padding: EdgeInsets.symmetric(vertical: theme.spacing.lg, horizontal: 18),
                    ),
                    child: Text(
                      (_subscriptionStore.isSubscribed ?? false)
                          ? LocaleKeys.subscriptionAllPlansUpgrade.tr()
                          : LocaleKeys.subscriptionAllPlansPurchase.tr(),
                    ),
                  ),
                  SizedBox(height: theme.spacing.xl),
                  ButtonTertiary(
                    onPressed: () => _scrollController.scrollToKey(_tableKey),
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
            ),
          ],
        ),
      ),
    );
  }
}

class _SubscriptionPlans extends StatelessWidget {
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

    final direction = ScreenType.of(context) < ScreenType.desktop ? Axis.vertical : Axis.horizontal;

    final isDesktop = direction == Axis.horizontal;

    return Padding(
      padding: EdgeInsets.all(theme.spacing.md),
      child: IntrinsicHeight(
        child: Flex(
          spacing: theme.spacing.s,
          crossAxisAlignment: CrossAxisAlignment.stretch,
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

class _Plan extends StatelessWidget {
  const _Plan({required this.value, required this.allProducts});

  final PurchasableProduct value;
  final List<PurchasableProduct> allProducts;

  @override
  Widget build(BuildContext context) {
    final store = GetIt.I<SubscriptionPlansStore>();
    final upgradeStore = GetIt.I<SubscriptionUpgradeStore>();
    final subscriptionStore = GetIt.I<SubscriptionStore>();
    final remoteConfigStore = GetIt.I<RemoteConfigStore>();

    final comparisonProduct = upgradeStore.getComparisonProduct(value, allProducts);
    final data = _buildPlanData(
      store,
      subscriptionStore,
      remoteConfigStore,
      value,
      comparisonProduct,
    );
    final features = _getPreviewFeatures(store, value);

    return PlanCard.features(
      data: data,
      value: value,
      features: features,
      viewMoreLabel: LocaleKeys.viewAllFeaturesBtn.tr(),
      viewLessLabel: LocaleKeys.viewLessBtn.tr(),
    );
  }

  PlanData _buildPlanData(
    SubscriptionPlansStore store,
    SubscriptionStore subscriptionStore,
    RemoteConfigStore remoteConfigStore,
    PurchasableProduct product,
    PurchasableProduct? otherProduct,
  ) {
    final currentPlanGateway = subscriptionStore.subscriptionFuture.value?.gateway;
    final useStorePrices =
        currentPlanGateway == null ||
        currentPlanGateway.isEmpty ||
        isMobilePaymentGateway(currentPlanGateway);
    final canUseSalesValues = remoteConfigStore.pricingMonthly;
    final isBestValue = store.bestValueProducts.any((it) => it.id == product.id);
    final isBasic = product.id.contains('basic');
    final config = store.findConfig(product);
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

    return PlanData(
      fullPriceLabel: LocaleKeys.fullPriceLabel.tr(),
      discountedLabel: LocaleKeys.discountedPriceLabel.tr(),
      name: config.name.tr(),
      monthlyFullPrice: canUseSalesValues ? oldPrice?.toString() : null,
      monthlyDiscountedPrice: canUseSalesValues ? price.toString() : null,
      fullPrice: '$money',
      bestValueBadge: isBestValue ? LocaleKeys.subscriptionPlanBestValue.tr() : null,
      promoBadge: discount > 0 && canUseSalesValues
          ? LocaleKeys.subscriptionPlanSavePercent.tr(args: [discount.toString()])
          : null,
      icon: isBasic ? UntitledUI.star_04 : UntitledUI.stars_02,
      perMonth: LocaleKeys.perMonth.tr(),
      periodLabel: period.tr(),
    );
  }

  List<String> _getPreviewFeatures(SubscriptionPlansStore store, PurchasableProduct product) {
    final config = store.findConfig(product);
    final allFeatures = config.previewFeatures.map((it) => it.tr()).toList();
    final isBasic = config.name == LocaleKeys.subscriptionPlanNameBasic;
    final featureCount = isBasic ? 3 : 4;
    return allFeatures.take(featureCount).toList();
  }
}
