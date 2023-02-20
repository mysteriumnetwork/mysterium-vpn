import 'package:flutter/material.dart';

class RetakeFocusOnTap extends StatelessWidget {
  final Widget? child;
  const RetakeFocusOnTap({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: child,
    );
  }
}
