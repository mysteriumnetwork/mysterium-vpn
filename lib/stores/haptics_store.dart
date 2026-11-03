import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/repositories/repositories.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

part 'haptics_store.g.dart';

// ignore: library_private_types_in_public_api
class HapticsStore = _HapticsStore with _$HapticsStore;

/// Applies the persisted haptics preference to the design system.
///
/// Called from startup rather than [HapticsStore]'s constructor: the store is
/// created lazily when Settings opens, so a stored "off" would otherwise not
/// take effect until the user revisited that screen.
void restoreHapticsPreference(AppSettingsRepository settings) {
  HapticLevel.enabled = settings.hapticsEnabled() ?? true;
}

/// Owns the user's haptics preference and mirrors it into the design system.
///
/// Apple's HIG asks that haptics be optional in-app, not only at the OS level.
abstract class _HapticsStore with Store {
  _HapticsStore({required AppSettingsRepository settings}) : _settings = settings {
    enabled = _settings.hapticsEnabled() ?? true;
  }

  final AppSettingsRepository _settings;

  @observable
  bool enabled = true;

  @action
  Future<void> setEnabled({required bool value}) async {
    enabled = value;
    HapticLevel.enabled = value;
    await _settings.setHapticsEnabled(value: value);
  }
}
