import 'package:flutter/widgets.dart';

/// Pops [context]'s route, but only while it is still the top-most one.
/// Returns whether it popped.
///
/// A plain `Navigator.pop` targets whatever is on top, which is the wrong
/// route whenever the caller's own route already left (barrier tap, sheet
/// drag, system Back) or something was pushed above it — a dialog opened by
/// an `onChanged` handler, say. Both cases otherwise take the page
/// underneath.
bool popIfCurrent<T>(BuildContext context, [T? result]) {
  final route = ModalRoute.of(context);
  if (route == null || !route.isCurrent) {
    return false;
  }
  Navigator.of(context).pop(result);
  return true;
}
