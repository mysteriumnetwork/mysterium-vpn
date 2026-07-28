import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/entrypoints/app_initializer.dart';
import 'package:mysterium_vpn/views/news_center/news_center_strings.dart';
import 'package:patrol/patrol.dart';

import 'support/app_harness.dart';
import 'support/flows.dart';

void main() {
  late final AppInitializer environment;
  patrolSetUp(() async {
    environment = await bootApp();
  });

  patrolTest('News Center: header bell opens the feed and back returns home', ($) async {
    await pumpApp($, environment);
    await loginWithEnv($);

    // Land on home (map is the landing tab).
    await $(#connectionStatusBar).waitUntilVisible();

    await openNewsCenter($);
    expect($(#newsCenterPage), findsOneWidget);

    // Return home via the header back control (labelled "Back").
    await $(newsCenterBackText).tap();
    await $(#connectionStatusBar).waitUntilVisible();
  });

  patrolTest('News Center: the feed resolves to a real state, not a stuck spinner', ($) async {
    await pumpApp($, environment);
    await loginWithEnv($);
    await $(#connectionStatusBar).waitUntilVisible();

    await openNewsCenter($);

    // Whatever the backend returns, the page settles into a filter row (data or
    // empty) or the retry state — it never hangs on the initial spinner. Give
    // the retry-backed fetch generous time on slow test backends.
    final settled =
        await isVisibleWithin($, #newsCenterPage, timeout: const Duration(seconds: 20)) &&
        (await _anyVisible($, [newsFilterAllText, newsCenterEmptyTitleText, newsCenterRetryText]));
    expect(
      settled,
      isTrue,
      reason: 'News Center did not resolve to a content, empty or error state',
    );
  });
}

/// True if any of the given text labels becomes visible within a short window.
Future<bool> _anyVisible(PatrolIntegrationTester $, List<String> texts) async {
  for (final text in texts) {
    try {
      await $(text).waitUntilVisible(timeout: const Duration(seconds: 2));
      return true;
    } on WaitUntilVisibleTimeoutException catch (_) {
      // Try the next candidate.
    }
  }
  return false;
}
