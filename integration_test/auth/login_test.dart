import 'package:easy_localization/easy_localization.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/entrypoints/environment.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';
import 'package:patrol/patrol.dart';

void main() {
  final environment = Environment('DEV');
  patrolTest('User logs in with valid credentials', ($) async {
    await environment.init();

    await $.pumpWidgetAndSettle(environment.getApp());

    expect($(#loginEmailField), findsOneWidget);
    await $(#loginEmailField).enterText('davidm@mysterium.network');
    await $(#loginButton).tap();

    await $(LocaleKeys.checkYourEmail.tr()).waitUntilVisible(
      timeout: const Duration(seconds: 10),
    );
    expect($(LocaleKeys.checkYourEmail.tr()), findsOneWidget);
  });
}
