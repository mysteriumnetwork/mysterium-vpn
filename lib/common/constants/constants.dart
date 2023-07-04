import 'package:flutter/material.dart';

final List<Locale> kSupportedLocales = [
  kFallbackLocale,
  const Locale('fr', 'FR'),
  const Locale('pt', 'PT'),
  const Locale('tr', 'TR'),
  // const Locale('es', 'ES'),
  // const Locale('de', 'DE'),
  // const Locale('et', 'EE'),
  // const Locale('it', 'IT'),
  // const Locale('lt', 'LT'),
  // const Locale('mk', 'MK'),
  // const Locale('sr', 'RS'),
  // const Locale('uk', 'UA'),
];

const kFallbackLocale = Locale('en', 'US');

const String ksemiAnnualPlan = 'plan_6_months';
const String kMonthlyPlan = 'plan_monthly';
const String kAnnualPlan = 'plan_yearly';

const String kPopularPlan = ksemiAnnualPlan;
List<String> kProductIds = <String>[
  kMonthlyPlan,
  ksemiAnnualPlan,
  kAnnualPlan,
];

//scaffold messenger key used globally
final GlobalKey<ScaffoldMessengerState> snackbarKey = GlobalKey<ScaffoldMessengerState>();

const privacyPolicyUrl = 'https://www.mysteriumvpn.com/privacy-policy-vpn';
const termsOfServiceUrl = 'https://www.mysteriumvpn.com/terms-conditions-vpn';

const String androidBundleId = 'mysteriumvpn';
const String iosBundleId = 'com.mysteriumvpn.tun';
const String iosTestBundleId = 'com.mysteriumvpn.test.tun';
