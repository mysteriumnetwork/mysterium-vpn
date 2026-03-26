import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/layout_builders/screen_type_builder.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn/components/colored_scaffold.dart';
import 'package:mysterium_vpn/components/loading_barrier.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/welcome/welcome_desktop_view.dart';
import 'package:mysterium_vpn/views/welcome/welcome_mobile_view.dart';

class WelcomePage extends HookConsumerWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authStore = ref.watch(authStorePOD);
    final authSessionStore = ref.watch(authSessionStorePOD);
    final analyticsStore = ref.watch(analyticsStorePOD);

    useReaction(() => authSessionStore.authShown, (authShown) {
      if (authShown) {
        return;
      }
      Future.microtask(() async {
        authSessionStore.authShown = true;
      });
    }, fireImmediately: true);

    return ColoredScaffold(
      body: Observer(
        builder: (context) => Stack(
          children: [
            ScreenTypeLayoutBuilder(
              mobile: (BuildContext context) => WelcomeMobileView(
                onSignInPressed: () {
                  analyticsStore.logEvent(AnalyticsEvent.signInButton);
                  authStore.loginDesktop();
                },
              ),
              tablet: (BuildContext context) => WelcomeDesktopView(
                onSignIn: () {
                  analyticsStore.logEvent(AnalyticsEvent.signInButton);
                  authStore.loginDesktop();
                },
              ),
              desktop: (BuildContext context) => WelcomeDesktopView(
                onSignIn: () {
                  analyticsStore.logEvent(AnalyticsEvent.signInButton);
                  authStore.loginDesktop();
                },
              ),
            ),
            if (authStore.authenticateFeature?.status == FutureStatus.pending)
              const LoadingBarrier(color: Palette.darkBlue),
          ],
        ),
      ),
    );
  }
}
