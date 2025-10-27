import 'package:beamer/beamer.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/asset.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/components/easy_button.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/modal_page_scaffold.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/purchasable_product.dart';

Future<void> showSubscriptionUpgradeSuccessDialog(
  BuildContext context, {
  required PurchasableProduct purchasedPlan,
}) async {
  await showModalPage(
    context,
    builder: (_) => _Page(purchasedPlan: purchasedPlan),
  );
}

class _Page extends StatelessWidget {
  const _Page({required this.purchasedPlan});

  final PurchasableProduct purchasedPlan;

  @override
  Widget build(BuildContext context) {
    final planName = switch (purchasedPlan.planDetails.id) {
      kAnnualPlan => LocaleKeys.plan_yearly.tr(),
      ksemiAnnualPlan => LocaleKeys.plan_6_months.tr(),
      kMonthlyPlan => LocaleKeys.plan_monthly.tr(),
      _ => LocaleKeys.plan_2_years.tr(),
    };

    void handleGoHome() {
      final beamer = Beamer.of(context);
      final navigator = Navigator.of(context);

      // clear navigation history
      while (beamer.removeLastHistoryElement() != null) {}
      // go to home
      beamer.beamToNamed(Routes.main.path);
      // close modal
      navigator.pop();
    }

    return ModalPageScaffold(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: DefaultTextStyle(
              style: const TextStyle(),
              textAlign: TextAlign.center,
              child: Column(
                spacing: 24,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Asset.icons.successCup(context).svg(),
                  EasyText(
                    LocaleKeys.upgradeSuccessTitle.tr(),
                    fontSize: 48,
                    fontWeight: FontWeight.w700,
                  ),
                  EasyText(
                    LocaleKeys.upgradeSuccessText.tr(args: [planName]),
                    maxLines: 3,
                  ),
                ],
              ),
            ),
          ),
          const Spacer(),
          EasyButton(
            onPressed: handleGoHome,
            text: LocaleKeys.goToHome.tr(),
            useSystemColor: false,
            color: Palette.purple,
          ),
        ],
      ),
    );
  }
}
