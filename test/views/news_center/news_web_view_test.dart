import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/views/news_center/news_web_view.dart';
import 'package:plugin_platform_interface/plugin_platform_interface.dart';
import 'package:url_launcher_platform_interface/link.dart';
import 'package:url_launcher_platform_interface/url_launcher_platform_interface.dart';

class _FakeUrlLauncher extends UrlLauncherPlatform with MockPlatformInterfaceMixin {
  String? launchedUrl;

  @override
  LinkDelegate? get linkDelegate => null;
  @override
  Future<bool> canLaunch(String url) async => true;
  @override
  Future<bool> launchUrl(String url, LaunchOptions options) async {
    launchedUrl = url;
    return true;
  }
}

void main() {
  final uri = Uri.parse('https://news.mysteriumvpn.com/article/1');
  late _FakeUrlLauncher launcher;

  setUp(() {
    launcher = _FakeUrlLauncher();
    UrlLauncherPlatform.instance = launcher;
    final original = inAppWebViewSupported;
    addTearDown(() => inAppWebViewSupported = original);
  });

  testWidgets('opens the default browser when the platform has no webview', (tester) async {
    inAppWebViewSupported = () => false;

    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) =>
              TextButton(onPressed: () => showNewsWebView(context, uri), child: const Text('open')),
        ),
      ),
    );

    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();

    expect(launcher.launchedUrl, uri.toString());
    // No modal was pushed — the route stack is untouched.
    expect(find.byType(Dialog), findsNothing);
  });
}
