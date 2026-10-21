import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/components/easy_dropdown.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

const _items = ['Fast (WireGuard)', 'Compatible (OpenVPN)'];

Future<void> _pump(
  WidgetTester tester, {
  bool enabled = true,
  List<String> items = _items,
  VoidCallback? onTap,
}) => tester.pumpWidget(
  MaterialApp(
    theme: DesignSystem.lightTheme,
    home: Scaffold(
      body: Center(
        child: EasyDropdown<String>(
          value: _items.first,
          onChanged: enabled ? (_) {} : null,
          onTap: onTap,
          items: items
              .map((item) => DropdownMenuItem<String>(value: item, child: Text(item)))
              .toList(),
        ),
      ),
    ),
  ),
);

/// Background of the box EasyDropdown paints its hover fill into.
Color? _bgColor(WidgetTester tester) =>
    (tester
                .widget<DecoratedBox>(
                  find.descendant(
                    of: find.byType(EasyDropdown<String>),
                    matching: find.byType(DecoratedBox),
                  ),
                )
                .decoration
            as BoxDecoration)
        .color;

/// Parks a mouse pointer over [finder] and settles the frame.
///
/// Returns the gesture so callers can move the pointer again.
Future<TestGesture> _hover(WidgetTester tester, Finder finder) async {
  final gesture = await tester.createGesture(kind: PointerDeviceKind.mouse);
  await gesture.addPointer(location: Offset.zero);
  addTearDown(gesture.removePointer);
  await gesture.moveTo(tester.getCenter(finder));
  await tester.pump();
  return gesture;
}

void main() {
  group('EasyDropdown', () {
    final palette = DesignSystem.lightTheme.palette;

    testWidgets('tints to bgPrimaryHover on hover', (tester) async {
      await _pump(tester);

      expect(_bgColor(tester), palette.bgPrimary);

      await _hover(tester, find.byType(EasyDropdown<String>));

      expect(_bgColor(tester), palette.bgPrimaryHover);
    });

    testWidgets('disabled dropdown does not tint on hover', (tester) async {
      await _pump(tester, enabled: false);

      await _hover(tester, find.byType(EasyDropdown<String>));

      expect(_bgColor(tester), palette.bgPrimary);
    });

    testWidgets('the whole painted surface is interactive', (tester) async {
      var taps = 0;
      await _pump(tester, onTap: () => taps++);

      // Everything the border encloses responds; no inert gutter.
      final box = tester.getRect(find.byType(EasyDropdown<String>));
      expect(tester.getRect(find.byType(DropdownButton<String>)), box);

      final gesture = await _hover(tester, find.byType(EasyDropdown<String>));
      await gesture.moveTo(Offset(box.left + 2, box.center.dy));
      await tester.pump();
      expect(_bgColor(tester), palette.bgPrimaryHover);

      await tester.tapAt(Offset(box.left + 2, box.center.dy));
      await tester.pumpAndSettle();
      expect(taps, 1);
    });

    testWidgets('empty items reads as disabled and still shows the value', (tester) async {
      await _pump(tester, items: const []);

      // DropdownButton treats empty items as disabled; the wrapper must agree.
      expect(find.text(_items.first), findsOneWidget);
      expect(_bgColor(tester), palette.bgPrimary);

      await _hover(tester, find.byType(EasyDropdown<String>));

      expect(_bgColor(tester), palette.bgPrimary, reason: 'an unopenable control must not tint');
    });

    testWidgets('disabled dropdown renders the current value as its hint', (tester) async {
      await _pump(tester, enabled: false);

      expect(find.text(_items.first), findsOneWidget);
    });

    testWidgets('forwards onTap when the control is opened', (tester) async {
      var taps = 0;
      await _pump(tester, onTap: () => taps++);

      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();

      expect(taps, 1);
    });

    testWidgets('open menu items inherit bgPrimaryHover as their hover colour', (tester) async {
      await _pump(tester);

      await tester.tap(find.byType(DropdownButton<String>));
      await tester.pumpAndSettle();

      final menuItem = find.descendant(of: find.byType(InkWell), matching: find.text(_items.last));
      expect(menuItem, findsOneWidget);

      final inkWellContext = tester.element(
        find.ancestor(of: menuItem, matching: find.byType(InkWell)).first,
      );
      expect(Theme.of(inkWellContext).hoverColor, palette.bgPrimaryHover);
    });
  });
}
