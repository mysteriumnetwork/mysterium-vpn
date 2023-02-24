import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';

ThemeData themeData(Palette palette) => ThemeData(
      useMaterial3: true,
      primaryColor: palette.primaryColor,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        background: palette.backgroundGolor,
        surface: palette.surfaceColor,
        primary: palette.swatchColor,
        brightness: palette is LightPalette ? Brightness.light : Brightness.dark,
        error: Palette.pink,
        tertiary: palette.tertiaryColor,
        secondary: palette.placeholderColor,
        scrim: palette.scrimColor,
      ),
      indicatorColor: palette.secondaryColor,
      hintColor: palette.darkTextColor,
      secondaryHeaderColor: palette.lightTextColor,
      highlightColor: palette.highlightColor.withOpacity(0.4),
      //hoverColor: palette.secondaryColor,
      disabledColor: palette.darkTextColor,
      //cardColor:
      //canvasColor: isDarkTheme ? Colors.black : Colors.grey[50],
      buttonTheme: ButtonThemeData(
        colorScheme: palette is LightPalette ? const ColorScheme.dark() : const ColorScheme.light(),
      ),
      textTheme: GoogleFonts.montserratTextTheme().apply(
        bodyColor: palette.secondaryColor,
        displayColor: palette.secondaryColor,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          minimumSize: const Size(200, 40),
          backgroundColor: palette.highlightColor,
          disabledBackgroundColor: palette.highlightColor.withOpacity(0.4),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3),
        ),
        fillColor: MaterialStateProperty.all(Palette.pink),
        overlayColor: MaterialStateProperty.all(Palette.pink),
        checkColor: MaterialStateProperty.all(Palette.white),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: MaterialStateProperty.all(
          Palette.lightGrey,
        ),
        trackColor: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.selected) ? Palette.purple : Palette.lightBlue,
        ),
        thumbIcon: MaterialStateProperty.resolveWith(
          (states) => states.contains(MaterialState.selected)
              ? const Icon(Icons.check, color: Palette.purple)
              : const Icon(Icons.close, color: Palette.lightBlue),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
    );
