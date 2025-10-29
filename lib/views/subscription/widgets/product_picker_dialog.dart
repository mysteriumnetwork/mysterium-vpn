// ignore_for_file: use_build_context_synchronously

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/asset.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/bottom_spacer.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/ripple.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/components/svg_icon_button.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/views/subscription/subscription_button.dart';
import 'package:mysterium_vpn/views/subscription/widgets/highlighted_product.dart';
import 'package:mysterium_vpn/views/subscription/widgets/product_pricing.dart';
import 'package:styled_widget/styled_widget.dart';

Future<void> shownProductPickerDialog({
  required BuildContext context,
  required List<PurchasableProduct> products,
  required void Function(String selectedProductId) subscribeToPackage,
  required bool seeAllPlans,
}) async {
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
        products: products,
        subscribeToPackage: subscribeToPackage,
        seeAllPlansInit: seeAllPlans,
      ),
    ),
  );
}

class _ProductPickerDialog extends HookConsumerWidget {
  const _ProductPickerDialog({
    required this.products,
    required this.subscribeToPackage,
    required this.seeAllPlansInit,
  });

  final List<PurchasableProduct> products;
  final void Function(String selectedProductId) subscribeToPackage;
  final bool seeAllPlansInit;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsStore = ref.watch(analyticsStorePOD);
    final subscriptionStore = ref.watch(subscriptionStorePOD);

    final highlightedProduct = useComputedValue(() => subscriptionStore.highlightedProduct);

    final selectedProductId = useState<String>(
      subscriptionStore.subscriptionFuture.value?.planId ?? highlightedProduct!.id,
    );

    final seeAllPlans = useState(seeAllPlansInit);

    useEffect(
      () {
        analyticsStore.logEvent(AnalyticsEvent.paymentSelectProductPopup);
        return;
      },
      [analyticsStore],
    );

    return Observer(
      builder: (context) {
        final isSubscriptionLoading =
            subscriptionStore.subscriptionFuture.status == FutureStatus.pending ||
                subscriptionStore.subscriptionStatus == SubscriptionStatus.pending ||
                subscriptionStore.subscriptionStatus == SubscriptionStatus.verifying;

        return Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 5,
              right: 8,
              child: SizedBox(
                width: 35,
                height: 35,
                child: SvgIconButton(
                  asset: Asset.icons.close(context),
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
                      analyticsStore: analyticsStore,
                    )
                  else
                    HighlightedProduct(
                      product: products.first,
                      isHighlighted: false,
                    ),
                  SizedBox(height: getMediaHeight(context) * 0.04),
                  SubscriptionButton(
                    onPressed: () {
                      analyticsStore.logEvent(AnalyticsEvent.clickLetsgoProductPopup);
                      Navigator.of(context).pop();
                      subscribeToPackage(selectedProductId.value);
                    },
                    isLoading: isSubscriptionLoading,
                    label: LocaleKeys.letsGoBtn.tr(),
                  ),
                  Visibility(
                    visible: !seeAllPlans.value && !isSubscriptionLoading,
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
        );
      },
    );
  }
}

class _ProductsContainer extends StatelessWidget {
  const _ProductsContainer({
    required this.products,
    required this.selectedProductId,
    required this.analyticsStore,
  });

  final List<PurchasableProduct> products;
  final ValueNotifier<String> selectedProductId;
  final AnalyticsStore analyticsStore;

  @override
  Widget build(BuildContext context) => ClipRRect(
        borderRadius: const BorderRadius.all(Radius.circular(16)),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: context.c.isDarkMode ? const Color(0xff23222D) : const Color(0xff363355),
            borderRadius: const BorderRadius.all(Radius.circular(16)),
            border: Border.all(color: Palette.purple, width: 1.5),
          ),
          child: ListView.separated(
            shrinkWrap: true,
            padding: EdgeInsets.zero,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: products.length,
            itemBuilder: (context, index) => ContaineredProduct(
              selectProduct: () {
                analyticsStore.logProductSelected(
                  products[index].id,
                  products.map((e) => e.id).toList(),
                );
                selectedProductId.value = products[index].id;
              },
              product: products[index],
              isSelected: selectedProductId.value == products[index].id,
            ),
            separatorBuilder: (context, index) => const Divider(
              color: Color.fromRGBO(106, 103, 142, 0.4),
              thickness: 1,
              height: 1,
            ),
          ),
        ),
      );
}

class ContaineredProduct extends StatelessWidget {
  const ContaineredProduct({
    required this.product,
    required this.isSelected,
    this.selectProduct,
    super.key,
  });

  final PurchasableProduct product;
  final VoidCallback? selectProduct;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return RippleWidget(
      onTap: selectProduct,
      radius: 0,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: DefaultTextStyle(
              style: theme.textTheme.bodyMedium!.copyWith(color: Palette.white),
              child: ProductPricing(product: product),
            ),
          ),
          if (isSelected)
            Padding(
              padding: const EdgeInsets.only(left: 8),
              child: SvgIcon(asset: Asset.icons.checkmark),
            ),
        ],
      ).padding(horizontal: 14, vertical: 14).width(double.infinity),
    );
  }
}
