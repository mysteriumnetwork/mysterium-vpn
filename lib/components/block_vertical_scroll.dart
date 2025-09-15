import 'package:flutter/material.dart';

class BlockVerticalScroll extends StatelessWidget {
  const BlockVerticalScroll({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) => GestureDetector(
        behavior: HitTestBehavior.opaque,
        // ensure we hit-test the whole area
        onVerticalDragDown: (_) {},
        // claim vertical gesture
        onVerticalDragStart: (_) {},
        // …so parent can't win
        onVerticalDragUpdate: (_) {},
        onVerticalDragEnd: (_) {},
        child: child,
      );
}
