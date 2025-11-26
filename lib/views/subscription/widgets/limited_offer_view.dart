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
import 'package:mysterium_vpn/common/hooks/show_products_hook.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
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
import 'package:mysterium_vpn/stores/subscription_limited_time_offer_store.dart';
import 'package:url_launcher/url_launcher.dart';

class LimitedOfferView extends HookConsumerWidget {
  const LimitedOfferView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionStore = ref.watch(subscriptionLimitedTimeOfferStorePOD);
    final remoteConfigStore = ref.watch(remoteConfigStorePOD);
    final handleSubscribeToProduct = useHandleSubscribeToProduct();
    final showProducts = useShowProducts();

    return Observer(
      builder: (context) {
        final offer = subscriptionStore.future.value;

        if (offer == null) {
          return const Center(child: LoadingIndicator());
        }

        final product = offer.product;

        Future<void> handleSubscribe() async {
          await handleSubscribeToProduct(product.id);
        }

        return _Content(
          offer: offer,
          onPressed: handleSubscribe,
          onShowProductsPressed: showProducts,
          image: remoteConfigStore.limitedTimeOfferImage ?? Asset.images.purchasePromo,
          title: LocaleKeys.purchasePromoTitle.tr(
            args: [subscriptionStore.discountPercent.toString()],
          ),
          subtitle: LocaleKeys.purchasePromoSubtitle.tr(),
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
    required this.offer,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.features,
    required this.onPressed,
    required this.onShowProductsPressed,
  });

  final Object? image;
  final String title;
  final String subtitle;
  final LimitedTimeOffer offer;
  final List<String> features;
  final VoidCallback onPressed;
  final VoidCallback onShowProductsPressed;

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
                _Plan(offer: offer),
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
                      _SubscribeButton(product: offer.product),
                      TextButton(
                        onPressed: onShowProductsPressed,
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
      final String path when path.startsWith('http') => Image.network(
          path,
          width: size.width,
          height: size.height,
          fit: BoxFit.contain,
        ),
      final String path when path.endsWith('.svg') => SvgGenImage(path).svg(
          width: size.width,
          height: size.height,
        ),
      final String path => Image.asset(
          path,
          width: size.width,
          height: size.height,
          fit: BoxFit.contain,
        ),
      _ => SizedBox.fromSize(size: size),
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
            color: const Color(0xFFE651FF),
            fontSize: 34,
            fontWeight: FontWeight.w700,
            textAlign: TextAlign.center,
            height: 35 / 34,
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
  const _Plan({required this.offer});

  final LimitedTimeOffer offer;

  @override
  Widget build(BuildContext context) {
    final planName = switch (offer.product.planDetails.id) {
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
                        text: offer.offer.price.pricePerMonth(
                          months: offer.product.duration,
                          currencySymbol: offer.product.currencySymbol,
                          currencyCode: offer.product.currencyCode,
                        ),
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 20),
                      ),
                      TextSpan(
                        text: LocaleKeys.perMonth.tr(),
                        style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                AutoSizeText.rich(
                  style: GoogleFonts.montserrat(color: Palette.white),
                  TextSpan(
                    children: [
                      TextSpan(
                        text: offer.offer.fullPrice.pricePerYear(
                          months: offer.product.duration,
                          currencySymbol: offer.product.currencySymbol,
                          currencyCode: offer.product.currencyCode,
                        ),
                        style: const TextStyle(
                          decoration: TextDecoration.lineThrough,
                          decorationColor: Palette.white,
                        ),
                      ),
                      CharacterSpan.space(),
                      TextSpan(
                        text: offer.offer.price.pricePerYear(
                          months: offer.product.duration,
                          currencySymbol: offer.product.currencySymbol,
                          currencyCode: offer.product.currencyCode,
                        ),
                      ),
                      CharacterSpan.space(),
                      TextSpan(
                        text: switch (offer.product.duration) {
                          12 => LocaleKeys.pricingIntroductoryPeriod12.tr(),
                          6 => LocaleKeys.pricingIntroductoryPeriod6.tr(),
                          _ => '',
                        },
                      ),
                    ],
                  ),
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
            child: _Sticker(endDate: offer.expiryDate),
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
        children: <Widget>[
          for (final feature in features)
            Padding(
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
        ]
            .separateWith(
              Divider(
                height: 1,
                thickness: 1,
                color: Palette.lightBlack.withValues(alpha: .4),
              ),
            )
            .toList(),
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

    LinkSpan buildLinkSpan(String text) => LinkSpan(
          text: text,
          onTap: () {
            if (text == LocaleKeys.privacyPolicy.tr()) {
              launchUrl(Uri.parse(privacyPolicyUrl));
            } else if (text == LocaleKeys.termsAndConditions.tr()) {
              launchUrl(Uri.parse(termsOfServiceUrl));
            }
          },
        );

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
                if (highlights.isNotEmpty) buildLinkSpan(highlights.removeLast()),
              ],
            ),
        ].separateWith(CharacterSpan.space()).toList(),
      ),
    );
  }
}

class _SubscribeButton extends HookConsumerWidget {
  const _SubscribeButton({required this.product});

  final PurchasableProduct product;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final store = ref.watch(subscriptionStorePOD);
    final handleSubscribe = useHandleSubscribeToProduct();
    return Observer(
      builder: (context) {
        final isLoading = store.isSubscriptionLoading;
        if (isLoading) {
          return const SizedBox(child: LoadingIndicator());
        }

        return EasyButton(
          width: 230,
          onPressed: () => handleSubscribe(product.id),
          color: Palette.purple,
          text: LocaleKeys.purchasePromoCTA.tr(),
          useSystemColor: false,
        );
      },
    );
  }
}
