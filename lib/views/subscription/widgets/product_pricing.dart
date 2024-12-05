import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/spans/character_span.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/purchasable_product.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/subscription/widgets/discount_tag.dart';

class ProductPricing extends HookConsumerWidget {
  const ProductPricing({
    required this.product,
    this.showDiscount = false,
    this.monthlyPrice,
    super.key,
  });

  final PurchasableProduct product;
  final bool showDiscount;
  final double? monthlyPrice;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final monthlyPrice = this.monthlyPrice ?? product.rawPrice / product.duration;

    final config = ref.watch(remoteConfigStorePOD);
    final pricingMonthly = useComputedValue(() => config.pricingMonthly);

    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              product.id.tr(),
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
              ),
            ),
            const SizedBox(width: 8),
            if (showDiscount)
              DiscountTag(
                monthlyRawPrice: product.rawPrice,
                product: product,
              ),
          ],
        ),
        _PrimaryPriceText(
          product: product,
          monthlyPrice: monthlyPrice,
          pricingMonthly: pricingMonthly,
        ),
        _SecondaryPriceText(
          product: product,
          pricingMonthly: pricingMonthly,
        ),
      ],
    );
  }
}

class _PrimaryPriceText extends HookWidget {
  const _PrimaryPriceText({
    required this.product,
    required this.monthlyPrice,
    required this.pricingMonthly,
  });

  final bool pricingMonthly;
  final PurchasableProduct product;
  final double? monthlyPrice;

  @override
  Widget build(BuildContext context) {
    final amount = useMemoized(() {
      if (pricingMonthly) {
        return product.monthlyPrice;
      }
      return product.productPrice.price(
        currencySymbol: product.currencySymbol,
        currencyCode: product.currencyCode,
      );
    }, [
      product,
      pricingMonthly,
    ]);

    final fullAmount = useMemoized(() {
      if (pricingMonthly || monthlyPrice == null) {
        return null;
      }
      final amount = monthlyPrice! * product.duration;
      if (amount <= product.productPrice) {
        return null;
      }
      return amount.price(
        currencySymbol: product.currencySymbol,
        currencyCode: product.currencyCode,
      );
    }, [
      monthlyPrice,
      pricingMonthly,
    ]);

    final text = useMemoized(() {
      if (pricingMonthly) {
        return LocaleKeys.perMonth.tr();
      }
      return switch (product.duration) {
        12 => LocaleKeys.year.tr(),
        1 => null,
        _ => LocaleKeys.billedEveryPeriodMonths.tr(
            namedArgs: {'amount': product.duration.toString()},
          ).toLowerCase(),
      };
    }, [
      context.locale,
      product.duration,
    ]);

    return _PriceText(
      amount: amount,
      text: text,
      fullAmount: fullAmount,
      highlighted: true,
    );
  }
}

class _SecondaryPriceText extends HookWidget {
  const _SecondaryPriceText({
    required this.pricingMonthly,
    required this.product,
  });

  final bool pricingMonthly;
  final PurchasableProduct product;

  @override
  Widget build(BuildContext context) {
    final amount = useMemoized(() {
      if (product.duration == 1) {
        return null;
      }
      if (pricingMonthly) {
        return product.productPrice.price(
          currencySymbol: product.currencySymbol,
          currencyCode: product.currencyCode,
        );
      }

      final monthlyPrice = product.rawPrice / product.duration;

      return monthlyPrice.price(
        currencySymbol: product.currencySymbol,
        currencyCode: product.currencyCode,
      );
    }, [
      product,
      pricingMonthly,
    ]);

    final text = useMemoized(() {
      if (product.duration == 1) {
        return LocaleKeys.billedEveryMonth.tr(namedArgs: {'amount': ''}).trim();
      }
      if (!pricingMonthly) {
        return LocaleKeys.month.tr();
      }
      return switch (product.duration) {
        12 => LocaleKeys.year.tr(),
        _ => LocaleKeys.billedEveryPeriodMonths.tr(
            namedArgs: {'amount': product.duration.toString()},
          ).toLowerCase(),
      };
    }, [
      product,
      pricingMonthly,
      context.locale,
    ]);

    return _PriceText(amount: amount, text: text);
  }
}

class _PriceText extends HookWidget {
  const _PriceText({
    required this.amount,
    required this.text,
    this.fullAmount,
    this.highlighted = false,
  });

  final String? amount;
  final String? fullAmount;
  final String? text;
  final bool highlighted;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final baseStyle = useMemoized(
      () => DefaultTextStyle.of(context).style.copyWith(
            fontSize: highlighted ? 20 : 12,
            color: highlighted ? Palette.purple : null,
          ),
      [highlighted, theme.textTheme],
    );

    return RichText(
      text: TextSpan(
        style: baseStyle,
        children: [
          if (amount != null)
            TextSpan(
              text: amount,
              style: TextStyle(fontWeight: highlighted ? FontWeight.w900 : null),
            ),
          if (fullAmount != null)
            TextSpan(
              text: fullAmount,
              style: TextStyle(
                decoration: TextDecoration.lineThrough,
                decorationColor: baseStyle.color,
              ),
            ),
          if (text != null)
            TextSpan(
              text: text,
              style: const TextStyle(fontSize: 12),
            ),
        ].separateWith(CharacterSpan.space()).toList(),
      ),
    );
  }
}
