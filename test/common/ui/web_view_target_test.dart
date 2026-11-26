import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/common/ui/url_launcher.dart';
import 'package:mysterium_vpn/common/ui/webview.dart';

void main() {
  final original = Uri.parse('https://app.mysteriumvpn.com/account');
  final fallback = original.replace(host: 'unblocked-app.mysteriumvpn.com');

  tearDown(() {
    webUrlResolver = null;
    webUrlFailureReporter = null;
  });

  test('resolves through the discovery resolver before loading', () async {
    webUrlResolver = (_) async => fallback;
    final target = WebViewTarget(original);

    expect(await target.resolve(), fallback);
    expect(target.current, fallback);
  });

  test('reports the page it loaded against the original', () async {
    webUrlResolver = (_) async => fallback;
    (Uri, Uri)? reported;
    webUrlFailureReporter = (first, second) async => reported = (first, second);
    final target = WebViewTarget(original);
    await target.resolve();

    target.recover(fallback.replace(path: '/account/billing'));
    await target.retarget();

    expect(reported, (original, fallback));
  });

  test('an error on another site is not held against our domain', () async {
    var reports = 0;
    webUrlFailureReporter = (_, _) async => reports++;
    final target = WebViewTarget(original);
    await target.resolve();

    target
      ..recover(Uri.parse('https://checkout.stripe.com/pay'))
      ..recover(null);
    await target.retarget();

    expect(reports, 0);
  });

  test('a retry waits for the report before resolving again', () async {
    final order = <String>[];
    webUrlFailureReporter = (_, _) async {
      await Future<void>.delayed(const Duration(milliseconds: 10));
      order.add('reported');
    };
    final target = WebViewTarget(original)..recover(original);
    // Reporting alone resolves nothing: the user may close the page instead.
    expect(order, isEmpty);
    webUrlResolver = (_) async {
      order.add('resolved');
      return fallback;
    };

    await target.retarget();

    expect(order, ['reported', 'resolved']);
  });

  test('repeated failures join one report', () async {
    var reports = 0;
    webUrlFailureReporter = (_, _) async {
      reports++;
      await Future<void>.delayed(const Duration(milliseconds: 10));
    };
    final target = WebViewTarget(original);

    for (var error = 0; error < 3; error++) {
      target.recover(original);
    }
    await target.retarget();

    expect(reports, 1);
  });

  test('a retry reloads in place unless the domain changed', () async {
    final target = WebViewTarget(original);
    await target.resolve();

    expect(await target.retarget(), isNull);

    webUrlResolver = (_) async => fallback;

    expect(await target.retarget(), fallback);
  });

  test('shows callers the original host for pages on a fallback', () async {
    webUrlResolver = (_) async => fallback;
    final target = WebViewTarget(original);
    await target.resolve();

    expect(target.canonical(fallback.replace(path: '/login')), original.replace(path: '/login'));

    final elsewhere = Uri.parse('https://trustpilot.com/login');
    expect(target.canonical(elsewhere), elsewhere);
  });
}
