import 'package:flutter/material.dart';

abstract class Palette {
  static const Color white = Color(0xffffffff);
  static const Color black = Color(0xff363355);
  static const Color transparent = Colors.transparent;
  static const Color darkBlue = Color(0xff2D2A49);
  static const Color lightBlack = Color(0xff6A678E);
  static const Color lightBlue = Color(0xffC4C1DD);
  static const Color veryLightGrey = Color(0xffF5F5F5);
  static const Color lightGrey = Color(0xffF8F9FD);
  static const Color purple = Color(0xffC574D9);
  static const Color pink = Color(0xffF44D89);
  static const Color lightPurple = Color(0xffD89DE7);
  static const Color mediumBlack = Color(0xff3E3B5F);
  static const Color green = Color(0xff93F05A);

  Color get highlightColor;
  Color get secondaryColor;
  Color get lightTextColor;
  Color get backgroundGolor;
  Color get darkTextColor;
  Color get primaryColor;
  Color get surfaceColor;
  Color get placeholderColor;
  Color get tertiaryColor;
  Color get scrimColor;
  MaterialColor get swatchColor;
}

class LightPalette implements Palette {
  @override
  Color get highlightColor => Palette.purple;

  @override
  Color get secondaryColor => Palette.black;

  @override
  Color get lightTextColor => Palette.lightBlue;

  @override
  Color get darkTextColor => Palette.lightBlack;

  @override
  Color get backgroundGolor => Palette.veryLightGrey;

  @override
  Color get primaryColor => Palette.white;

  @override
  MaterialColor get swatchColor => MaterialColor(0xffF44D89, color);

  @override
  Color get surfaceColor => Palette.lightGrey;

  @override
  Color get placeholderColor => const Color(0xffEEEDFB);

  @override
  Color get tertiaryColor => Palette.lightGrey;

  @override
  Color get scrimColor => Palette.black;
}

class DarkPalette implements Palette {
  @override
  Color get highlightColor => Palette.purple;

  @override
  Color get secondaryColor => Palette.white;

  @override
  Color get lightTextColor => Palette.lightBlack;

  @override
  Color get darkTextColor => Palette.lightBlack;

  @override
  Color get backgroundGolor => Palette.darkBlue;
  @override
  Color get primaryColor => Palette.black;
  @override
  MaterialColor get swatchColor => MaterialColor(0xffF44D89, color);

  @override
  Color get surfaceColor => Palette.mediumBlack;

  @override
  Color get placeholderColor => Palette.black;

  @override
  Color get tertiaryColor => Palette.black;

  @override
  Color get scrimColor => Palette.lightBlack;
}

Map<int, Color> color = const {
  50: Color.fromRGBO(136, 14, 79, .1),
  100: Color.fromRGBO(136, 14, 79, .2),
  200: Color.fromRGBO(136, 14, 79, .3),
  300: Color.fromRGBO(136, 14, 79, .4),
  400: Color.fromRGBO(136, 14, 79, .5),
  500: Color.fromRGBO(136, 14, 79, .6),
  600: Color.fromRGBO(136, 14, 79, .7),
  700: Color.fromRGBO(136, 14, 79, .8),
  800: Color.fromRGBO(136, 14, 79, .9),
  900: Color.fromRGBO(136, 14, 79, 1),
};
