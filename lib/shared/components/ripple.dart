import 'package:flutter/material.dart';

class RippleWidget extends StatelessWidget {
  const RippleWidget({required this.child, required this.radius, required this.onTap, super.key});
  final Widget child;
  final double radius;
  final VoidCallback? onTap;
  @override
  Widget build(BuildContext context) => Material(
    color: Colors.transparent,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(radius)),
    clipBehavior: Clip.hardEdge,
    child: InkWell(onTap: onTap, child: child),
  );
}
