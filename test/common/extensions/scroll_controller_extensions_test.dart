import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';

/// Pumps a tall list wired to [controller] so it has a real scroll position.
Future<void> _pumpList(WidgetTester tester, ScrollController controller) async {
  await tester.pumpWidget(
    MaterialApp(
      home: ListView.builder(
        controller: controller,
        itemCount: 500,
        itemExtent: 100,
        itemBuilder: (_, i) => Text('row $i'),
      ),
    ),
  );
}

void main() {
  group('animateToTop', () {
    testWidgets('returns the list to the top', (tester) async {
      final controller = ScrollController();
      addTearDown(controller.dispose);
      await _pumpList(tester, controller);
      controller.jumpTo(800);

      unawaited(controller.animateToTop());
      await tester.pumpAndSettle();

      expect(controller.offset, 0);
    });

    testWidgets('skips ahead before animating from deep in the list', (tester) async {
      final controller = ScrollController();
      addTearDown(controller.dispose);
      await _pumpList(tester, controller);
      controller.jumpTo(40000);

      unawaited(controller.animateToTop());
      // The jump is synchronous; the animation has not started yet.
      expect(controller.offset, lessThanOrEqualTo(2000));

      await tester.pumpAndSettle();
      expect(controller.offset, 0);
    });

    testWidgets('does nothing when already at the top', (tester) async {
      final controller = ScrollController();
      addTearDown(controller.dispose);
      await _pumpList(tester, controller);

      await controller.animateToTop();

      expect(controller.offset, 0);
    });

    testWidgets('tolerates an unattached controller', (tester) async {
      final detached = ScrollController();
      addTearDown(detached.dispose);

      await expectLater(detached.animateToTop(), completes);
    });
  });
}
