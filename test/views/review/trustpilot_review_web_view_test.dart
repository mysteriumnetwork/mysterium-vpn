import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/views/review/trustpilot_review_web_view.dart';

void main() {
  group('reviewWebViewUri', () {
    test('defaults: https web-app url, light theme, nothing optional', () {
      final uri = reviewWebViewUri();
      expect(uri.scheme, 'https');
      expect(uri.host, Env.webAppUrl);
      expect(uri.path, '/app-review');
      expect(uri.queryParameters['theme'], 'light');
      expect(uri.queryParameters.containsKey('bg'), isFalse);
      expect(uri.queryParameters.containsKey('access_token'), isFalse);
    });

    test('forwards the access token so the page can identify the user', () {
      expect(reviewWebViewUri(accessToken: 'jwt').queryParameters['access_token'], 'jwt');
    });

    test('omits the token when empty rather than sending a blank one', () {
      expect(
        reviewWebViewUri(accessToken: '').queryParameters.containsKey('access_token'),
        isFalse,
      );
    });

    test('states dark theme when the app is dark', () {
      expect(reviewWebViewUri(isDarkMode: true).queryParameters['theme'], 'dark');
    });

    test('sends the surface colour as #rrggbb, the only form the page accepts', () {
      expect(
        reviewWebViewUri(background: const Color(0xFF101014)).queryParameters['bg'],
        '#101014',
      );
    });

    test('drops the alpha channel rather than emitting eight digits', () {
      // A translucent palette colour must still produce a parseable value.
      expect(
        reviewWebViewUri(background: const Color(0x80AABBCC)).queryParameters['bg'],
        '#aabbcc',
      );
    });
  });
}
