import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/styles/palette.dart';

ThemeData themeData(Palette palette) => ThemeData(
      useMaterial3: true,
      primaryColor: palette.primaryColor,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        onSurface: palette.backgroundGolor,
        surface: palette.surfaceColor,
        primary: palette.swatchColor,
        brightness: palette is LightPalette ? Brightness.light : Brightness.dark,
        error: Palette.pink,
        tertiary: palette.tertiaryColor,
        secondary: palette.placeholderColor,
        scrim: palette.scrimColor,
        surfaceContainerHigh: palette.disclaimerBackgroundColor,
        surfaceContainerHighest: palette.headerColor,
        primaryContainer: palette.tileColor,
      ),
      indicatorColor: palette.secondaryColor,
      hintColor: palette.darkTextColor,
      secondaryHeaderColor: palette.lightTextColor,
      highlightColor: palette.highlightColor.withValues(alpha: 0.4),
      disabledColor: palette.disabledColor.darken(palette is LightPalette ? 10 : 30),
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
          minimumSize: const Size(200, 50),
          backgroundColor: palette.buttonBackgroundColor,
          disabledBackgroundColor: palette.highlightColor.withValues(alpha: 0.4),
        ),
      ),
      checkboxTheme: CheckboxThemeData(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(3),
        ),
        fillColor: WidgetStateProperty.all(Palette.pink),
        overlayColor: WidgetStateProperty.all(Palette.transparent),
        checkColor: WidgetStateProperty.all(Palette.white),
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all(
          Palette.lightGrey,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected) ? Palette.purple : Palette.lightBlue,
        ),
        thumbIcon: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.selected)
              ? const Icon(Icons.check, color: Palette.purple)
              : const Icon(Icons.close, color: Palette.lightBlue),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(
          color: palette.secondaryColor,
        ),
        labelStyle: TextStyle(
          color: palette.secondaryColor,
        ),
        filled: true,
        contentPadding: const EdgeInsets.only(left: 20),
        fillColor: palette.surfaceColor,
        outlineBorder: BorderSide(color: palette.lightTextColor),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: palette.lightTextColor),
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: palette.lightTextColor,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: palette.lightTextColor,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Palette.pink,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: const BorderSide(
            color: Palette.pink,
          ),
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          side: BorderSide(color: palette.outlinedButtonBorderColor),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          foregroundColor: palette.outlinedButtonTextColor,
          backgroundColor: palette.outlinedButtonBackgroundColor,
          disabledForegroundColor: palette.outlinedButtonTextColor.withValues(alpha: .5),
          disabledBackgroundColor: palette.outlinedButtonBackgroundColor.withValues(alpha: .5),
          padding: const EdgeInsets.all(10),
        ),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          padding: const EdgeInsets.all(10),
          backgroundColor: palette.filledButtonBackgroundColor,
          foregroundColor: palette.filledButtonTextColor,
          disabledBackgroundColor: palette.filledButtonBackgroundColor.withValues(alpha: .6),
          disabledForegroundColor: palette.filledButtonTextColor.withValues(alpha: .7),
          disabledIconColor: palette.filledButtonTextColor.withValues(alpha: .7),
        ),
      ),
    );
