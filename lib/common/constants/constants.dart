import 'package:flutter/material.dart';
import 'package:mysterium_vpn/common/styles/assets.dart';

const List<String> availableFlags = [
  Assets.france,
  Assets.germany,
  Assets.poland,
  Assets.ukraine,
  Assets.austria,
  Assets.italy,
];

final List<Locale> supportedLocales = [
  fallbackLocale,
  const Locale('es'),
];

const fallbackLocale = Locale('en');
