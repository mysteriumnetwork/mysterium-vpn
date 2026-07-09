import 'package:mysterium_vpn/generated/l10n.dart';

/// Country vs city exhausted-message key based on the user's location intent.
String ipRefreshExhaustedMessageKey({required bool isCountry}) =>
    isCountry ? 'ipRefreshExhaustedCountry' : 'ipRefreshExhaustedCity';

/// Localized exhausted-IP message for [locationName].
String ipRefreshExhaustedMessage({required bool isCountry, required String locationName}) =>
    isCountry
    ? S.current.ipRefreshExhaustedCountry(locationName)
    : S.current.ipRefreshExhaustedCity(locationName);
