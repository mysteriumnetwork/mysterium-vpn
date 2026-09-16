import 'package:configcat_client/configcat_client.dart';
import 'package:mysterium_vpn/services/services.dart';

/// ConfigCat Flutter Cache based on shared_preferences.
class ConfigCatPreferencesCache extends ConfigCatCache {
  ConfigCatPreferencesCache(this._prefs);

  final SharedPreferenceService _prefs;

  @override
  Future<String> read(String key) async => _prefs.getString(key) ?? '';

  @override
  Future<void> write(String key, String value) async {
    await _prefs.setString(key, value);
  }
}
