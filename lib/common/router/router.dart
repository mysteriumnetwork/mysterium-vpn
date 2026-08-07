import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/enum.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/pages/home_page.dart';
import 'package:mysterium_vpn/pages/login_page.dart';
import 'package:mysterium_vpn/pages/news_center_page.dart';
import 'package:mysterium_vpn/pages/static/splash_page.dart';
import 'package:mysterium_vpn/pages/verify_email_page.dart';
import 'package:mysterium_vpn/pages/welcome_page.dart';

class BeamerLocations extends BeamLocation<BeamState> {
  BeamerLocations(RouteInformation super.routeInformation);

  @override
  List<Pattern> get pathPatterns => [
    Routes.welcome.path,
    Routes.main.path,
    Routes.newsCenter.path,
    Routes.splash.path,
    Routes.login.path,
    Routes.checkYourEmail.path,
  ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) {
    final path = state.uri.path;
    return [
      if (path.contains(Routes.welcome.path))
        BeamPage(
          key: ValueKey(Routes.welcome.toDashCase),
          name: Routes.welcome.path,
          title: Routes.welcome.name,
          child: const WelcomePage(),
        ),
      if (path.contains(Routes.main.path))
        BeamPage(
          key: ValueKey(Routes.main.toDashCase),
          name: Routes.main.path,
          title: Routes.main.name,
          child: const HomePage(key: K.homePage),
        ),
      if (path.contains(Routes.newsCenter.path))
        BeamPage(
          key: ValueKey(Routes.newsCenter.toDashCase),
          name: Routes.newsCenter.path,
          title: Routes.newsCenter.name,
          // Deep link `/main/news-center?id=<id>` auto-opens that item.
          child: NewsCenterPage(deepLinkItemId: int.tryParse(state.queryParameters['id'] ?? '')),
        ),
      if (path.contains(Routes.splash.path))
        BeamPage(
          key: ValueKey(Routes.splash.toDashCase),
          name: Routes.splash.path,
          title: Routes.splash.name,
          child: const SplashPage(),
        ),
      if (path.contains(Routes.login.path))
        BeamPage(
          key: ValueKey(Routes.login.toDashCase),
          name: Routes.login.path,
          title: Routes.login.name,
          child: const LoginPage(key: K.loginPage),
        ),
      if (path.contains(Routes.checkYourEmail.path))
        BeamPage(
          key: ValueKey(Routes.checkYourEmail.toDashCase),
          name: Routes.checkYourEmail.path,
          title: Routes.checkYourEmail.name,
          child: const VerifyEmailPage(),
        ),
    ];
  }
}
