import 'package:flutter/material.dart';

extension ScrollControllerExtensions on ScrollController {
  Future<void> scrollToPosition(
    double value, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) async {
    await animateTo(value, duration: duration, curve: curve);
  }

  /// Animates back to the top. No-op when unattached or already there.
  ///
  /// From far down a lazy list, skips to [maxAnimatedExtent] first so the
  /// animation does not build every intervening row.
  Future<void> animateToTop({
    Duration duration = const Duration(milliseconds: 450),
    Curve curve = Curves.easeOut,
    double maxAnimatedExtent = 2000,
  }) async {
    if (!hasClients || offset <= 0) {
      return;
    }
    if (offset > maxAnimatedExtent) {
      jumpTo(maxAnimatedExtent);
    }
    await scrollToPosition(0, duration: duration, curve: curve);
  }

  Future<void> scrollToKey(
    GlobalKey key, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) async {
    final ctx = key.currentContext;
    if (ctx == null) {
      await animateTo(position.maxScrollExtent, duration: duration, curve: curve);
      return;
    }

    await Scrollable.ensureVisible(ctx, duration: duration, curve: curve);
  }
}
