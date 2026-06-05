import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/subscription_onboarding_setup.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/dialogs/subscription_onboarding_dialog.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn/stores/auth/auth_session_store.dart';
import 'package:mysterium_vpn/stores/home_tabs_store.dart';
import 'package:mysterium_vpn/stores/subscription_store.dart';
import 'package:mysterium_vpn/stores/user_preferences_store.dart';
import 'package:mysterium_vpn_design/widgets/floating_button.dart';
import 'package:showcaseview/showcaseview.dart';

/// Shows the subscription onboarding dialog if the user is subscribed and the onboarding has not been shown yet.
void useSubscriptionOnboarding() {
  final context = useContext();
  final authSessionStore = useProvider<AuthSessionStore>(authSessionStorePOD);
  final subscriptionStore = useProvider<SubscriptionStore>(subscriptionStorePOD);
  final analyticsStore = useProvider<AnalyticsStore>(analyticsStorePOD);
  final homeTabsStore = useProvider<HomeTabsStore>(homeTabsStorePOD);
  final subscription = useComputedValue(() => subscriptionStore.subscriptionFuture.value);
  final userPrefStore = useProvider<UserPreferencesStore>(userPreferencesStorePOD);
  final onboarding = useProvider<SubscriptionOnboardingSetup>(subscriptionOnboardingSetupPOD);

  useMemoized(() {
    ShowcaseView.register(
      globalFloatingActionWidget: (context) => FloatingActionWidget(
        top: 50,
        right: 50,
        child: FloatingButton(
          onPressed: () => ShowcaseView.get().dismiss(),
          label: 'Skip',
          icon: Icons.close,
        ),
      ),
    );
    return null;
  });

  // Unregister the showcase view when the component is unmounted
  useEffect(() => ShowcaseView.get().unregister, []);

  useEffect(() {
    if (!authSessionStore.isAuthenticated) {
      return null;
    }

    Future.microtask(() async {
      // If the user is not subscribed, don't show the onboarding
      /* if (subscription == null || !subscription.active) {
        return null;
      } */

      // If the onboarding has already been shown, don't show it again
      /* final didShowSubscriptionOnboarding = await userPrefStore.getSubscriptionOnboardingShown();
      if (didShowSubscriptionOnboarding) {
        return;
      } */

      WidgetsBinding.instance.addPostFrameCallback((_) {
        userPrefStore.setSubscriptionOnboardingShown().ignore();

        showSubscriptionOnboardingDialog(
          context: context,
          onStartTour: () async {
            analyticsStore.logEvent(AnalyticsEvent.onboardingSubscribedStarted).ignore();

            if (isDesktop()) {
              homeTabsStore.trySelect(HomeTab.map);
            } else {
              final beamer = Beamer.of(context);
              if (beamer.configuration.uri.path != Routes.main.path) {
                beamer.beamToNamed(Routes.main.path);
              }
            }
            Future.delayed(
              const Duration(milliseconds: 500),
            ).then((_) => ShowcaseView.get().startShowCase(onboarding.orderedKeys));
          },
          onCancelTour: () {
            analyticsStore.logEvent(AnalyticsEvent.onboardingSubscribedSkipped).ignore();
          },
        );
      });
    });

    return null;
  }, [authSessionStore.isAuthenticated, subscription]);
}
