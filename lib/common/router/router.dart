import 'package:beamer/beamer.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/enum.dart';
import 'package:mysterium_vpn/pages/email_communication_page.dart';
import 'package:mysterium_vpn/pages/home_page.dart';
import 'package:mysterium_vpn/pages/login_page.dart';
import 'package:mysterium_vpn/pages/notifications_page.dart';
import 'package:mysterium_vpn/pages/report_issue_page.dart';
import 'package:mysterium_vpn/pages/settings_page.dart';
import 'package:mysterium_vpn/pages/static/splash_page.dart';
import 'package:mysterium_vpn/pages/subscription_page.dart';
import 'package:mysterium_vpn/views/check_email_view.dart';
import 'package:mysterium_vpn/views/sign_in/sign_in_view.dart';
import 'package:mysterium_vpn/views/sign_up/sign_up_view.dart';

class BeamerLocations extends BeamLocation<BeamState> {
  BeamerLocations(RouteInformation super.routeInformation);

  @override
  List<Pattern> get pathPatterns => [Routes.home.toRoute, Routes.login.toRoute];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
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
        if (state.uri.pathSegments.contains(Routes.reportIssue.toDashCase))
          BeamPage(
            key: ValueKey(Routes.reportIssue.toDashCase),
            title: Routes.reportIssue.value,
            child: const ReportIssuePage(),
          ),
        if (state.uri.pathSegments.contains(Routes.subscription.toDashCase))
          BeamPage(
            key: ValueKey(Routes.subscription.toDashCase),
            title: Routes.subscription.value,
            child: const SubscriptionPage(),
          ),
        if (state.uri.pathSegments.contains(Routes.emailCommunications.toDashCase))
          BeamPage(
            key: ValueKey(Routes.emailCommunications.toDashCase),
            title: Routes.emailCommunications.value,
            child: const EmailCommunicationPage(),
          ),
        if (state.uri.pathSegments.contains(Routes.notifications.toDashCase))
          BeamPage(
            key: ValueKey(Routes.notifications.toDashCase),
            title: Routes.notifications.value,
            child: const NotificationsPage(),
          ),
      ];
}

class AuthBeamerLocations extends BeamLocation<BeamState> {
  AuthBeamerLocations(RouteInformation super.routeInformation);

  @override
  List<Pattern> get pathPatterns => [
        Routes.signUp.toRoute,
        Routes.checkYourEmail.toRoute,
        Routes.signIn.toRoute,
      ];

  @override
  List<BeamPage> buildPages(BuildContext context, BeamState state) => [
        if (state.uri.pathSegments.contains(Routes.signIn.toDashCase))
          BeamPage(
            key: ValueKey(Routes.signIn.toDashCase),
            title: Routes.signIn.value,
            child: const SignInView(),
          ),
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
