import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/entrypoints/environment.dart';
import 'package:patrol/patrol.dart';

void main() {
  final environment = Environment('DEV', quickAuth: true);

  patrolTest('User logs in with valid credentials', ($) async {
    WidgetsFlutterBinding.ensureInitialized();
    await environment.init();
    await $.pumpWidgetAndSettle(environment.getApp());

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
    await $(#loginEmailField).enterText('davidm@mysterium.network');

    // Tap the login button
    await $(#loginButton).tap();

    // Make sure that "Sign in to mysterium VPN" is not visible anymore
    expect($('Sign in to Mysterium VPN'), findsNothing);
    expect($("You're not signed in"), findsNothing);
  });
}
