// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/bottom_spacer.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/ripple.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/components/svg_icon_button.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/purchasable_product.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/subscription_store.dart';
import 'package:mysterium_vpn/views/subscription/subscription_button.dart';
import 'package:mysterium_vpn/views/subscription/widgets/billing_text.dart';
import 'package:mysterium_vpn/views/subscription/widgets/discount_tag.dart';
import 'package:mysterium_vpn/views/subscription/widgets/highlighted_product.dart';
import 'package:styled_widget/styled_widget.dart';

Future<void> shownProductPickerDialog({
  required BuildContext context,
  required AnalyticsStore analyticsStore,
  required List<PurchasableProduct> products,
  required SubscriptionStore subscriptionStore,
  required void Function(String selectedProductId) subscribeToPackage,
  required bool isDarkTheme,
  required bool seeAllPlans,
}) async {
  analyticsStore.logEvent(AnalyticsEvent.paymentSelectProductPopup);
  showModalBottomSheet(
    clipBehavior: Clip.none,
    constraints: const BoxConstraints.tightFor(width: double.infinity),
    context: context,
    isScrollControlled: true,
    backgroundColor: Theme.of(context).primaryColor,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(30)),
    ),
    builder: (context) => Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: _ProductPickerDialog(
        analyticsStore: analyticsStore,
        products: products,
        subscriptionStore: subscriptionStore,
        subscribeToPackage: subscribeToPackage,
        isDarkMode: isDarkTheme,
        seeAllPlansInit: seeAllPlans,
      ),
    ),
  );
}

