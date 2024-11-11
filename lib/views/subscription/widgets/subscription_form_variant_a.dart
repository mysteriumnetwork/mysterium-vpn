import 'dart:io';

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/easy_text.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/services/data/local/local_db_service.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/subscription_store.dart';
import 'package:mysterium_vpn/views/consent/agreements.dart';
import 'package:mysterium_vpn/views/subscription/product_list_variant_a.dart';
import 'package:mysterium_vpn/views/subscription/subscription_button.dart';
import 'package:styled_widget/styled_widget.dart';

class SubscriptionFormVariantA extends HookConsumerWidget {
  const SubscriptionFormVariantA({
    required this.store,
    required this.localDb,
    required this.analyticsStore,
    required this.subscribeToPackage,
    required this.variant,
    super.key,
  });
  final SubscriptionStore store;
  final LocalDBService localDb;
  final AnalyticsStore analyticsStore;
  final void Function(String selectedProductId) subscribeToPackage;
  final String variant;
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedProductId =
        useState<String>(store.purchasedProductId ?? store.products.lastOrNull?.id ?? kPopularPlan);
    return Observer(
      builder: (context) => Column(
        children: [
          EasyText(
            LocaleKeys.selectPackage.tr(),
            fontSize: 20,
            fontWeight: FontWeight.w900,
          ),
          SizedBox(height: getMediaHeight(context) * 0.015),
          SubscriptionProductsListVariantA(
            products: store.products.reversed.toList(),
            selectedProductId: selectedProductId,
          ).padding(bottom: getMediaHeight(context) * 0.02),
          EasyText(
            LocaleKeys.freeTrialTitle.tr(),
            fontSize: 18,
            fontWeight: FontWeight.w800,
          ).padding(bottom: getMediaHeight(context) * 0.005),
          EasyText(
            LocaleKeys.freeTrialDesc.tr(),
            maxLines: 3,
            fontSize: 14,
            textAlign: TextAlign.center,
          ).padding(bottom: getMediaHeight(context) * 0.025),
          SubscriptionButton(
            onPressed: () {
              analyticsStore.logEvent(AnalyticsEvent.clickStartNow);
              subscribeToPackage(selectedProductId.value);
            },
            isLoading: store.isLoading,
            label: LocaleKeys.startTrialBtn.tr(),
          ),
          Visibility(
            visible: Platform.isIOS,
            child: TextButton(
              onPressed: () {
                analyticsStore.logEvent(AnalyticsEvent.redeemOpen);
                store.redeemCode();
              },
              child: EasyText(
                LocaleKeys.redeemCode.tr(),
                color: Palette.purple,
              ),
            ).padding(top: 10),
          ),
          SizedBox(height: getMediaHeight(context) * 0.025),
          Agreements(
            analyticsStore: analyticsStore,
          ),
        ],
      ).scrollable(),
    );
  }
}
