import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/core/styles/style.dart';

class LinkSpan extends TextSpan {
  LinkSpan({required String text, required VoidCallback onTap, TextStyle? style})
    : super(
        text: text,
        style:
            style?.copyWith(
              color: style.color ?? Palette.pink,
              decoration: TextDecoration.underline,
            ) ??
            const TextStyle(color: Palette.pink, decoration: TextDecoration.underline),
        recognizer: TapGestureRecognizer()..onTap = onTap,
      );
}
