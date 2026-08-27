import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/views/news_center/news_web_view.dart';
import 'package:vpn_api/vpn_api.dart';

import '../../support/fake_url_launcher.dart';
import '../../support/news_fixtures.dart';

void main() {
  late FakeUrlLauncher launcher;

  setUp(() {
    launcher = installFakeUrlLauncher();
  });

  Future<void> pumpOpener(
    WidgetTester tester,
    NewscenterInboxListResponseItem item, {
    String? userId,
  }) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => showNewsItemWebView(context, item, userId: userId),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
  }

  // No webview implementation is registered under `flutter test`, so these
  // exercise the same fallback path as Windows and Linux.
  group('showNewsItemWebView', () {
    testWidgets('opens the item in the browser with user_id appended', (tester) async {
      await pumpOpener(tester, newsItem(1), userId: 'u-1');

      expect(launcher.launchedUrl, 'https://mysterium.network/news/1?user_id=u-1');
    });

    testWidgets('no-ops on a non-web url', (tester) async {
      await pumpOpener(tester, newsItem(1, webViewUrl: 'intent://foo'));

      expect(launcher.launchedUrl, isNull);
      expect(find.byType(Dialog), findsNothing);
    });
  });

  group('newsWebViewUri', () {
    test('accepts http(s) urls', () {
      expect(newsWebViewUri('https://example.com/a'), Uri.parse('https://example.com/a'));
      expect(newsWebViewUri('http://example.com'), Uri.parse('http://example.com'));
    });

    test('rejects non-web and unparseable schemes', () {
      expect(newsWebViewUri('file:///etc/passwd'), isNull);
      expect(newsWebViewUri('javascript:alert(1)'), isNull);
      expect(newsWebViewUri('intent://foo'), isNull);
      expect(newsWebViewUri(''), isNull);
    });

    test('appends user_id when provided', () {
      expect(
        newsWebViewUri('https://example.com/a', userId: 'u-1'),
        Uri.parse('https://example.com/a?user_id=u-1'),
      );
    });

    test('preserves existing query parameters when appending user_id', () {
      expect(
        newsWebViewUri('https://example.com/a?foo=bar', userId: 'u-1'),
        Uri.parse('https://example.com/a?foo=bar&user_id=u-1'),
      );
    });

    test('omits empty user_id', () {
      expect(
        newsWebViewUri('https://example.com/a', userId: ''),
        Uri.parse('https://example.com/a'),
      );
    });
  });
}
