import 'package:circle_flags/circle_flags.dart';
import 'package:flutter/material.dart';

class Flag extends StatelessWidget {
  const Flag({
    required this.countryCode,
    this.size = 20,
    super.key,
  });
  final String countryCode;
  final double size;
  @override
  Widget build(BuildContext context) => CircleFlag(
        countryCode,
        size: size,
      );
}
