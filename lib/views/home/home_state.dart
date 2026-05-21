import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:hooks_riverpod/legacy.dart';

class _HomeState extends ChangeNotifier {
  _HomeState();

  final typeSwitcherKey = GlobalKey();
  final locationsKey = GlobalKey();

  ScrollController? scrollController;

  /// Tracks the country code that was already scrolled to, so the
  /// scroll-to-selected logic fires only once per selection.
  String? lastScrolledCountryCode;
}

// ignore: deprecated_member_use
final homeStateProvider = ChangeNotifierProvider.autoDispose((ref) => _HomeState());
