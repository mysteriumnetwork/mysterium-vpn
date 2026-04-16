import 'package:mysterium_vpn/generated/locale_keys.g.dart';

/// The three content-blocking modes available in the app.
enum BlockerType {
  none(LocaleKeys.noneLbl),
  malware(LocaleKeys.malwareLbl),
  nsfwAndMalware(LocaleKeys.nsfwLbl);

  const BlockerType(this.localeKey);

  final String localeKey;
}
