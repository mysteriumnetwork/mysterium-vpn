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
import 'package:mysterium_vpn/pages/vpn_config_consent_page.dart';
import 'package:mysterium_vpn/pages/vpn_privacy_consent_page.dart';
import 'package:mysterium_vpn/pages/welcome_page.dart';

class BeamerLocations extends BeamLocation<BeamState> {
  BeamerLocations(RouteInformation super.routeInformation);

  @override
  List<Pattern> get pathPatterns => [Routes.main.path, Routes.welcome.path];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        if (state.uri.pathSegments.contains(Routes.welcome.toDashCase))
          BeamPage(
            key: ValueKey(Routes.welcome.toDashCase),
            title: Routes.welcome.name,
            child: const WelcomePage(),
          ),
        if (state.uri.pathSegments.contains(Routes.main.toDashCase))
          BeamPage(
            key: ValueKey(Routes.main.toDashCase),
            title: Routes.main.name,
            child: const HomePage(),
          ),
        if (state.uri.pathSegments.contains(Routes.splash.toDashCase))
          BeamPage(
            key: ValueKey(Routes.splash.toDashCase),
            title: Routes.splash.name,
            child: const SplashPage(),
          ),
        if (state.uri.pathSegments.contains(Routes.settings.toDashCase))
          BeamPage(
            key: ValueKey(Routes.settings.toDashCase),
            title: Routes.settings.name,
            child: const SettingsPage(),
          ),
        if (state.uri.pathSegments.contains(Routes.payment.toDashCase))
          BeamPage(
            key: ValueKey(Routes.payment.toDashCase),
            title: Routes.payment.name,
            child: const SubscriptionPage(),
          ),
        if (state.uri.pathSegments.contains(Routes.permissions.toDashCase))
          BeamPage(
            key: ValueKey(Routes.permissions.toDashCase),
            title: Routes.permissions.name,
            child: const VpnConfigConsentPage(),
          ),
        if (state.uri.pathSegments.contains(Routes.privacyPolicy.toDashCase))
          BeamPage(
            key: ValueKey(Routes.privacyPolicy.toDashCase),
            title: Routes.privacyPolicy.name,
            child: const VpnPrivacyConsentPage(),
          ),
        if (state.uri.pathSegments.contains(Routes.login.toDashCase))
          BeamPage(
            key: ValueKey(Routes.login.toDashCase),
            title: Routes.login.name,
            child: const LoginPage(),
          ),
        if (state.uri.pathSegments.contains(Routes.checkYourEmail.toDashCase))
          BeamPage(
            key: ValueKey(Routes.checkYourEmail.toDashCase),
            title: Routes.checkYourEmail.name,
            child: const VerifyEmailPage(),
          ),
      ];
}
