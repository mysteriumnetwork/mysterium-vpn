import 'package:flutter/material.dart';
import 'package:flutter_hooks/flutter_hooks.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/common/hooks/step_controller_hook.dart';

void main() {
  // ---------------------------------------------------------------------------
  // Helpers
  // ---------------------------------------------------------------------------

  StepController? captured;

  Widget buildHarness(int count) => MaterialApp(
    home: HookBuilder(
      builder: (_) {
        captured = useStepController(count);
        return const SizedBox.shrink();
      },
    ),
  );

  setUp(() => captured = null);

  // ---------------------------------------------------------------------------
  // Test cases
  // ---------------------------------------------------------------------------

  group('useStepController', () {
    testWidgets('starts at step 0', (tester) async {
      await tester.pumpWidget(buildHarness(3));
      expect(captured!.step, 0);
      expect(captured!.isLast, false);
    });

    testWidgets('next advances the step', (tester) async {
      await tester.pumpWidget(buildHarness(3));
      captured!.next();
      await tester.pump();
      expect(captured!.step, 1);
      expect(captured!.isLast, false);
    });

    testWidgets('back returns to previous step', (tester) async {
      await tester.pumpWidget(buildHarness(3));
      captured!.next();
      await tester.pump();
      captured!.next();
      await tester.pump();
      expect(captured!.step, 2);

      captured!.back();
      await tester.pump();
      expect(captured!.step, 1);
    });

    testWidgets('next at the last step is a no-op', (tester) async {
      await tester.pumpWidget(buildHarness(2));
      captured!.next();
      await tester.pump();
      expect(captured!.step, 1);
      expect(captured!.isLast, true);

      captured!.next();
      await tester.pump();
      expect(captured!.step, 1);
    });

    testWidgets('back at the first step is a no-op', (tester) async {
      await tester.pumpWidget(buildHarness(3));
      expect(captured!.step, 0);

      captured!.back();
      await tester.pump();
      expect(captured!.step, 0);
    });

    testWidgets('isLast is true when count is 1', (tester) async {
      await tester.pumpWidget(buildHarness(1));
      expect(captured!.step, 0);
      expect(captured!.isLast, true);
    });
  });
}
