import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';

class MysteriumVPNTheme {
  static ThemeData themeData(
    Palette palette,
  ) {
    return ThemeData(
      primarySwatch: palette.swatchColor,
      primaryColor: palette.primaryColor,
      backgroundColor: palette.backgroundGolor,
      indicatorColor: palette.highlightColor,
      hintColor: palette.darkTextColor,
      highlightColor: palette.highlightColor,
      primaryTextTheme: TextTheme(
        headline6: TextStyle(color: palette.secondaryColor),
        bodyText1: TextStyle(color: palette.secondaryColor),
      ),
      //hoverColor: palette.secondaryColor,
      focusColor: Palette.pink,
      disabledColor: palette.darkTextColor,
      //cardColor:
      //canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
      brightness: palette is LightPalette ? Brightness.light : Brightness.dark,
      buttonTheme:
          ButtonThemeData(colorScheme: palette is LightPalette ? const ColorScheme.dark() : const ColorScheme.light()),
      appBarTheme: const AppBarTheme(
        elevation: 0.0,
      ),
      textTheme: GoogleFonts.lexendTextTheme(),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          backgroundColor: palette.highlightColor,
        ),
      ),
    );
  }
}
