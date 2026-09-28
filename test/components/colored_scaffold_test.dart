import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/components/colored_scaffold.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

const _bodyKey = Key('body');
const _screenHeight = 800.0;
const _topInset = 100.0;
const _bottomInset = 60.0;

Future<void> _pump(
  WidgetTester tester, {
  double width = 400,
  bool extendBodyBehindAppBar = false,
  Color? backgroundColor,
}) async {
  tester.view
    ..devicePixelRatio = 1.0
    ..physicalSize = Size(width, _screenHeight)
    ..padding = const FakeViewPadding(top: _topInset, bottom: _bottomInset);
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      theme: DesignSystem.lightTheme,
      home: ColoredScaffold(
        extendBodyBehindAppBar: extendBodyBehindAppBar,
        backgroundColor: backgroundColor,
        body: const SizedBox.expand(key: _bodyKey),
      ),
    ),
  );
}

Color? _background(WidgetTester tester) =>
    tester.widget<Scaffold>(find.byType(Scaffold)).backgroundColor;

void main() {
  final palette = DesignSystem.lightTheme.palette;

  group('ColoredScaffold insets', () {
    testWidgets('pushes the body below the status bar', (tester) async {
      await _pump(tester);

      expect(tester.getTopLeft(find.byKey(_bodyKey)).dy, _topInset);
    });

    testWidgets('lets the body run under the status bar behind an app bar', (tester) async {
      await _pump(tester, extendBodyBehindAppBar: true);

      expect(tester.getTopLeft(find.byKey(_bodyKey)).dy, 0);
    });

    testWidgets('leaves the bottom inset to the nav bar and footers', (tester) async {
      await _pump(tester);

      expect(tester.getBottomLeft(find.byKey(_bodyKey)).dy, _screenHeight);
    });
  });

  group('ColoredScaffold background', () {
    testWidgets('uses the side panel colour below the tablet breakpoint', (tester) async {
      await _pump(tester);

      expect(_background(tester), palette.bgSidePanel);
    });

    testWidgets('ignores an explicit background below the breakpoint', (tester) async {
      await _pump(tester, backgroundColor: Colors.red);

      expect(_background(tester), palette.bgSidePanel);
    });

    testWidgets('honours an explicit background from the breakpoint up', (tester) async {
      await _pump(tester, width: 800, backgroundColor: Colors.red);

      expect(_background(tester), Colors.red);
    });

    testWidgets('falls back to the primary background from the breakpoint up', (tester) async {
      await _pump(tester, width: 800);

      expect(_background(tester), palette.bgPrimary);
    });
  });
}
