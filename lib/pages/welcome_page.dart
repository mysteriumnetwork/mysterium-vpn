import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/layout_builders/screen_type_builder.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';
import 'package:mysterium_vpn/components/colored_scaffold.dart';
import 'package:mysterium_vpn/components/loading_barrier.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/services/auth/auth_status.dart';
import 'package:mysterium_vpn/views/welcome/welcome_desktop_view.dart';
import 'package:mysterium_vpn/views/welcome/welcome_mobile_view.dart';

class WelcomePage extends HookConsumerWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authSessionStore = ref.watch(authSessionStorePOD);
    final authStore = ref.watch(authStorePOD);
    final analyticsStore = ref.watch(analyticsStorePOD);

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
            if (authSessionStore.status == AuthStatus.authenticating)
              const LoadingBarrier(
                color: Palette.darkBlue,
              ),
          ],
        ),
      ),
    );
  }
}
