import 'package:flutter/material.dart';

class RetakeFocusOnTap extends StatelessWidget {
  const RetakeFocusOnTap({required this.child, super.key});
  final Widget? child;

  @override
  Widget build(BuildContext context) => GestureDetector(
    behavior: HitTestBehavior.opaque,
    onTap: () {
      FocusManager.instance.primaryFocus?.unfocus();
    },
    child: child,
  );
}
