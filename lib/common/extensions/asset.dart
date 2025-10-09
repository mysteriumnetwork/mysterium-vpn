import 'package:flutter/material.dart';
import 'package:mysterium_vpn/gen/assets.gen.dart';

extension $AssetsIconsGenExtensions on $AssetsIconsGen {
  SvgGenImage accountName(BuildContext context) => _withBrightness(
        context,
        light: accountNameLight,
        dark: accountNameDark,
      );

  SvgGenImage billing(BuildContext context) => _withBrightness(
        context,
        light: billingLight,
        dark: billingDark,
      );

  SvgGenImage city(BuildContext context) => _withBrightness(
        context,
        light: cityLight,
        dark: cityDark,
      );

  SvgGenImage close(BuildContext context) => _withBrightness(
        context,
        light: closeLight,
        dark: closeDark,
      );

  SvgGenImage close2(BuildContext context) => _withBrightness(
        context,
        light: close2Light,
        dark: close2Dark,
      );

  SvgGenImage connectPrompt(BuildContext context) => _withBrightness(
        context,
        light: connectPromptLight,
        dark: connectPromptDark,
      );

  SvgGenImage deleteAccount(BuildContext context) => _withBrightness(
        context,
        light: deleteAccountLight,
        dark: deleteAccountDark,
      );

  SvgGenImage fix(BuildContext context) => _withBrightness(
        context,
        light: fixLight,
        dark: fixDark,
      );

  SvgGenImage flashAdaptive(BuildContext context) => _withBrightness(
        context,
        light: flashLight,
        dark: flashDark,
      );

  SvgGenImage infoCircle(BuildContext context) => _withBrightness(
        context,
        light: infoCircleLight,
        dark: infoCircleDark,
      );

  SvgGenImage language(BuildContext context) => _withBrightness(
        context,
        light: languageLight,
        dark: languageDark,
      );

  SvgGenImage locker(BuildContext context) => _withBrightness(
        context,
        light: lockerLight,
        dark: lockerDark,
      );

  SvgGenImage navigateBackAdaptive(BuildContext context) => _withBrightness(
        context,
        light: navigateBackLight,
        dark: navigateBackDark,
      );

  SvgGenImage navigateBackLighter(BuildContext context) => _withBrightness(
        context,
        light: navigateBackLightBlack,
        dark: navigateBackLightGrey,
      );

  SvgGenImage protocol(BuildContext context) => _withBrightness(
        context,
        light: protocolLight,
        dark: protocolDark,
      );

  SvgGenImage refreshIpSetting(BuildContext context) => _withBrightness(
        context,
        light: refreshIpSettingLight,
        dark: refreshIpSettingDark,
      );

  SvgGenImage reportAdaptive(BuildContext context) => _withBrightness(
        context,
        light: reportLight,
        dark: reportDark,
      );

  SvgGenImage resetAppSetting(BuildContext context) => _withBrightness(
        context,
        light: resetAppSettingLight,
        dark: resetAppSettingDark,
      );

  SvgGenImage settingsAdaptive(BuildContext context) => _withBrightness(
        context,
        light: settingsLight,
        dark: settingsDark,
      );

  SvgGenImage settingsDesktop(BuildContext context) => _withBrightness(
        context,
        light: settingsLightDesktop,
        dark: settingsDarkDesktop,
      );

  SvgGenImage support(BuildContext context) => _withBrightness(
        context,
        light: supportLight,
        dark: supportDark,
      );

  SvgGenImage supportDesktop(BuildContext context) => _withBrightness(
        context,
        light: supportLightDesktop,
        dark: supportDarkDesktop,
      );

  SvgGenImage stop(BuildContext context) => _withBrightness(
        context,
        light: stopLight,
        dark: stopDark,
      );

  SvgGenImage theme(BuildContext context) => _withBrightness(
        context,
        light: themeLight,
        dark: themeDark,
      );

  SvgGenImage thumbsUp(BuildContext context) => _withBrightness(
        context,
        light: thumbsUpLight,
        dark: thumbsUpDark,
      );

  SvgGenImage thumbsDown(BuildContext context) => _withBrightness(
        context,
        light: thumbsDownLight,
        dark: thumbsDownDark,
      );

  SvgGenImage bestServer(BuildContext context) => _withBrightness(
        context,
        light: bestServerLight,
        dark: bestServerDark,
      );

  SvgGenImage emailNotification(BuildContext context) => _withBrightness(
        context,
        light: emailNotificationLight,
        dark: emailNotificationDark,
      );

  SvgGenImage notification(BuildContext context) => _withBrightness(
        context,
        light: notificationLight,
        dark: notificationDark,
      );
}

extension $AssetsImagesGenExtensions on $AssetsImagesGen {
  AssetGenImage marketingConsent(BuildContext context) => _withBrightness(
        context,
        light: marketingConsentLight,
        dark: marketingConsentDark,
      );
}

extension $AssetsLogoGenExtensions on $AssetsLogoGen {
  SvgGenImage logo(BuildContext context) => _withBrightness(
        context,
        light: logoBlack,
        dark: logoWhite,
      );
}

extension $ResourcesLangsGenExtensions on $ResourcesLangsGen {
  String get path => 'resources/langs';
}

T _withBrightness<T>(BuildContext context, {required T light, required T dark}) =>
    switch (Theme.of(context).brightness) {
      Brightness.dark => dark,
      Brightness.light => light,
    };
