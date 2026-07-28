import 'package:flutter/widgets.dart';
import 'package:mysterium_vpn/entrypoints/app_initializer.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/services/services.dart';
import 'package:patrol/patrol.dart';

/// Initializes the app environment for an integration test and clears secure
/// storage so each test starts unauthenticated. Call from `patrolSetUp` and
/// pump the returned initializer's `getApp()`.
Future<AppInitializer> bootApp() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Env.init();
  final environment = AppInitializer();
  await environment.init();
  await SecureStorageService.instance.clearAll();
  return environment;
}

/// Pumps the app and settles with a generous timeout — a cold launch on a CI
/// device can exceed patrol's 10s default while startup work completes.
Future<void> pumpApp(PatrolIntegrationTester $, AppInitializer environment) =>
    $.pumpWidgetAndSettle(environment.getApp(), timeout: const Duration(minutes: 2));
