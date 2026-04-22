import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/common/layout_builders/screen_type_builder.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/components/colored_scaffold.dart';
import 'package:mysterium_vpn/components/loading_barrier.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/welcome/welcome_desktop_view.dart';
import 'package:mysterium_vpn/views/welcome/welcome_mobile_view.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

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

    void onSignIn() {
      analyticsStore.logEvent(AnalyticsEvent.signInButton);
      authStore.loginDesktop();
    }

    final designTheme = DesignSystemTheme.of(context);

    return Theme(
      data: designTheme,
      child: ColoredScaffold(
        extendBodyBehindAppBar: true,
        backgroundColor: designTheme.palette.bgSidePanel,
        body: Observer(
          builder: (context) => Stack(
            children: [
              ScreenTypeLayoutBuilder(
                mobile: (BuildContext context) => WelcomeMobileView(onSignInPressed: onSignIn),
                tablet: (BuildContext context) => WelcomeDesktopView(onSignIn: onSignIn),
                desktop: (BuildContext context) => WelcomeDesktopView(onSignIn: onSignIn),
              ),
              if (authStore.authenticateFeature?.status == FutureStatus.pending)
                Positioned.fill(child: LoadingBarrier(color: Theme.of(context).primaryColor)),
            ],
          ),
        ),
      ),
    );
  }
}
