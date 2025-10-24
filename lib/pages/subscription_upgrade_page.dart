import 'dart:async';

import 'package:auto_size_text/auto_size_text.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/list.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/dialogs/simple_menu_dialog.dart';
import 'package:mysterium_vpn/components/easy_button.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/loading_indicator.dart';
import 'package:mysterium_vpn/components/modal_page_scaffold.dart';
import 'package:mysterium_vpn/components/spans/character_span.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/purchasable_product.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';

Future<void> showSubscriptionUpgradePage(BuildContext context) async {
  final analyticsStore = ProviderScope.containerOf(context, listen: false).read(analyticsStorePOD);
  unawaited(analyticsStore.logSubscriptionUpgradePopupShow());
  final hasPickedUpgrade = await showModalPage<bool>(
    context,
    builder: (_) => _Page(),
  );
  unawaited(
    (hasPickedUpgrade ?? false)
        ? analyticsStore.logSubscriptionUpgradePopupConfirm()
        : analyticsStore.logSubscriptionUpgradePopupClose(),
  );
}

class _Page extends HookConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final subscriptionUpgradeStore = ref.watch(subscriptionUpgradeStorePOD);
    return ModalPageScaffold(
      padding: EdgeInsets.zero,
      child: Observer(
        builder: (context) {
          final downgradeProduct = subscriptionUpgradeStore.downgradeProduct;
          final product = subscriptionUpgradeStore.upgradeProduct;
          final discountPercent = subscriptionUpgradeStore.upgradeDiscountPercent;
          if (product == null || discountPercent == null || downgradeProduct == null) {
            return const Center(child: LoadingIndicator());
          }

          final planName = switch (product.planDetails.id) {
            kAnnualPlan => LocaleKeys.plan_yearly.tr(),
            ksemiAnnualPlan => LocaleKeys.plan_6_months.tr(),
            kMonthlyPlan => LocaleKeys.plan_monthly.tr(),
            _ => LocaleKeys.plan_2_years.tr(),
          };

          Future<void> handleUpgrade() async {
            Navigator.of(context).pop(true);
            await subscriptionUpgradeStore.upgrade();
          }

          return Align(
            alignment: Alignment.topCenter,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 32),
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 380),
                child: Column(
                  spacing: ScreenType.of(context) > ScreenType.mobile ? 16 : 32,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Center(
                      child: Badge(
                        label: Text(LocaleKeys.savePercent.tr(args: [discountPercent.toString()])),
                        backgroundColor: const Color(0xFF085D3A),
                        textColor: Palette.white,
                        textStyle:
                            const TextStyle(fontSize: 14, fontWeight: FontWeight.w500, height: 1),
                        largeSize: 24,
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
                      ),
                    ),
                    _Prompt(
                      planName: planName,
                      monthlyPrice: product.monthlyPrice,
                    ),
                    Asset.images.subscriptionUpgrade.image(width: 184, height: 184),
                    _Features(downgrade: downgradeProduct, upgrade: product),
                    _Footer(onUpgradePressed: handleUpgrade),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _Prompt extends StatelessWidget {
  const _Prompt({
    required this.planName,
    required this.monthlyPrice,
  });

  final String planName;
  final String monthlyPrice;

  @override
  Widget build(BuildContext context) => DefaultTextStyle(
        style: Theme.of(context).textTheme.bodyLarge ?? const TextStyle(),
        textAlign: TextAlign.center,
        child: Column(
          spacing: 24,
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            EasyText(
              LocaleKeys.upgradeToPlan.tr(args: [planName]),
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
            AutoSizeText.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: monthlyPrice,
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 48),
                  ),
                  TextSpan(
                    text: LocaleKeys.perMonth.tr(),
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
}

class _Features extends HookWidget {
  const _Features({
    required this.downgrade,
    required this.upgrade,
  });

  final PurchasableProduct downgrade;
  final PurchasableProduct upgrade;

  @override
  Widget build(BuildContext context) {
    const features = [
      LocaleKeys.upgradeFeature1,
      LocaleKeys.upgradeFeature2,
      LocaleKeys.upgradeFeature3,
    ];
    final autoSizeGroup = useMemoized(AutoSizeGroup.new);
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      spacing: 18,
      children: [
        for (final feature in features)
          _FeatureItem(
            text: feature,
            sizeGroup: autoSizeGroup,
            discountedPrice: upgrade.annualPrice,
            fullPrice: downgrade.annualPrice,
          ),
      ],
    );
  }
}

class _FeatureItem extends HookWidget {
  const _FeatureItem({
    required this.text,
    required this.sizeGroup,
    required this.fullPrice,
    required this.discountedPrice,
  });

  final String text;
  final AutoSizeGroup sizeGroup;
  final String fullPrice;
  final String discountedPrice;

  @override
  Widget build(BuildContext context) {
    final textStyle = Theme.of(context).textTheme.bodyMedium;
    final spans = useMemoized(
      () {
        final sections = text.tr(args: ['###']).split('###').toList();

        return sections
            .map((it) => TextSpan(text: it))
            .separateWith(
              TextSpan(
                children: [
                  TextSpan(
                    text: fullPrice,
                    style: const TextStyle(decoration: TextDecoration.lineThrough),
                  ),
                  CharacterSpan.space(),
                  TextSpan(
                    text: discountedPrice,
                    style: const TextStyle(fontWeight: FontWeight.w700),
                  ),
                ],
              ),
            )
            .toList();
      },
      [
        text,
        textStyle,
        fullPrice,
        discountedPrice,
        sizeGroup,
      ],
    );

    return Row(
      spacing: 8,
      children: [
        const Icon(Icons.check_circle_outline_rounded),
        AutoSizeText.rich(TextSpan(children: spans), style: textStyle),
      ],
    );
  }
}

class _Footer extends HookConsumerWidget {
  const _Footer({
    required this.onUpgradePressed,
  });

  final VoidCallback onUpgradePressed;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final analyticsStore = ref.read(analyticsStorePOD);
    void handleOpenUrl(String url) {
      unawaited(analyticsStore.logSubscriptionUpgradeInfoClick(url));
      openUrlLink(Uri.parse(url));
    }

    Future<void> showPrivacyMenu() async {
      await showSimpleMenu(
        context,
        items: [
          SimpleMenuItem(
            label: LocaleKeys.upgradePrivacyPolicy.tr(),
            onTap: () => handleOpenUrl(privacyPolicyUrl),
          ),
          SimpleMenuItem(
            label: LocaleKeys.upgradeTermsAndConditions.tr(),
            onTap: () => handleOpenUrl(termsOfServiceUrl),
          ),
          SimpleMenuItem(
            label: LocaleKeys.upgradeSubscriptionInfo.tr(),
            onTap: () => handleOpenUrl(subscriptionInfoUrl),
          ),
        ],
      );
    }

    return Column(
      spacing: 16,
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        EasyButton(
          color: Palette.purple,
          onPressed: onUpgradePressed,
          text: LocaleKeys.upgradeAndSave.tr(),
        ),
        EasyText(
          LocaleKeys.upgradeDisclaimerRefund.tr(),
          fontSize: 12,
          color: Theme.of(context).palette.darkTextColor,
          textAlign: TextAlign.center,
          maxLines: 3,
        ),
        TextButton(
          onPressed: showPrivacyMenu,
          child: EasyText(
            LocaleKeys.upgradeSubscriptionPrivacy.tr(),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
