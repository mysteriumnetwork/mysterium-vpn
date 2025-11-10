import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/components/spans/character_span.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/subscription/widgets/discount_tag.dart';

class ProductPricing extends HookConsumerWidget {
  const ProductPricing({
    required this.product,
    super.key,
  });

  final PurchasableProduct product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final configStore = ref.watch(remoteConfigStorePOD);
    final subscriptionStore = ref.watch(subscriptionStorePOD);

    final monthlyProduct = useComputedValue(() => subscriptionStore.monthlyProduct);
    final discountPercentage = useComputedValue(
      () {
        if (monthlyProduct == null) {
          return 0;
        }
        return product.periodDiscountPercentage(monthlyProduct);
      },
      [monthlyProduct],
    );

    final pricingMonthly = useComputedValue(() => configStore.pricingMonthly);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          spacing: 8,
          children: [
            Text(
              product.id.tr(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            if (discountPercentage > 0) DiscountTag(discountPercentage: discountPercentage),
          ],
        ),
        if (pricingMonthly)
          _MonthlyPricing(product: product)
        else if (monthlyProduct != null)
          _RegularPricing(monthlyPrice: monthlyProduct.rawPrice, product: product),
      ],
    );
  }
}

class _RegularPricing extends HookWidget {
  const _RegularPricing({
    required this.monthlyPrice,
    required this.product,
  });

  final double monthlyPrice;
  final PurchasableProduct product;

  @override
  Widget build(BuildContext context) {
    final top = useMemoized<List<TextSpan>>(
      () => [
        TextSpan(
          text: product.rawPrice.price(
            currencySymbol: product.currencySymbol,
            currencyCode: product.currencyCode,
          ),
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        CharacterSpan.space(),
        CharacterSpan.slash(),
        TextSpan(
          text: switch (product.duration) {
            12 => LocaleKeys.year.tr(),
            6 => LocaleKeys.SixMonths.tr(),
            1 => LocaleKeys.month.tr(),
            _ => '',
          },
        ),
      ],
      [product, context.locale],
    );

    final bottom = useMemoized<List<TextSpan>>(
      () {
        if (product.duration == 1 || !product.hasIntroductoryPrice) {
          return [
            TextSpan(
              text: switch (product.duration) {
                12 => LocaleKeys.billedEveryYear.tr(namedArgs: {'amount': ''}).trim(),
                6 => LocaleKeys.billedEvery6Months.tr(namedArgs: {'amount': ''}).trim(),
                1 => LocaleKeys.billedEveryMonth.tr(namedArgs: {'amount': ''}).trim(),
                _ => '',
              },
            ),
          ];
        }

        return [
          TextSpan(
            text: product.productPrice.price(
              currencySymbol: product.currencySymbol,
              currencyCode: product.currencyCode,
            ),
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          CharacterSpan.space(),
          TextSpan(
            text: switch (product.duration) {
              12 => LocaleKeys.pricingIntroductoryPeriod12.tr(),
              6 => LocaleKeys.pricingIntroductoryPeriod6.tr(),
              _ => '',
            },
          ),
          CharacterSpan.space(),
          TextSpan(text: LocaleKeys.then.tr()),
          CharacterSpan.space(),
          TextSpan(
            text: product.rawPrice.price(
              currencySymbol: product.currencySymbol,
              currencyCode: product.currencyCode,
            ),
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          CharacterSpan.space(),
          CharacterSpan.slash(),
          TextSpan(
            text: switch (product.duration) {
              12 => LocaleKeys.year,
              6 => LocaleKeys.SixMonths,
              _ => '',
            },
          ),
        ];
      },
      [monthlyPrice, product, context.locale],
    );

    return Text.rich(
      TextSpan(
        children: [
          TextSpan(
            children: top,
            style: const TextStyle(color: Palette.purple),
          ),
          if (bottom.isNotEmpty) CharacterSpan.newline(),
          if (bottom.isNotEmpty) TextSpan(children: bottom),
        ],
      ),
      style: const TextStyle(fontSize: 12),
    );
  }
}

class _MonthlyPricing extends HookWidget {
  const _MonthlyPricing({required this.product});

  final PurchasableProduct product;

  @override
  Widget build(BuildContext context) {
    final top = useMemoized<List<TextSpan>>(
      () => [
        TextSpan(
          text: product.monthlyPrice,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
        ),
        CharacterSpan.space(),
        CharacterSpan.slash(),
        TextSpan(text: LocaleKeys.month.tr()),
      ],
      [product, context.locale],
    );

    final bottom = useMemoized<List<TextSpan>>(
      () {
        if (product.duration == 1) {
          return [
            TextSpan(text: LocaleKeys.billedEveryMonth.tr(namedArgs: {'amount': ''}).trim()),
          ];
        }

        late final List<TextSpan> introductory;
        if (product.hasIntroductoryPrice) {
          introductory = [
            TextSpan(
              text: product.productPrice.price(
                currencySymbol: product.currencySymbol,
                currencyCode: product.currencyCode,
              ),
              style: const TextStyle(fontWeight: FontWeight.w700),
            ),
            CharacterSpan.space(),
            TextSpan(
              text: switch (product.duration) {
                12 => LocaleKeys.pricingIntroductoryPeriod12.tr(),
                6 => LocaleKeys.pricingIntroductoryPeriod6.tr(),
                _ => '',
              },
            ),
            CharacterSpan.space(),
            TextSpan(text: LocaleKeys.renewsFor.tr()),
            CharacterSpan.space(),
          ];
        } else {
          introductory = [];
        }
        return [
          ...introductory,
          TextSpan(
            text: product.rawPrice.price(
              currencySymbol: product.currencySymbol,
              currencyCode: product.currencyCode,
            ),
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          CharacterSpan.space(),
          CharacterSpan.slash(),
          TextSpan(
            text: switch (product.duration) {
              12 => LocaleKeys.year.tr(),
              6 => LocaleKeys.SixMonths.tr(),
              1 => LocaleKeys.month.tr(),
              _ => '',
            },
          ),
        ];
      },
      [product, context.locale],
    );
    return Text.rich(
      TextSpan(
        children: [
          TextSpan(children: top, style: const TextStyle(color: Palette.purple)),
          if (bottom.isNotEmpty) CharacterSpan.newline(),
          if (bottom.isNotEmpty) TextSpan(children: bottom),
        ],
      ),
      style: const TextStyle(fontSize: 12),
    );
  }
}
