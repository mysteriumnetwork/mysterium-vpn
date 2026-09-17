import 'package:mysterium_vpn/services/data/storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Creates a [SharedPreferenceService] backed by in-memory preferences.
Future<SharedPreferenceService> initTestPrefs([Map<String, Object> initial = const {}]) async {
  SharedPreferences.setMockInitialValues(initial);
  final service = SharedPreferenceService();
  await service.init();
  return service;
}
