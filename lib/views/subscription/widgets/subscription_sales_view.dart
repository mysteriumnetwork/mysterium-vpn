import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/hooks/handle_subscribe_to_product_hook.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/spans/character_span.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/subscription/subscription_button.dart';
import 'package:mysterium_vpn/views/subscription/widgets/discount_tag.dart';
import 'package:mysterium_vpn/views/subscription/widgets/product_picker_dialog.dart';
import 'package:mysterium_vpn/views/subscription/widgets/sale_tag.dart';

class SubscriptionSalesView extends HookConsumerWidget {
  const SubscriptionSalesView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsStore = ref.watch(analyticsStorePOD);
    final subscriptionStore = ref.watch(subscriptionStorePOD);
    final isLoading = useComputedValue(() => subscriptionStore.isSubscriptionLoading);
    final product = useComputedValue(() => subscriptionStore.highlightedProduct);
    final products = useComputedValue(() => subscriptionStore.productsFuture.value ?? []);

    final handleSubscribeToProduct = useHandleSubscribeToProduct();

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (product != null)
          Center(child: SaleTag(discountPercentage: product.introductoryDiscountPercentage)),
        const SizedBox(height: 24),
        EasyText(
          LocaleKeys.pricingPlanSaleTitle.tr(),
          fontSize: 26,
          fontWeight: FontWeight.w700,
          textAlign: TextAlign.center,
          maxLines: 2,
          color: Palette.white,
        ),
        const SizedBox(height: 10),
        EasyText(
          LocaleKeys.pricingPlanSaleDesc.tr(),
          textAlign: TextAlign.center,
          maxLines: 2,
          color: Palette.white,
        ),
        const SizedBox(height: 40),
        if (product != null) _PlanCard(product: product),
        const SizedBox(height: 40),
        SubscriptionButton(
          onPressed: () {
            final id = product?.id;
            if (id == null) {
              return;
            }

            analyticsStore.logEvent(AnalyticsEvent.clickLetsgo);
            handleSubscribeToProduct(id);
          },
          isLoading: isLoading,
          label: LocaleKeys.letsGoBtn.tr(),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: () {
            analyticsStore.logEvent(AnalyticsEvent.clickSeeAllPlans);
            shownProductPickerDialog(
              context: context,
              products: products,
              subscribeToPackage: handleSubscribeToProduct,
              seeAllPlans: true,
            );
          },
          style: TextButton.styleFrom(
            foregroundColor: Palette.purple,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          child: Text(LocaleKeys.pricingPlanSeePlansBtn.tr()),
        ),
      ],
    );
  }
}

class _PlanCard extends HookConsumerWidget {
  const _PlanCard({required this.product});
  final PurchasableProduct product;

  @override
  Widget build(BuildContext context, WidgetRef ref) => DefaultTextStyle(
        style: GoogleFonts.montserrat(color: Colors.white),
        child: DecoratedBox(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: .1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 48),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 16,
              children: [
                EasyText(
                  product.productDetails.title,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  color: Palette.white,
                ),
                if (product.hasIntroductoryPrice)
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: LocaleKeys.now.tr()),
                        CharacterSpan.space(),
                        WidgetSpan(
                          child: DiscountTag(
                            discountPercentage: product.introductoryDiscountPercentage,
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                            colors: const [Color(0xffC544E6), Color(0xffC544E6)],
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: product.productPrice.toPriceString(currency: product.currency),
                        style: GoogleFonts.montserrat(fontSize: 34, fontWeight: FontWeight.w700),
                      ),
                      CharacterSpan.space(),
                      CharacterSpan.slash(),
                      if (product.hasIntroductoryPrice) ...[
                        TextSpan(text: LocaleKeys.first.tr()),
                        CharacterSpan.space(),
                      ],
                      TextSpan(
                        text: switch (product.duration) {
                          12 => LocaleKeys.year.tr(),
                          6 => LocaleKeys.SixMonths.tr(),
                          _ => LocaleKeys.month.tr(),
                        },
                      ),
                    ],
                  ),
                ),
                if (product.hasIntroductoryPrice)
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(text: LocaleKeys.was.tr()),
                        CharacterSpan.space(),
                        TextSpan(
                          text: product.rawPrice.toPriceString(currency: product.currency),
                          style: GoogleFonts.montserrat(fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                if (product.hasIntroductoryPrice)
                  EasyText(
                    LocaleKeys.subscriptionRenewalDisclaimer.tr(
                      namedArgs: {
                        'price': product.rawPrice.toPriceString(currency: product.currency),
                      },
                    ),
                    color: Palette.darkGrey,
                  ),
              ],
            ),
          ),
        ),
      );
}
