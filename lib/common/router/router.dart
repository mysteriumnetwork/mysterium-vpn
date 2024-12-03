import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/enum.dart';
import 'package:mysterium_vpn/pages/home_page.dart';
import 'package:mysterium_vpn/pages/login_page.dart';
import 'package:mysterium_vpn/pages/settings_page.dart';
import 'package:mysterium_vpn/pages/static/splash_page.dart';
import 'package:mysterium_vpn/pages/subscription_page.dart';
import 'package:mysterium_vpn/pages/verify_email_page.dart';
import 'package:mysterium_vpn/pages/vpn_privacy_consent_page.dart';
import 'package:mysterium_vpn/pages/welcome_page.dart';

class BeamerLocations extends BeamLocation<BeamState> {
  BeamerLocations(RouteInformation super.routeInformation);

  @override
  List<Pattern> get pathPatterns => [Routes.main.path, Routes.welcome.path];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        if (state.uri.path == Routes.welcome.path)
          BeamPage(
            key: ValueKey(Routes.welcome.toDashCase),
            title: Routes.welcome.name,
            child: const WelcomePage(),
          ),
        if (state.uri.path == Routes.main.path)
          BeamPage(
            key: ValueKey(Routes.main.toDashCase),
            title: Routes.main.name,
            child: const HomePage(),
          ),
        if (state.uri.path == Routes.splash.path)
          BeamPage(
            key: ValueKey(Routes.splash.toDashCase),
            title: Routes.splash.name,
            child: const SplashPage(),
          ),
        if (state.uri.path == Routes.settings.path)
          BeamPage(
            key: ValueKey(Routes.settings.toDashCase),
            title: Routes.settings.name,
            child: const SettingsPage(),
          ),
        if (state.uri.path == Routes.payment.path)
          BeamPage(
            key: ValueKey(Routes.payment.toDashCase),
            title: Routes.payment.name,
            child: const SubscriptionPage(),
          ),
        if (state.uri.path == Routes.privacyPolicy.path)
          BeamPage(
            key: ValueKey(Routes.privacyPolicy.toDashCase),
            title: Routes.privacyPolicy.name,
            child: const VpnPrivacyConsentPage(),
          ),
        if (state.uri.path == Routes.login.path)
          BeamPage(
            key: ValueKey(Routes.login.toDashCase),
            title: Routes.login.name,
            child: const LoginPage(),
          ),
        if (state.uri.path == Routes.checkYourEmail.path)
          BeamPage(
            key: ValueKey(Routes.checkYourEmail.toDashCase),
            title: Routes.checkYourEmail.name,
            child: const VerifyEmailPage(),
          ),
      ];
}
