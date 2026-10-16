import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/ui/url_launcher.dart';
import 'package:mysterium_vpn/generated/l10n.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

import '../../support/fake_url_launcher.dart';
import '../../support/test_localizations.dart';

class _FakeAnalyticsStore with AnalyticsStore {
  @override
  List<NavigatorObserver> navigationObservers() => [];
  @override
  Future<void> setUserId(String id) async {}
  @override
  Future<void> setLogin([GrantType loginMethod = GrantType.email]) async {}
  @override
  Future<void> setConsents() async {}
}

void main() {
  group('AnalyticsEvent.webRedirect', () {
    test('serializes to web_redirect', () {
      expect(AnalyticsEvent.webRedirect.formattedName, 'web_redirect');
    });
  });

  group('RedirectSource', () {
    test('values serialize to snake_case source strings', () {
      expect(RedirectSource.manageSubscription.formattedName, 'manage_subscription');
      expect(RedirectSource.upgradeSubscription.formattedName, 'upgrade_subscription');
      expect(RedirectSource.googlePlaySubscriptions.formattedName, 'google_play_subscriptions');
      expect(RedirectSource.cancelSubscription.formattedName, 'cancel_subscription');
      expect(RedirectSource.newsCenter.formattedName, 'news_center');
      expect(RedirectSource.external.formattedName, 'external');
    });
  });

  group('sanitizeRedirectUrl', () {
    test('strips query parameters including access_token', () {
      final url = Uri.parse('https://example.com/billing?access_token=secret&x=1');
      expect(sanitizeRedirectUrl(url), 'https://example.com/billing');
    });

    test('keeps scheme, host and path', () {
      final url = Uri.parse('https://help.mysteriumvpn.com/');
      expect(sanitizeRedirectUrl(url), 'https://help.mysteriumvpn.com/');
    });

    test('preserves a non-default port', () {
      final url = Uri.parse('https://example.com:8443/path?access_token=secret');
      expect(sanitizeRedirectUrl(url), 'https://example.com:8443/path');
    });
  });

  group('openUrlLink logging', () {
    late _FakeAnalyticsStore analytics;

    setUp(() {
      analytics = _FakeAnalyticsStore();
      analyticsStoreRef = analytics;
    });
    tearDown(() {
      analytics.dispose();
      analyticsStoreRef = null;
    });

    test('logs web_redirect with redirect_success true on success', () async {
      installFakeUrlLauncher();
      final next = analytics.watchLogs().first;

      await openUrlLink(
        Uri.parse('https://example.com/p?access_token=secret'),
        source: RedirectSource.manageSubscription,
      );

      final log = await next;
      expect(log.message, AnalyticsEvent.webRedirect.formattedName);
      expect(log.params, {
        'source': 'manage_subscription',
        'target_url': 'https://example.com/p',
        'redirect_success': true,
      });
    });

    test('logs redirect_success false with sanitized error_reason on failure', () async {
      installFakeUrlLauncher(canLaunchResult: false);
      final next = analytics.watchLogs().first;

      await openUrlLink(
        Uri.parse('https://example.com/p?access_token=secret'),
        source: RedirectSource.external,
      );

      final log = await next;
      expect(log.params?['redirect_success'], false);
      expect(log.params?['error_reason'], isNotNull);
      // error_reason must never leak the access_token.
      expect(log.params?['error_reason'].toString(), isNot(contains('secret')));
      expect(log.params?['source'], 'external');
    });

    test('logs redirect_success false when launchUrl returns false', () async {
      installFakeUrlLauncher(launchResult: false);
      final next = analytics.watchLogs().first;

      await openUrlLink(Uri.parse('https://example.com/p'), source: RedirectSource.external);

      final log = await next;
      expect(log.params?['redirect_success'], false);
      expect(log.params?['error_reason'], isNotNull);
    });

    test('logs redirect_success false with error_reason when launchUrl throws', () async {
      installFakeUrlLauncher(launchThrows: true);
      final next = analytics.watchLogs().first;

      await openUrlLink(
        Uri.parse('https://example.com/p?access_token=secret'),
        source: RedirectSource.webCheckout,
      );

      final log = await next;
      expect(log.message, AnalyticsEvent.webRedirect.formattedName);
      expect(log.params?['redirect_success'], false);
      expect(log.params?['error_reason'], isNotNull);
      expect(log.params?['target_url'], 'https://example.com/p');
      expect(log.params?['source'], 'web_checkout');
    });
  });

  group('openAppUpdateSource on Windows', () {
    /// Mounts a host wired to the global [snackbarKey] that runs the Windows
    /// update path when tapped, mirroring an update button.
    Future<void> pumpHost(WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          scaffoldMessengerKey: snackbarKey,
          theme: DesignSystem.lightTheme,
          locale: testLocale,
          localizationsDelegates: testLocalizationsDelegates,
          supportedLocales: testSupportedLocales,
          home: Scaffold(
            body: TextButton(
              onPressed: () => openAppUpdateSource(isWindows: () => true),
              child: const Text('update'),
            ),
          ),
        ),
      );
      await tester.tap(find.text('update'));
      await tester.pumpAndSettle();
    }

    testWidgets('opens the GitHub MSIX asset and confirms it', (tester) async {
      final launcher = installFakeUrlLauncher();

      await pumpHost(tester);

      expect(launcher.launchedUrl, windowsGithubDownloadLink);
      expect(find.text(S.current.updateDownloadStarted), findsOneWidget);
    });

    testWidgets('offers the link to copy instead when the launch fails', (tester) async {
      installFakeUrlLauncher(launchThrows: true);

      await pumpHost(tester);

      expect(find.text(S.current.updateDownloadStarted), findsNothing);
      expect(find.text(S.current.copyLink), findsOneWidget);
    });
  });
}
