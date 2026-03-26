import 'package:flutter/material.dart';

class CircleBox extends StatelessWidget {
  const CircleBox({required this.color, required this.size, super.key});
  final Color color;
  final double size;
  @override
  Widget build(BuildContext context) => Container(
    width: size,
    height: size,
    decoration: BoxDecoration(shape: BoxShape.circle, color: color),
  );
}
