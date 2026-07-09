import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/generated/l10n.dart';

/// Auto-discovered by `flutter test`; wraps every test in this tree.
/// Loads intl_utils' `S` so widgets that read `S.current` work in tests
/// (mirrors the app preloading it at startup during the Localizely migration).
Future<void> testExecutable(FutureOr<void> Function() testMain) async {
  TestWidgetsFlutterBinding.ensureInitialized();
  await S.load(const Locale('en'));
  await testMain();
}
