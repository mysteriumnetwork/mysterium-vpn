import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/common/layout_builders/system_ui_overlay_region.dart';

void main() {
  late List<Map<Object?, Object?>> styles;

  setUp(() {
    styles = [];
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      (call) async {
        if (call.method == 'SystemChrome.setSystemUIOverlayStyle') {
          styles.add(call.arguments as Map<Object?, Object?>);
        }
        return null;
      },
    );
  });

  tearDown(() {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      SystemChannels.platform,
      null,
    );
  });

  Future<void> pumpRegion(
    WidgetTester tester,
    Brightness brightness, {
    TargetPlatform platform = TargetPlatform.android,
  }) => tester.pumpWidget(
    MaterialApp(
      theme: ThemeData(brightness: brightness, platform: platform),
      home: const SystemUiOverlayRegion(child: SizedBox.expand()),
    ),
  );

  const contrastingIcons = {
    Brightness.light: 'Brightness.dark',
    Brightness.dark: 'Brightness.light',
  };

  for (final MapEntry(key: background, value: icons) in contrastingIcons.entries) {
    testWidgets('a ${background.name} background asks for contrasting bar icons', (tester) async {
      await pumpRegion(tester, background);

      expect(styles.last['statusBarIconBrightness'], icons);
      expect(styles.last['systemNavigationBarIconBrightness'], icons);
    });
  }

  testWidgets('keeps the bars transparent instead of MaterialApp black', (tester) async {
    await pumpRegion(tester, Brightness.light);

    expect(styles.last['statusBarColor'], 0);
    expect(styles.last['systemNavigationBarColor'], 0);
    expect(styles.last['systemNavigationBarDividerColor'], 0);
  });

  testWidgets('follows the theme when it flips while mounted', (tester) async {
    await pumpRegion(tester, Brightness.light);
    await tester.pumpAndSettle();
    styles.clear();

    await pumpRegion(tester, Brightness.dark);
    await tester.pumpAndSettle();

    expect(styles.last['systemNavigationBarIconBrightness'], 'Brightness.light');
  });

  testWidgets('annotates nothing off Android', (tester) async {
    await pumpRegion(tester, Brightness.light, platform: TargetPlatform.iOS);

    expect(find.byType(AnnotatedRegion<SystemUiOverlayStyle>), findsNothing);
  });
}
