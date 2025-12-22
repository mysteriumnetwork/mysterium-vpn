import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/common/styles/style.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart' as design;

ThemeData themeData(Palette palette) => ThemeData(
      useMaterial3: true,
      primaryColor: palette.primaryColor,
      colorScheme: ColorScheme.fromSwatch().copyWith(
        onSurface: palette.backgroundColor,
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
        secondaryContainer: palette.secondaryTileColor,
        onSecondaryContainer: palette.secondaryColor.withValues(alpha: .75),
        tertiaryContainer: palette.tertiaryContainer,
        outline: palette.scrimColor,
      ),
      tabBarTheme: TabBarThemeData(
        indicatorColor: palette.secondaryColor,
      ),
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
        side: BorderSide.none,
      ),
      switchTheme: SwitchThemeData(
        thumbColor: WidgetStateProperty.all(
          Palette.veryLightBlue,
        ),
        trackColor: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.disabled)
              ? palette.filledButtonTextColor.withValues(alpha: .7)
              : states.contains(WidgetState.selected)
                  ? Palette.purple
                  : Palette.lightBlue,
        ),
        thumbIcon: WidgetStateProperty.resolveWith(
          (states) => states.contains(WidgetState.disabled)
              ? const Icon(
                  Icons.remove,
                  color: Palette.lightBlue,
                )
              : states.contains(WidgetState.selected)
                  ? const Icon(Icons.check, color: Palette.purple)
                  : const Icon(Icons.close, color: Palette.lightBlue),
        ),
        trackOutlineColor: WidgetStateProperty.all(Colors.transparent),
        trackOutlineWidth: WidgetStateProperty.all(0),
      ),
      inputDecorationTheme: InputDecorationTheme(
        hintStyle: TextStyle(color: palette.inputHintColor),
        labelStyle: TextStyle(color: palette.secondaryColor),
        filled: true,
        contentPadding: const EdgeInsets.only(left: 20),
        fillColor: palette.inputColor,
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
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
          foregroundColor: palette.outlinedButtonTextColor,
          backgroundColor: palette.outlinedButtonBackgroundColor,
          disabledForegroundColor: palette.outlinedButtonDisabledColor,
          disabledBackgroundColor: palette.outlinedButtonBackgroundColor.withValues(alpha: .5),
          padding: const EdgeInsets.all(10),
        ).merge(
          ButtonStyle(
            side: WidgetStateProperty.resolveWith((states) {
              if (states.contains(WidgetState.disabled)) {
                return BorderSide(color: palette.outlinedButtonDisabledColor);
              }
              return BorderSide(color: palette.outlinedButtonBorderColor);
            }),
          ),
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
      extensions: <ThemeExtension<dynamic>>[
        _ThemeColorsX(
          isDarkMode: palette is DarkPalette,
        ),
        _DesignSystemThemeX(
          designSystem: palette is LightPalette
              ? design.DesignSystem.lightTheme
              : design.DesignSystem.darkTheme,
        ),
      ],
    );

extension ThemeExtensionX on BuildContext {
  // ignore: library_private_types_in_public_api
  _ThemeColorsX get c => Theme.of(this).extension<_ThemeColorsX>()!;
}

class _DesignSystemThemeX extends ThemeExtension<_DesignSystemThemeX> {
  const _DesignSystemThemeX({required this.designSystem});

  final ThemeData designSystem;

  @override
  ThemeExtension<_DesignSystemThemeX> copyWith() => this;

  @override
  ThemeExtension<_DesignSystemThemeX> lerp(
    covariant ThemeExtension<_DesignSystemThemeX>? other,
    double t,
  ) =>
      this;
}

class _ThemeColorsX extends ThemeExtension<_ThemeColorsX> {
  const _ThemeColorsX({required this.isDarkMode});

  final bool isDarkMode;

  Palette get palette => isDarkMode ? DarkPalette() : LightPalette();

  @override
  ThemeExtension<_ThemeColorsX> copyWith() => this;

  @override
  ThemeExtension<_ThemeColorsX> lerp(
    covariant ThemeExtension<_ThemeColorsX>? other,
    double t,
  ) =>
      this;
}

extension ThemeExtensions on ThemeData {
  Palette get palette => extension<_ThemeColorsX>()!.palette;

  ThemeData get designSystem {
    if (isDesignSystem) {
      return this;
    }
    return extension<_DesignSystemThemeX>()!.designSystem;
  }
}
