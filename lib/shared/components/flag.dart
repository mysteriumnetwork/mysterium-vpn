import 'package:circle_flags/circle_flags.dart';
import 'package:flutter/material.dart';
import 'package:mysterium_vpn/core/styles/style.dart';

class Flag extends StatelessWidget {
  const Flag({required this.countryCode, this.size = 20, super.key});
  final String countryCode;
  final double size;
  @override
  Widget build(BuildContext context) => Container(
    width: size + 2,
    height: size + 2,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(100),
      border: Border.all(color: Palette.white, width: 2),
    ),
    child: CircleFlag(countryCode, size: size),
  );
}
