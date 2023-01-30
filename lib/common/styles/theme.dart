import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';

class MysteriumVPNTheme {
  static ThemeData themeData(
    Palette palette,
  ) {
    return ThemeData(
      primaryColor: palette.primaryColor,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        background: palette.backgroundGolor,
        surface: palette.surfaceColor,
        primary: palette.swatchColor,
        brightness: palette is LightPalette ? Brightness.light : Brightness.dark,
      ),
      indicatorColor: palette.highlightColor,
      hintColor: palette.darkTextColor,
      highlightColor: palette.highlightColor,
      primaryTextTheme: TextTheme(
        titleLarge: TextStyle(color: palette.secondaryColor),
        bodyLarge: TextStyle(color: palette.secondaryColor),
      ),
      //hoverColor: palette.secondaryColor,
      focusColor: Palette.pink,
      disabledColor: palette.darkTextColor,
      //cardColor:
      //canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
      buttonTheme:
          ButtonThemeData(colorScheme: palette is LightPalette ? const ColorScheme.dark() : const ColorScheme.light()),

      textTheme: GoogleFonts.lexendTextTheme(),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          minimumSize: const Size(200, 40),
          backgroundColor: palette.highlightColor,
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3.0),
        ),
        fillColor: MaterialStateProperty.all(Palette.pink),
        overlayColor: MaterialStateProperty.all(Palette.pink),
        checkColor: MaterialStateProperty.all(Palette.white),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
    );
  }
}
