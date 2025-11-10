import 'package:configcat_client/configcat_client.dart';
import 'package:mysterium_vpn/services/services.dart';

/// ConfigCat Flutter Cache based on shared_preferences.
class ConfigCatPreferencesCache extends ConfigCatCache {
  @override
  Future<String> read(String key) async => SharedPreferenceService.instance.getString(key) ?? '';

  @override
  Future<void> write(String key, String value) async {
    await SharedPreferenceService.instance.setString(key, value);
  }
}
