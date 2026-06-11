import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:mysterium_vpn/views/home/subscription_onboarding_showcase.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';
import 'package:showcaseview/showcaseview.dart';

void main() {
  group('subscriptionOnboardingStepsFor', () {
    test('returns mobile steps in showcase order', () {
      final steps = subscriptionOnboardingStepsFor(ScreenType.mobile);

      expect(steps.map((spec) => spec.step), [
        SubscriptionOnboardingStep.map,
        SubscriptionOnboardingStep.locations,
        SubscriptionOnboardingStep.products,
        SubscriptionOnboardingStep.settings,
        SubscriptionOnboardingStep.connect,
        SubscriptionOnboardingStep.search,
      ]);
      expect(steps.first.content.title, LocaleKeys.subscriptionOnboardingMapMobileTitle);
      expect(steps.first.position, TooltipPosition.top);
    });

    test('returns desktop steps in showcase order for tablet and desktop layouts', () {
      for (final screenType in [ScreenType.tablet, ScreenType.desktop]) {
        final steps = subscriptionOnboardingStepsFor(screenType);

        expect(steps.map((spec) => spec.step), [
          SubscriptionOnboardingStep.map,
          SubscriptionOnboardingStep.products,
          SubscriptionOnboardingStep.settings,
          SubscriptionOnboardingStep.connect,
          SubscriptionOnboardingStep.search,
          SubscriptionOnboardingStep.locations,
        ]);
        expect(steps.first.content.title, LocaleKeys.subscriptionOnboardingMapDesktopTitle);
        expect(steps.first.position, TooltipPosition.right);
      }
    });

    test('keeps desktop tooltip icons attached to their semantic content', () {
      final steps = {
        for (final spec in subscriptionOnboardingStepsFor(ScreenType.desktop)) spec.step: spec,
      };

      expect(steps[SubscriptionOnboardingStep.locations]!.content.icon, UntitledUI.flag_01);
      expect(steps[SubscriptionOnboardingStep.products]!.content.icon, UntitledUI.star_06);
      expect(steps[SubscriptionOnboardingStep.settings]!.content.icon, UntitledUI.lock_01);
      expect(steps[SubscriptionOnboardingStep.connect]!.content.icon, UntitledUI.rocket_02);
      expect(steps[SubscriptionOnboardingStep.search]!.content.icon, UntitledUI.search_sm);
    });
  });
}
