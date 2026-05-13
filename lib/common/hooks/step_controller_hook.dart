import 'package:flutter/foundation.dart';
import 'package:flutter_hooks/flutter_hooks.dart';

/// State and navigation callbacks for a stepped flow (e.g. onboarding,
/// multi-step forms). [step] is the current index, [isLast] is true at the
/// final step, and [next] / [back] are guarded — calling them at the
/// boundaries is a no-op.
@immutable
class StepController {
  const StepController({
    required this.step,
    required this.isLast,
    required this.next,
    required this.back,
  });

  final int step;
  final bool isLast;
  final VoidCallback next;
  final VoidCallback back;
}

/// Holds the current step index in a stepped flow and exposes guarded
/// [StepController.next] / [StepController.back] callbacks. [count] must be
/// at least 1.
StepController useStepController(int count) {
  assert(count > 0, 'count must be > 0');
  final state = useState(0);
  return StepController(
    step: state.value,
    isLast: state.value >= count - 1,
    next: () {
      if (state.value < count - 1) {
        state.value += 1;
      }
    },
    back: () {
      if (state.value > 0) {
        state.value -= 1;
      }
    },
  );
}
