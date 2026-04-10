import 'package:flutter/material.dart';

extension ColorShades on Color {
  Color darken([int percent = 10]) {
    assert(1 <= percent && percent <= 100, 'must be between 1 and 100');
    final f = 1 - percent / 100;
    return Color.fromARGB(a.round(), (r * f).round(), (g * f).round(), (b * f).round());
  }

  Color lighten([int percent = 10]) {
    assert(1 <= percent && percent <= 100, 'must be between 1 and 100');
    final p = percent / 100;
    return Color.fromARGB(
      a.round(),
      (r + ((255 - r) * p)).round(),
      (g + ((255 - g) * p)).round(),
      (b + ((255 - b) * p)).round(),
    );
  }
}
