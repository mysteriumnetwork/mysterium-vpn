import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/hooks/hooks.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/providers/state_providers.dart';
import 'package:mysterium_vpn/views/welcome/welcome_view.dart';
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

    final theme = Theme.of(context);

    return ColoredScaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: theme.palette.bgSidePanel,
      body: Observer(
        builder: (context) => Stack(
          children: [
            WelcomeView(onSignIn: onSignIn),
            if (authStore.authenticateFeature?.status == FutureStatus.pending)
              Positioned.fill(child: LoadingBarrier(color: Theme.of(context).palette.bgPopover)),
          ],
        ),
      ),
    );
  }
}
