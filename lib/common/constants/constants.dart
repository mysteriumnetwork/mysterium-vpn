import 'package:flutter/material.dart';

final List<Locale> kSupportedLocales = [
  kFallbackLocale,
  const Locale('es'),
];

const kFallbackLocale = Locale('en');

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

const privacyPolicyUrl = 'https://www.mysteriumvpn.com/privacy-policy';
const termsOfServiceUrl = 'https://www.mysteriumvpn.com/terms-conditions';
