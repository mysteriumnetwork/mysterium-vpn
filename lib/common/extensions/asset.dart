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
