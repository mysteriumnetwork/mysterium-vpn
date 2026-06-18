import 'package:easy_localization/easy_localization.dart';
import 'package:mysterium_vpn/generated/locale_keys.g.dart';

/// Country vs city exhausted-message key based on the user's location intent.
String ipRefreshExhaustedMessageKey({required bool isCountry}) =>
    isCountry ? LocaleKeys.ipRefreshExhaustedCountry : LocaleKeys.ipRefreshExhaustedCity;

/// Localized exhausted-IP message for [locationName].
String ipRefreshExhaustedMessage({required bool isCountry, required String locationName}) =>
    ipRefreshExhaustedMessageKey(isCountry: isCountry).tr(args: [locationName]);
