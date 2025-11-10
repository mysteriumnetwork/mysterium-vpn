import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/components/svg_icon.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/models/models.dart';
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
                fontSize: 14,
                fontWeight: FontWeight.bold,
              ).paddingDirectional(end: 4),
              SizedBox(
                width: 25,
                height: 25,
                child: SvgIcon(asset: Asset.icons.subscription),
              ),
            ],
          ),
          EasyText(
            LocaleKeys.nextBilling.tr(
              namedArgs: {'date': subscription.activeUntil?.toLocal().formatWithDay() ?? ''},
            ),
            fontSize: 12,
          ),
          EasyText(
            LocaleKeys.paymentMethod.tr(namedArgs: {'method': subscription.gatewayName}),
            fontSize: 12,
          ),
        ],
      ).padding(bottom: 4);
}
