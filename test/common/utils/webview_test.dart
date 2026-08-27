import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/utils/webview.dart';

import '../../support/fake_url_launcher.dart';

void main() {
  final uri = Uri.parse('https://news.mysteriumvpn.com/article/1');
  late FakeUrlLauncher launcher;

  setUp(() {
    launcher = installFakeUrlLauncher();
  });

  Future<bool> pumpOpener(WidgetTester tester, {required bool supported}) async {
    var builderCalled = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Builder(
          builder: (context) => TextButton(
            onPressed: () => openInAppWebView(
              context,
              uri: uri,
              source: RedirectSource.newsCenter,
              isSupported: () => supported,
              builder: (_) {
                builderCalled = true;
                return const SizedBox();
              },
            ),
            child: const Text('open'),
          ),
        ),
      ),
    );
    await tester.tap(find.text('open'));
    await tester.pumpAndSettle();
    return builderCalled;
  }

  testWidgets('shows the modal when a webview is available', (tester) async {
    final builderCalled = await pumpOpener(tester, supported: true);

    expect(builderCalled, isTrue);
    expect(launcher.launchedUrl, isNull);
  });

  testWidgets('falls back to the browser when there is no webview', (tester) async {
    final builderCalled = await pumpOpener(tester, supported: false);

    expect(launcher.launchedUrl, uri.toString());
    expect(builderCalled, isFalse);
    expect(find.byType(Dialog), findsNothing);
  });
}
