import 'package:circle_flags/circle_flags.dart';
import 'package:flutter/material.dart';

class Flag extends StatelessWidget {
  const Flag({
    required this.countryCode,
    super.key,
  });
  final String countryCode;
  @override
  Widget build(BuildContext context) => CircleFlag(
        countryCode,
        size: 20,
      );
}
