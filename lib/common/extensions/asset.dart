import 'package:flutter/material.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';

extension $AssetsIconsGenExtensions on $AssetsIconsGen {
  SvgGenImage fix(BuildContext context) => _withBrightness(context, light: fixLight, dark: fixDark);
}

extension $AssetsImagesGenExtensions on $AssetsImagesGen {
  AssetGenImage emailConsent(BuildContext context) =>
      _withBrightness(context, light: emailPermissionsLight, dark: emailPermissionsDark);

  AssetGenImage pnConsent(BuildContext context) =>
      _withBrightness(context, light: pnPermissionsLight, dark: pnPermissionsDark);
  SvgGenImage onboardingMap(BuildContext context) =>
      _withBrightness(context, light: onboardingMapLight, dark: onboardingMapDark);
  AssetGenImage houseOnboarding(BuildContext context) =>
      _withBrightness(context, light: houseLight, dark: houseDark);
  AssetGenImage serversOnboarding(BuildContext context) =>
      _withBrightness(context, light: serversLight, dark: serversDark);
}

extension $AssetsLogoGenExtensions on $AssetsLogoGen {
  SvgGenImage logoStacked(BuildContext context) =>
      _withBrightness(context, light: logoStackedLight, dark: logoStackedDark);
}

extension $ResourcesLangsGenExtensions on $ResourcesLangsGen {
  String get path => 'resources/langs';
}

T _withBrightness<T>(BuildContext context, {required T light, required T dark}) =>
    switch (Theme.of(context).brightness) {
      Brightness.dark => dark,
      Brightness.light => light,
    };
