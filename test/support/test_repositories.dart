import 'package:mysterium_vpn/repositories/repositories.dart';
import 'package:mysterium_vpn/services/data/storage.dart';

/// Real [AppSettingsRepository] over an in-memory preferences service, for
/// store tests that assert against the preferences themselves.
AppSettingsRepository appSettings(SharedPreferenceService prefs) =>
    LocalAppSettingsRepository(prefs);
