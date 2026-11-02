import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/utils/utils.dart';
import 'package:mysterium_vpn/repositories/repositories.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

part 'haptics_store.g.dart';

// ignore: library_private_types_in_public_api
class HapticsStore = _HapticsStore with _$HapticsStore;

/// Owns the user's haptics preference and mirrors it into the design system.
///
/// Apple's HIG asks that haptics be optional in-app, not only at the OS level.
abstract class _HapticsStore with Store {
  _HapticsStore({required AppSettingsRepository settings}) : _settings = settings {
    enabled = _settings.hapticsEnabled() ?? true;
    HapticLevel.enabled = enabled;
  }

  final AppSettingsRepository _settings;

  /// Desktop has no haptics to switch off, so the setting stays hidden there.
  bool get isSupported => isMobile();

  @observable
  bool enabled = true;

  @action
  Future<void> setEnabled({required bool value}) async {
    enabled = value;
    HapticLevel.enabled = value;
    await _settings.setHapticsEnabled(value: value);
  }
}
