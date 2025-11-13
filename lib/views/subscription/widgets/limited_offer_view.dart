import 'dart:convert';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:collection/collection.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/hooks/handle_subscribe_to_product_hook.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/common/utils/comparator_utils.dart';
import 'package:mysterium_vpn/components/circle_box.dart';
import 'package:mysterium_vpn/components/easy_button.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
import 'package:mysterium_vpn/components/spans/character_span.dart';
import 'package:mysterium_vpn/components/spans/link_span.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

class LimitedOfferView extends HookConsumerWidget {
  const LimitedOfferView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionStore = ref.watch(subscriptionStorePOD);
    final handleSubscribeToProduct = useHandleSubscribeToProduct();

    return Observer(
      builder: (context) {
        final product = subscriptionStore.highlightedProduct ??
            subscriptionStore.productsFuture.value
                ?.sortedByCompare((it) => it.duration, compareNums)
                .lastOrNull;

        if (product == null) {
          return const Center(child: LoadingIndicator());
        }

        Future<void> handleSubscribe() async {
          await handleSubscribeToProduct(product.id);
          if (context.mounted) {
            Navigator.of(context).pop();
          }
        }

        return _Content(
          product: product,
          onPressed: handleSubscribe,
          image: Asset.images.purchasePromo,
          title: LocaleKeys.purchasePromoTitle.tr(args: ['50']),
          subtitle: LocaleKeys.purchasePromoSubtitle.tr(),
          endDate: DateTime.now().add(const Duration(days: 7)),
          features: (jsonDecode(LocaleKeys.purchasePromoFeatures.tr()) as Iterable)
              .map((it) => it.toString())
              .toList(),
        );
      },
    );
  }
}

class _Content extends StatelessWidget {
  const _Content({
    required this.image,
    required this.title,
    required this.subtitle,
    required this.product,
    required this.features,
    required this.endDate,
    required this.onPressed,
  });

  final Object? image;
  final String title;
  final String subtitle;
  final PurchasableProduct product;
  final List<String> features;
  final DateTime endDate;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(bottom: 48, left: 24, right: 24),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 482),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 320),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    spacing: 8,
                    children: [
                      _Image(image: image),
                      _Title(title: title, subtitle: subtitle),
                    ],
                  ),
                ),
                const SizedBox(height: 36),
                _Plan(product: product, endDate: endDate),
                const SizedBox(height: 24),
                _Features(features: features),
                const SizedBox(height: 16),
                ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 240),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: ScreenType.of(context) <= ScreenType.mobile
                        ? CrossAxisAlignment.stretch
                        : CrossAxisAlignment.center,
                    spacing: 16,
                    children: [
                      EasyButton(
                        width: 230,
                        onPressed: onPressed,
                        color: Palette.purple,
                        text: LocaleKeys.purchasePromoCTA.tr(),
                        useSystemColor: false,
                      ),
                      TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          foregroundColor: Palette.purple,
                          visualDensity: VisualDensity.comfortable,
                          minimumSize: const Size(230, 50),
                          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        child: Text(LocaleKeys.purchasePromoSeeAllPlans.tr()),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                const _Footer(),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      );
}

class _Image extends StatelessWidget {
  const _Image({required this.image});

  final Object? image;

  @override
  Widget build(BuildContext context) {
    final size =
        ScreenType.of(context) <= ScreenType.mobile ? const Size(150, 150) : const Size(180, 180);

    final image = this.image ?? Asset.images.purchasePromo;

    return switch (image) {
      final AssetGenImage assetRaster => assetRaster.image(
          width: size.width,
          height: size.height,
          fit: BoxFit.contain,
        ),
      final SvgGenImage assetVector => assetVector.svg(
          width: size.width,
          height: size.height,
        ),
      _ => Image.network(
          image.toString(),
          width: size.width,
          height: size.height,
          fit: BoxFit.contain,
        )
    };
  }
}