class _ProductPickerDialog extends HookWidget {
  const _ProductPickerDialog({
    required this.subscriptionStore,
    required this.analyticsStore,
    required this.products,
    required this.subscribeToPackage,
    required this.isDarkMode,
    required this.seeAllPlansInit,
  });
  final SubscriptionStore subscriptionStore;
  final AnalyticsStore analyticsStore;
  final List<PurchasableProduct> products;
  final void Function(String selectedProductId) subscribeToPackage;
  final bool isDarkMode;
  final bool seeAllPlansInit;
  @override
  Widget build(BuildContext context) {
    final selectedProductId = useState<String>(
      subscriptionStore.purchasedProductId ?? subscriptionStore.products.last.id,
    );
    final seeAllPlans = useState(seeAllPlansInit);
    return Observer(
      builder: (context) => Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.center,
        children: [
          Positioned(
            top: 10,
            right: 20,
            child: SizedBox(
              width: 40,
              height: 40,
              child: SvgIconButton(
                asset: isDarkMode ? Assets.closeDark : Assets.closeLight,
                onPressed: Navigator.of(context).pop,
              ),
            ),
          ),
          Container(
            width: double.infinity,
            padding: getMediaWidth(context) > 950
                ? const EdgeInsets.symmetric(
                    horizontal: 150,
                    vertical: 20,
                  )
                : getMediaWidth(context) > 650
                    ? const EdgeInsets.symmetric(
                        horizontal: 80,
                        vertical: 20,
                      )
                    : const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 20,
                      ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                EasyText(
                  seeAllPlans.value
                      ? LocaleKeys.selectYourSubscription.tr()
                      : LocaleKeys.pricingPlanTitle.tr(),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                SizedBox(height: getMediaHeight(context) * 0.02),
                if (seeAllPlans.value)
                  _ProductsContainer(
                    products: products,
                    selectedProductId: selectedProductId,
                    isDarkTheme: isDarkMode,
                    analyticsStore: analyticsStore,
                  )
                else
                  HighlightedProduct(
                    product: products.first,
                    isDarkTheme: isDarkMode,
                    monthlyRawPrice: products.last.rawPrice,
                    showDiscountTag: true,
                    isHighlighted: false,
                  ),
                SizedBox(height: getMediaHeight(context) * 0.04),
                SubscriptionButton(
                  onPressed: () {
                    analyticsStore.logEvent(AnalyticsEvent.clickLetsgoProductPopup);
                    Navigator.of(context).pop();
                    subscribeToPackage(selectedProductId.value);
                  },
                  isLoading: subscriptionStore.isLoading,
                  label: LocaleKeys.letsGoBtn.tr(),
                ),
                Visibility(
                  visible: !seeAllPlans.value && !subscriptionStore.isLoading,
                  child: TextButton(
                    onPressed: () {
                      analyticsStore.logEvent(AnalyticsEvent.clickSeeAllPlansProductPopup);
                      seeAllPlans.value = !seeAllPlans.value;
                    },
                    child: EasyText(
                      LocaleKeys.pricingPlanSeePlansBtn.tr(),
                      color: Palette.purple,
                    ),
                  ),
                ),
                const BottomSpacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ProductsContainer extends StatelessWidget {
  const _ProductsContainer({
    required this.products,
    required this.selectedProductId,
    required this.isDarkTheme,
    required this.analyticsStore,
  });
  final List<PurchasableProduct> products;
  final ValueNotifier<String> selectedProductId;
  final bool isDarkTheme;
  final AnalyticsStore analyticsStore;
  @override
  Widget build(BuildContext context) => DecoratedBox(
        decoration: BoxDecoration(
          color: isDarkTheme ? const Color(0xff23222D) : const Color(0xff363355),
          borderRadius: const BorderRadius.all(Radius.circular(16)),
          border: Border.all(color: Palette.purple, width: 1.5),
        ),
        child: ListView.separated(
          shrinkWrap: true,
          padding: EdgeInsets.zero,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: products.length,
          itemBuilder: (context, index) => ContaineredProduct(
            selectProdcut: () {
              analyticsStore.logProductSelected(
                products[index].id,
                products.map((e) => e.id).toList(),
              );
              selectedProductId.value = products[index].id;
            },
            product: products[index],
            monthlyRawPrice: products.last.rawPrice,
            showDiscountTag: products[index].id == products.first.id,
            isSelected: selectedProductId.value == products[index].id,
            isDarkTheme: false,
          ),
          separatorBuilder: (context, index) => const Divider(
            color: Color.fromRGBO(106, 103, 142, 0.4),
            thickness: 1,
            height: 1,
          ),
        ),
      );
}

class ContaineredProduct extends StatelessWidget {
  const ContaineredProduct({
    required this.product,
    required this.isDarkTheme,
    required this.monthlyRawPrice,
    required this.showDiscountTag,
    required this.isSelected,
    this.selectProdcut,
    super.key,
  });
  final PurchasableProduct product;
  final double monthlyRawPrice;
  final bool isDarkTheme;
  final VoidCallback? selectProdcut;
  final bool showDiscountTag;
  final bool isSelected;

  @override
  Widget build(BuildContext context) => RippleWidget(
        onTap: selectProdcut,
        radius: 0,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                EasyText(
                  product.id.tr(),
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: !isDarkTheme ? Palette.white : null,
                ),
                const SizedBox(width: 8),
                if (showDiscountTag)
                  DiscountTag(
                    monthlyRawPrice: monthlyRawPrice,
                    product: product,
                  ),
                if (isSelected) ...[
                  const Spacer(),
                  const SvgIcon(
                    asset: Assets.checkmark,
                  ),
                ],
              ],
            ),
            RichText(
              text: TextSpan(
                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontSize: 14,
                    ),
                children: [
                  TextSpan(
                    text: product.monthlyPrice,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Palette.purple,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  TextSpan(
                    text: LocaleKeys.perMonth.tr(),
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: Palette.purple,
                          fontSize: 14,
                        ),
                  ),
                ],
              ),
            ),
            BillingText(product: product, isDarkTheme: isDarkTheme),
          ],
        ).padding(horizontal: 16, vertical: 12).width(double.infinity),
      );
}
