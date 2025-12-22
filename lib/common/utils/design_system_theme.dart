import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/style.dart';

abstract class DesignSystemTheme {
  const DesignSystemTheme._();

  static ThemeData of(BuildContext context) => Theme.of(context).designSystem;
}
