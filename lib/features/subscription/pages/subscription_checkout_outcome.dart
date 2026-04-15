import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/core/utils/utils.dart';
import 'package:mysterium_vpn/features/subscription/store/subscription_checkout_store.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';

void handleCheckoutOutcome(
  BuildContext context,
  SubscriptionCheckoutStore store,
  CheckoutOutcome outcome,
) {
  store.clearOutcome();
  switch (outcome) {
    case CheckoutOutcome.purchased:
      showSnackbar(LocaleKeys.subscriptionActive.tr());
      Navigator.of(context).pop();
    case CheckoutOutcome.alreadyActive:
      showSnackbar("You're all set! You already have this plan active");
      Navigator.of(context).pop();
    case CheckoutOutcome.webRedirectCompleted:
      Navigator.of(context).pop();
    case CheckoutOutcome.error:
      showError(store.error);
  }
}
