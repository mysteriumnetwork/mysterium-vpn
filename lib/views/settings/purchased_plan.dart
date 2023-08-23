import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/subscription.dart';
import 'package:styled_widget/styled_widget.dart';

class PurchasedPlan extends StatelessWidget {
  const PurchasedPlan({
    required this.subscription,
    super.key,
  });

  final Subscription subscription;
  @override
  Widget build(BuildContext context) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              EasyText(
                subscription.planId?.tr() ?? '',
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ).padding(right: 4),
              const SvgIcon(
                asset: Assets.subscription,
              ).height(25).width(25),
            ],
          ),
          EasyText(
            LocaleKeys.nextBilling.tr(
              namedArgs: {'date': subscription.activeUntil?.toLocal().formatWithDay() ?? ''},
            ),
          ),
          EasyText(
            LocaleKeys.paymentMethod.tr(namedArgs: {'method': subscription.gatewayName}),
          ),
        ],
      ).padding(bottom: 4);
}
