import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:mysterium_vpn/app.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/services/shared_preferences_service.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferenceService.init();
  await EasyLocalization.ensureInitialized();

  runApp(
    ProviderScope(
      child: EasyLocalization(
        supportedLocales: supportedLocales,
        path: 'resources/langs',
        fallbackLocale: fallbackLocale,
        child: const MyApp(),
      ),
    ),
  );
}
