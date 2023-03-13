import 'package:flutter/material.dart';

final List<Locale> kSupportedLocales = [
  kFallbackLocale,
  const Locale('es'),
];

const kFallbackLocale = Locale('en');

const String ksemiAnnualPlan = 'semi_annual_plan';
const String kMonthlyPlan = 'monthly_plan';
const String kAnnualPlan = 'annual_plan';
const String kPopularPlan = ksemiAnnualPlan;
List<String> kProductIds = <String>[
  kMonthlyPlan,
  ksemiAnnualPlan,
  kAnnualPlan,
];

const baseUrl = 'https://thanaa.kfshrc.edu.sa/api';
