import 'dart:async';

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
/// [StepController.next] / [StepController.back] callbacks.
///
/// [count] must be at least 1. [initialStep] is the step the controller
/// starts on — useful for resuming an interrupted flow from a persisted
/// position. [onStepChange] fires after every successful step transition
/// (forward or back) so callers can persist the new position; it may return
/// a [Future] (e.g. to await a disk write) and any error it throws is
/// reported via [FlutterError.reportError] instead of becoming an unhandled
/// asynchronous error.
StepController useStepController(
  int count, {
  int initialStep = 0,
  FutureOr<void> Function(int)? onStepChange,
}) {
  assert(count > 0, 'count must be > 0');
  assert(initialStep >= 0 && initialStep < count, 'initialStep must be in [0, count)');
  final state = useState(initialStep);
  void update(int newStep) {
    state.value = newStep;
    final result = onStepChange?.call(newStep);
    if (result is Future<void>) {
      result.catchError((Object error, StackTrace stack) {
        FlutterError.reportError(
          FlutterErrorDetails(
            exception: error,
            stack: stack,
            library: 'step_controller_hook',
            context: ErrorDescription('while persisting step $newStep'),
          ),
        );
      });
    }
  }

  return StepController(
    step: state.value,
    isLast: state.value >= count - 1,
    next: () {
      if (state.value < count - 1) {
        update(state.value + 1);
      }
    },
    back: () {
      if (state.value > 0) {
        update(state.value - 1);
      }
    },
  );
}
