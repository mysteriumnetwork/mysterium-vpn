import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/components/components.dart';
import 'package:mysterium_vpn/core/enums/enums.dart';
import 'package:mysterium_vpn/core/layout_builders/screen_type_builder.dart';
import 'package:mysterium_vpn/features/analytics/store/analytics_store.dart';
import 'package:mysterium_vpn/features/auth/store/auth_session_store.dart';
import 'package:mysterium_vpn/features/auth/store/auth_store.dart';
import 'package:mysterium_vpn/features/auth/views/welcome_desktop_view.dart';
import 'package:mysterium_vpn/features/auth/views/welcome_mobile_view.dart';
import 'package:mysterium_vpn/service_locator.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  final _authStore = getIt<AuthStore>();
  final _authSessionStore = getIt<AuthSessionStore>();
  final _analyticsStore = getIt<AnalyticsStore>();
  late final ReactionDisposer _disposer;

  @override
  void initState() {
    super.initState();
    _disposer = reaction((_) => _authSessionStore.authShown, (authShown) {
      if (authShown) {
        return;
      }
      Future.microtask(() async {
        _authSessionStore.authShown = true;
      });
    }, fireImmediately: true);
  }

  @override
  void dispose() {
    _disposer();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final palette = theme.palette;
    return ColoredScaffold(
      extendBodyBehindAppBar: true,
      backgroundColor: palette.bgSidePanel,
      body: Observer(
        builder: (context) => Stack(
          children: [
            ScreenTypeLayoutBuilder(
              mobile: (BuildContext context) => WelcomeMobileView(
                onSignInPressed: () {
                  _analyticsStore.logEvent(AnalyticsEvent.signInButton);
                  _authStore.loginDesktop();
                },
              ),
              tablet: (BuildContext context) => WelcomeDesktopView(
                onSignIn: () {
                  _analyticsStore.logEvent(AnalyticsEvent.signInButton);
                  _authStore.loginDesktop();
                },
              ),
              desktop: (BuildContext context) => WelcomeDesktopView(
                onSignIn: () {
                  _analyticsStore.logEvent(AnalyticsEvent.signInButton);
                  _authStore.loginDesktop();
                },
              ),
            ),
            if (_authStore.authenticateFeature?.status == FutureStatus.pending)
              LoadingBarrier(color: palette.bgPopover)
          ],
        ),
      ),
    );
  }
}
