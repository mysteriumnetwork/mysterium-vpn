import 'package:flutter/widgets.dart';

class ParentScrollController extends InheritedWidget {
  const ParentScrollController({required this.controller, required super.child, super.key});

  final ScrollController controller;

  static ScrollController? of(BuildContext context) =>
      context.dependOnInheritedWidgetOfExactType<ParentScrollController>()?.controller;

  @override
  bool updateShouldNotify(covariant InheritedWidget oldWidget) => this != oldWidget;
}
