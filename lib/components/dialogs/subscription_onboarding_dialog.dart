import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

void showSubscriptionOnboardingDialog({
  required BuildContext context,
  required VoidCallback onStartTour,
  required VoidCallback onCancelTour,
}) {
  showModal(
    context,
    allowDismiss: false,
    builder: (context) => SizedBox(
      width: 343,
      height: 236,
      child: PromptDialog(
        screenType: ScreenType.desktop,
        image: const Icon(Icons.flag),
        title: LocaleKeys.subscriptionOnboardingPromptTitle.tr(),
        subtitle: LocaleKeys.subscriptionOnboardingPromptDescription.tr(),
        primaryButton: ButtonPrimary(
          onPressed: () {
            Navigator.pop(context);
            onStartTour();
          },
          child: Text(LocaleKeys.subscriptionOnboardingStartTourLabel.tr()),
        ),
        secondaryButton: ButtonSecondary(
          onPressed: () {
            Navigator.pop(context);
            onCancelTour();
          },
          child: Text(LocaleKeys.subscriptionOnboardingCancelTourLabel.tr()),
        ),
      ),
    ),
  );
}