class _Title extends StatelessWidget {
  const _Title({
    required this.title,
    required this.subtitle,
  });

  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          EasyText(
            title,
            color: Palette.purple,
            fontSize: 34,
            fontWeight: FontWeight.w700,
            textAlign: TextAlign.center,
          ),
          EasyText(
            subtitle,
            color: Palette.white,
            fontSize: 30,
            textAlign: TextAlign.center,
            fontWeight: FontWeight.w600,
          ),
        ],
      );
}

class _Plan extends StatelessWidget {
  const _Plan({required this.product, required this.endDate});

  final PurchasableProduct product;
  final DateTime endDate;

  @override
  Widget build(BuildContext context) {
    final planName = switch (product.planDetails.id) {
      kAnnualPlan => LocaleKeys.plan_yearly.tr(),
      ksemiAnnualPlan => LocaleKeys.plan_6_months.tr(),
      kMonthlyPlan => LocaleKeys.plan_monthly.tr(),
      _ => LocaleKeys.plan_2_years.tr(),
    };

    return Stack(
      clipBehavior: Clip.none,
      children: [
        DecoratedBox(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: const Color(0xFF23222D),
            border: Border.all(color: Palette.purple),
          ),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                EasyText(
                  planName,
                  color: Palette.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                ),
                AutoSizeText.rich(
                  style: GoogleFonts.montserrat(color: Palette.purple),
                  TextSpan(
                    children: [
                      TextSpan(
                        text: product.monthlyPrice,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                      ),
                      TextSpan(
                        text: LocaleKeys.perMonth.tr(),
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                EasyText(
                  product.annualPrice,
                  color: Palette.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ],
            ),
          ),
        ),
        Positioned(
          top: -24,
          right: 24,
          child: Transform.rotate(
            angle: -0.174533, // -10 degrees in radians
            child: _Sticker(endDate: endDate),
          ),
        ),
      ],
    );
  }
}

class _Sticker extends StatelessWidget {
  const _Sticker({required this.endDate});

  final DateTime endDate;

  @override
  Widget build(BuildContext context) {
    final formattedDate = DateFormat('d MMM y').format(endDate);
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 110),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: const Color(0xFFff3438),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Stack(
          children: [
            const Positioned(
              top: 6,
              right: 6,
              child: CircleBox(color: Color(0xFF161424), size: 12),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: EasyText(
                [
                  LocaleKeys.purchasePromoEnds.tr(args: ['']),
                  formattedDate,
                ].join('\n'),
                maxLines: 2,
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Features extends StatelessWidget {
  const _Features({required this.features});

  final List<String> features;

  @override
  Widget build(BuildContext context) => Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        spacing: 2,
        children: [
          for (final feature in features)
            DecoratedBox(
              decoration: BoxDecoration(
                border: Border(bottom: BorderSide(color: Palette.lightBlack.withValues(alpha: .4))),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Row(
                  spacing: 12,
                  children: [
                    Asset.icons.checkmarkGreen.svg(height: 18),
                    Expanded(
                      child: EasyText(
                        feature,
                        color: Palette.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                        maxLines: 2,
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      );
}

class _Footer extends StatelessWidget {
  const _Footer();

  @override
  Widget build(BuildContext context) {
    final text = LocaleKeys.purchasePromoPPTOC.tr();
    final segments = text.split('{}').map((it) => it.trim()).whereNot((it) => it.isEmpty).toList();
    final highlights = [
      LocaleKeys.privacyPolicy.tr(),
      LocaleKeys.termsAndConditions.tr(),
    ].reversed.toList();

    return AutoSizeText.rich(
      textAlign: TextAlign.center,
      maxLines: 2,
      maxFontSize: 14,
      style: GoogleFonts.montserrat(
        fontWeight: FontWeight.w400,
        color: Palette.white,
      ),
      TextSpan(
        children: [
          for (final segment in segments)
            TextSpan(
              children: [
                TextSpan(text: segment),
                CharacterSpan.space(),
                LinkSpan(text: highlights.removeLast(), onTap: () {}),
              ],
            ),
        ].separateWith(CharacterSpan.space()).toList(),
      ),
    );
  }
}
