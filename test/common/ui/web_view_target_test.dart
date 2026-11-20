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

  test('reports the URL that actually failed against the original', () async {
    webUrlResolver = (_) async => fallback;
    (Uri, Uri)? reported;
    webUrlFailureReporter = (first, second) async => reported = (first, second);
    final target = WebViewTarget(original);
    await target.resolve();

    target.recover();
    await target.resolve();

    // Keyed by the original: recording it under the fallback's own origin would
    // write a record nothing ever reads back.
    expect(reported, (original, fallback));
  });

  test('a retry waits for the report before resolving again', () async {
    final order = <String>[];
    webUrlFailureReporter = (_, _) async {
      await Future<void>.delayed(const Duration(milliseconds: 10));
      order.add('reported');
    };
    webUrlResolver = (_) async {
      order.add('resolved');
      return fallback;
    };
    final target = WebViewTarget(original)..recover();

    // Reporting alone resolves nothing: the user may close the page instead.
    expect(order, isEmpty);

    await target.resolve();

    // Resolving first would re-read state the report had not written yet, and
    // the retry would reload the same dead host.
    expect(order, ['reported', 'resolved']);
  });

  test('falls back to the original when nothing has been resolved yet', () async {
    (Uri, Uri)? reported;
    webUrlFailureReporter = (first, second) async => reported = (first, second);

    WebViewTarget(original).recover();
    await pumpEventQueue();

    expect(reported, (original, original));
  });

  test('repeated failures join one report instead of starting a chain each', () async {
    var reports = 0;
    webUrlFailureReporter = (_, _) async {
      reports++;
      await Future<void>.delayed(const Duration(milliseconds: 10));
    };
    webUrlResolver = (_) async => fallback;
    final target = WebViewTarget(original);

    for (var error = 0; error < 3; error++) {
      target.recover();
    }
    await target.resolve();

    // Each error otherwise starts its own config fetch and probe set.
    expect(reports, 1);
  });

  test('resolving without a failure does not wait on anything', () async {
    webUrlResolver = (_) async => fallback;

    expect(await WebViewTarget(original).resolve(), fallback);
  });
}
