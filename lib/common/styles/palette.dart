import 'package:flutter/material.dart';

abstract class Palette {
  static const Color white = Color(0xffffffff);
  static const Color black = Color(0xff363355);
  static const Color transparent = Colors.transparent;
  static const Color darkBlue = Color(0xff2D2A49);
  static const Color lightBlack = Color(0xff6A678E);
  static const Color lightBlue = Color(0xffC4C1DD);
  static const Color lightGrey = Color(0xffF8F9FD);
  static const Color veryLightGrey = Color(0xffE2E1EF);
  static const Color purple = Color(0xffC574D9);
  static const Color pink = Color(0xffF44D89);
  static const Color lightPurple = Color(0xffD89DE7);
  static const Color mediumBlack = Color(0xff3E3B5F);
  static const Color green = Color(0xff4DC800);
  static const Color blue = Color(0xff236EFF);
  static const Color darkGrey = Color(0xff908EA6);
  static const Color forestGreen = Color(0xff429218);
  static const Color crimsonRed = Color(0xffA62B2B);
  static const Color lightLavender = Color(0xffDED9EF);
  static const Color darkIndigo = Color(0xff353352);
  static const Color deepPurple = Color(0xff1E1632);
  static const Color veryLightBlue = Color(0xffF0F2FF);
  static const Color yellow = Color(0xffE2AF00);
  static const Color darkOliveBrown = Color(0xff514314);
  static const Color paleYellow = Color(0xffFFF6D9);
  static const Color grayContainer = Color(0xFFF5F3FD);
  static const Color grayScaffold = Color(0xFFA09EB7);
  static const Color darkPurple = Color(0xFF4B486C);
  static const Color semiTransparentLightBlack = Color(0x666A678E);
  static const Color duskyPurple = Color(0xff524E77);

  Color get highlightColor;
  Color get secondaryColor;
  Color get subtitleColor;
  Color get lightTextColor;
  Color get backgroundColor;
  Color get darkTextColor;
  Color get primaryColor;
  Color get surfaceColor;
  Color get placeholderColor;
  Color get tertiaryColor;
  Color get scrimColor;
  Color get buttonBackgroundColor;
  Color get disabledColor;
  Color get disclaimerBackgroundColor;
  Color get tileColor;
  Color get secondaryTileColor;
  Color get filledButtonBackgroundColor;
  Color get filledButtonTextColor;
  Color get outlinedButtonTextColor;
  Color get outlinedButtonBorderColor;
  Color get outlinedButtonBackgroundColor;
  Color get headerColor;
  Color get inputColor;
  Color get inputHintColor;
  Color get tertiaryContainer;
  Color get alertButtonsOutlineColor;
  Color get connectionTileBackgroundColor;
  Color get connectionTileOutlineConnectedColor;
  Color get connectionTileOutlineDisconnectedColor;
  Color get tooltipBackgroundColor;
  Color get disabledButtonBackgroundColor;
  Color get disabledButtonForegroundColor;

  MaterialColor get swatchColor;
}

class LightPalette implements Palette {
  @override
  Color get highlightColor => Palette.purple;

  @override
  Color get secondaryColor => Palette.black;

  @override
  Color get subtitleColor => Palette.lightBlack;

  @override
  Color get lightTextColor => Palette.lightBlue;

  @override
  Color get darkTextColor => Palette.lightBlack;

  @override
  Color get backgroundColor => Palette.veryLightGrey;

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

  @override
  Color get buttonBackgroundColor => Palette.darkBlue;

  @override
  Color get disabledColor => Palette.white;

  @override
  Color get disclaimerBackgroundColor => Palette.white;

  @override
  Color get tileColor => Palette.white;

  @override
  Color get filledButtonBackgroundColor => Palette.lightBlack;

  @override
  Color get filledButtonTextColor => Palette.white;

  @override
  Color get outlinedButtonBackgroundColor => Palette.white;

  @override
  Color get outlinedButtonBorderColor => Palette.purple;

  @override
  Color get outlinedButtonTextColor => Palette.purple;

  @override
  Color get headerColor => Palette.white;

  @override
  Color get inputColor => const Color(0xFFEFEFF3);

  @override
  Color get inputHintColor => Palette.lightBlack;

  @override
  Color get secondaryTileColor => const Color(0xFFEFEFF3);

  @override
  Color get tertiaryContainer => const Color(0xFFEFEFF3);

  @override
  Color get alertButtonsOutlineColor => Palette.semiTransparentLightBlack;

  @override
  Color get connectionTileBackgroundColor => const Color(0xFFEFEFF3);

  @override
  Color get connectionTileOutlineConnectedColor => Palette.forestGreen;

  @override
  Color get connectionTileOutlineDisconnectedColor => Palette.crimsonRed;

  @override
  Color get tooltipBackgroundColor => Palette.white;

  @override
  Color get disabledButtonBackgroundColor => Palette.lightBlue;

  @override
  Color get disabledButtonForegroundColor => Palette.lightBlack;
}

class DarkPalette implements Palette {
  @override
  Color get highlightColor => Palette.purple;

  @override
  Color get secondaryColor => Palette.white;

  @override
  Color get subtitleColor => Palette.lightBlue;

  @override
  Color get lightTextColor => Palette.lightBlack;

  @override
  Color get darkTextColor => Palette.lightBlack;

  @override
  Color get backgroundColor => Palette.darkBlue;

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

  @override
  Color get buttonBackgroundColor => Palette.purple;

  @override
  Color get disabledColor => Palette.mediumBlack;

  @override
  Color get disclaimerBackgroundColor => Palette.lightBlack;

  @override
  Color get tileColor => Palette.darkIndigo;

  @override
  Color get filledButtonBackgroundColor => Palette.lightBlack;

  @override
  Color get filledButtonTextColor => Palette.white;

  @override
  Color get outlinedButtonBackgroundColor => Palette.mediumBlack;

  @override
  Color get outlinedButtonBorderColor => Palette.purple;

  @override
  Color get outlinedButtonTextColor => Palette.white;

  @override
  Color get headerColor => Palette.deepPurple;

  @override
  Color get inputColor => Palette.mediumBlack;

  @override
  Color get inputHintColor => Palette.veryLightGrey;

  @override
  Color get secondaryTileColor => Palette.deepPurple;

  @override
  Color get tertiaryContainer => Palette.mediumBlack;

  @override
  Color get alertButtonsOutlineColor => Palette.darkPurple;

  @override
  Color get connectionTileBackgroundColor => Palette.deepPurple;

  @override
  Color get connectionTileOutlineConnectedColor => Palette.forestGreen;

  @override
  Color get connectionTileOutlineDisconnectedColor => Palette.crimsonRed;

  @override
  Color get tooltipBackgroundColor => Palette.duskyPurple;

  @override
  Color get disabledButtonBackgroundColor => Palette.lightBlue;

  @override
  Color get disabledButtonForegroundColor => Palette.lightBlack;
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
