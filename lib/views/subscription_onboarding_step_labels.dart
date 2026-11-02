import 'package:mysterium_vpn/common/enums/subscription_onboarding_step.dart';
import 'package:mysterium_vpn/generated/l10n.dart';

extension SubscriptionOnboardingStepLabels on SubscriptionOnboardingStep {
  String title({required bool wideLayout}) => switch (this) {
    SubscriptionOnboardingStep.connectButton => S.current.subscriptionOnboardingConnectTitle,
    SubscriptionOnboardingStep.locations => S.current.subscriptionOnboardingVPNLocationsTitle,
    SubscriptionOnboardingStep.map =>
      wideLayout
          ? S.current.subscriptionOnboardingMapDesktopTitle
          : S.current.subscriptionOnboardingMapMobileTitle,
    SubscriptionOnboardingStep.products => S.current.subscriptionOnboardingManagePlanTitle,
    SubscriptionOnboardingStep.search => S.current.subscriptionOnboardingSearchTitle,
    SubscriptionOnboardingStep.settings => S.current.subscriptionOnboardingBoostProtectionTitle,
  };

  String description({required bool wideLayout}) => switch (this) {
    SubscriptionOnboardingStep.connectButton => S.current.subscriptionOnboardingConnectDescription,
    SubscriptionOnboardingStep.locations =>
      wideLayout
          ? S.current.subscriptionOnboardingVPNLocationsDesktopDescription
          : S.current.subscriptionOnboardingVPNLocationsMobileDescription,
    SubscriptionOnboardingStep.map =>
      wideLayout
          ? S.current.subscriptionOnboardingMapDesktopDescription
          : S.current.subscriptionOnboardingMapMobileDescription,
    SubscriptionOnboardingStep.products => S.current.subscriptionOnboardingManagePlanDescription,
    SubscriptionOnboardingStep.search => S.current.subscriptionOnboardingSearchDescription,
    SubscriptionOnboardingStep.settings =>
      S.current.subscriptionOnboardingBoostProtectionDescription,
  };
}
