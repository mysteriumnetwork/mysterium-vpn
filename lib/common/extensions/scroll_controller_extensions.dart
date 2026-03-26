import 'package:flutter/material.dart';

extension ScrollControllerExtensions on ScrollController {
  Future<void> scrollToPosition(
    double value, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
  }) async {
    await animateTo(value, duration: duration, curve: curve);
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
