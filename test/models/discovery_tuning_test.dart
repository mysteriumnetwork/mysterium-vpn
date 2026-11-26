import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/models/models.dart';

void main() {
  test('reads every field from a complete payload', () {
    final tuning = DiscoveryTuning.fromJson({
      'enabled': false,
      'checkIntervalMinutes': 5,
      'cooldownMinutes': 10,
      'refreshIntervalMinutes': 15,
    });

    expect(tuning.enabled, isFalse);
    expect(tuning.checkInterval, const Duration(minutes: 5));
    expect(tuning.cooldown, const Duration(minutes: 10));
    expect(tuning.refreshInterval, const Duration(minutes: 15));
  });

  test('falls back to the shipped defaults when fields are missing', () {
    final tuning = DiscoveryTuning.fromJson(const {});

    expect(tuning.enabled, isTrue);
    expect(tuning.checkInterval, const Duration(minutes: 30));
    expect(tuning.cooldown, const Duration(minutes: 30));
    expect(tuning.refreshInterval, const Duration(hours: 1));
  });

  test('rejects wrong types and out-of-range values field by field', () {
    final tuning = DiscoveryTuning.fromJson(const {
      'enabled': 'yes',
      'checkIntervalMinutes': '5',
      'cooldownMinutes': -1,
      'refreshIntervalMinutes': 2000,
    });

    expect(tuning.enabled, isTrue);
    expect(tuning.checkInterval, const Duration(minutes: 30));
    expect(tuning.cooldown, const Duration(minutes: 30));
    expect(tuning.refreshInterval, const Duration(hours: 1));
  });

  test('accepts a zero check interval, which disables the warm-up only', () {
    final tuning = DiscoveryTuning.fromJson(const {
      'checkIntervalMinutes': 0,
      'cooldownMinutes': 0,
    });

    expect(tuning.checkInterval, Duration.zero);
    // A cooldown of zero would deprioritise nothing, so it is not a valid value.
    expect(tuning.cooldown, const Duration(minutes: 30));
  });
}
