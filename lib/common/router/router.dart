import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/enum.dart';
import 'package:mysterium_vpn/pages/home_page.dart';
import 'package:mysterium_vpn/pages/login_page.dart';
import 'package:mysterium_vpn/pages/settings_page.dart';
import 'package:mysterium_vpn/pages/static/splash_page.dart';
import 'package:mysterium_vpn/views/check_email_view.dart';
import 'package:mysterium_vpn/views/sign_up/sign_up_view.dart';

class BeamerLocations extends BeamLocation<BeamState> {
  BeamerLocations(RouteInformation routeInformation) : super(routeInformation);

  @override
  List<Pattern> get pathPatterns => [Routes.home.toRoute, Routes.login.toRoute];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      if (state.uri.pathSegments.contains(Routes.login.toDashCase))
        BeamPage(
          key: ValueKey(Routes.login.toDashCase),
          title: Routes.login.value,
          child: const LoginPage(),
        ),
      if (state.uri.pathSegments.contains(Routes.home.toDashCase))
        BeamPage(
          key: ValueKey(Routes.home.toDashCase),
          title: Routes.home.value,
          child: const HomePage(),
        ),
      if (state.uri.pathSegments.contains(Routes.splash.toDashCase))
        BeamPage(
          key: ValueKey(Routes.splash.toDashCase),
          title: Routes.splash.value,
          child: const SplashPage(),
        ),
      if (state.uri.pathSegments.contains(Routes.settings.toDashCase))
        BeamPage(
          key: ValueKey(Routes.settings.toDashCase),
          title: Routes.settings.value,
          child: const SettingsPage(),
        ),
    ];
  }
}

class SignUpBeamerLocations extends BeamLocation<BeamState> {
  SignUpBeamerLocations(RouteInformation routeInformation) : super(routeInformation);

  @override
  List<Pattern> get pathPatterns => [Routes.signUp.toRoute, Routes.checkYourEmail.toRoute];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    return [
      if (state.uri.pathSegments.contains(Routes.signUp.toDashCase))
        BeamPage(
          key: ValueKey(Routes.signUp.toDashCase),
          title: Routes.signUp.value,
          child: const SignUpView(),
        ),
      if (state.uri.pathSegments.contains(Routes.checkYourEmail.toDashCase))
        BeamPage(
          key: ValueKey(Routes.checkYourEmail.toDashCase),
          title: Routes.checkYourEmail.value,
          child: const CheckYourEmailView(),
        ),
    ];
  }
}
