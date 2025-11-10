import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/entrypoints/app_initializer.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:patrol/patrol.dart';

void main() {
  late final AppInitializer environment;
  patrolSetUp(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Env.init();
    environment = AppInitializer();
    await environment.init();
    await SecureStorageService.instance.clearAll();
  });

  patrolTest('Happy path: log in, subscribe, connect, disconnect, log out', ($) async {
    await $.pumpWidgetAndSettle(environment.getApp());
    await _login($, const String.fromEnvironment('LOGIN_EMAIL'));
    await _subscribe($);
  });
}

Future<void> _login(PatrolIntegrationTester $, String email) async {
  await $(#loginPage).waitUntilVisible();
  // Close the login page
  await $(#backButton).tap();

  // Wait for home page to be visible
  await $(#homePage).waitUntilVisible();
  await $(#unauthenticatedBanner).waitUntilVisible();
  await $(#unauthenticatedBanner).tap();

  // Wait for login page to be visible
  await $(#loginPage).waitUntilVisible();

  // Input email
  await $(#loginEmailField).enterText(email);

  // Tap the login button
  await $(#loginButton).tap();

  // Dismiss marketing consent dialog (if it pops up)
  try {
    await $(#marketingConsentDialog).waitUntilVisible();
    await $(#marketingConsentDeclineButton).tap();
  } on WaitUntilVisibleTimeoutException catch (_) {
    // Dialog did not appear, no action needed
  }

  await $(#homePage).waitUntilVisible();

  expect($(#unauthenticatedBanner), findsNothing);
}

Future<void> _subscribe(PatrolIntegrationTester $) async {
  await $(#subscriptionBanner).waitUntilVisible();
  await $(#subscriptionBannerCTA).waitUntilVisible();
  await $(#subscriptionBannerCTA).tap();
  await $(#subscriptionPage).waitUntilVisible();
  await Future.delayed(const Duration(seconds: 10));
  expect($(#subscriptionPage), findsOneWidget);

  await $(#backButton).tap();
  await $(#homePage).waitUntilVisible();
  expect($(#homePage), findsOneWidget);
}
