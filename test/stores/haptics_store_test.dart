import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/repositories/repositories.dart';
import 'package:mysterium_vpn/stores/stores.dart';
import 'package:mysterium_vpn_design/mysterium_vpn_design.dart';

class _FakeSettings extends Fake implements AppSettingsRepository {
  _FakeSettings({bool? enabled}) : _enabled = enabled;

  bool? _enabled;

  @override
  bool? hapticsEnabled() => _enabled;

  @override
  Future<void> setHapticsEnabled({required bool value}) async => _enabled = value;
}

void main() {
  group('HapticsStore', () {
    tearDown(() => HapticLevel.enabled = true);

    test('defaults to on when nothing is stored', () {
      final store = HapticsStore(settings: _FakeSettings());

      expect(store.enabled, isTrue);
      expect(HapticLevel.enabled, isTrue);
    });

    test('restores a stored off preference into the design system', () {
      final store = HapticsStore(settings: _FakeSettings(enabled: false));

      expect(store.enabled, isFalse);
      expect(HapticLevel.enabled, isFalse);
    });

    test('toggling persists and mirrors into the design system', () async {
      final settings = _FakeSettings();
      final store = HapticsStore(settings: settings);

      await store.setEnabled(value: false);

      expect(store.enabled, isFalse);
      expect(HapticLevel.enabled, isFalse);
      expect(settings.hapticsEnabled(), isFalse);

      await store.setEnabled(value: true);

      expect(HapticLevel.enabled, isTrue);
      expect(settings.hapticsEnabled(), isTrue);
    });
  });
}
