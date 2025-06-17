import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/entrypoints/environment.dart';
import 'package:patrol/patrol.dart';

void main() {
  final environment = Environment('DEV');
  patrolSetUp(() async {
    WidgetsFlutterBinding.ensureInitialized();
    await environment.init();
  });

  patrolTest('Happy path: log in, subscribe, connect, disconnect, log out', ($) async {
    await $.pumpWidgetAndSettle(environment.getApp());
    //  await _login($, const String.fromEnvironment('LOGIN_EMAIL'));
    await _subscribe($);
  });
}

Future<void> _login(PatrolIntegrationTester $, String email) async {
  // Wait for "Sign in to Mysterium VPN" title
  await $('Sign in to Mysterium VPN').waitUntilVisible();

  // Close the login page
  await $(#backButton).tap();

  // Look for "You're not signed in" banner
  await $("You're not signed in").waitUntilVisible();

  // click the banner
  await $("You're not signed in").tap();

  // Wait for "Sign in to Mysterium VPN" title
  await $('Sign in to Mysterium VPN').waitUntilVisible();

  // Input email
  await $(#loginEmailField).enterText(email);

  // Tap the login button
  await $(#loginButton).tap();

  // Make sure that "Sign in to mysterium VPN" is not visible anymore
  expect($('Sign in to Mysterium VPN'), findsNothing);
  expect($("You're not signed in"), findsNothing);
}

Future<void> _subscribe(PatrolIntegrationTester $) async {
  await $("You don't have an active subscription").waitUntilVisible();
  await $("You don't have an active subscription").tap();
}
