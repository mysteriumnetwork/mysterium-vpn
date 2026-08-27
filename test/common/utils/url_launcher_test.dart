import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/utils/url_launcher.dart';
import 'package:mysterium_vpn/stores/analytics/analytics_store.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

import '../../support/fake_url_launcher.dart';

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
    late UrlLauncherPlatform originalLauncher;

    setUpAll(TestWidgetsFlutterBinding.ensureInitialized);

    setUp(() {
      originalLauncher = UrlLauncherPlatform.instance;
      analytics = _FakeAnalyticsStore();
      analyticsStoreRef = analytics;
    });
    tearDown(() {
      analytics.dispose();
      analyticsStoreRef = null;
      UrlLauncherPlatform.instance = originalLauncher;
    });

    test('logs web_redirect with redirect_success true on success', () async {
      UrlLauncherPlatform.instance = FakeUrlLauncher();
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
      UrlLauncherPlatform.instance = FakeUrlLauncher(canLaunchResult: false);
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
      UrlLauncherPlatform.instance = FakeUrlLauncher(launchResult: false);
      final next = analytics.watchLogs().first;

      await openUrlLink(Uri.parse('https://example.com/p'), source: RedirectSource.external);

      final log = await next;
      expect(log.params?['redirect_success'], false);
      expect(log.params?['error_reason'], isNotNull);
    });

    test('logs redirect_success false with error_reason when launchUrl throws', () async {
      UrlLauncherPlatform.instance = FakeUrlLauncher(launchThrows: true);
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
}
