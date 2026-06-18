import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/models/models.dart';

void main() {
  group('ReviewPromptConfig.fromJson', () {
    test('uses defaults for an empty payload', () {
      const defaults = ReviewPromptConfig();
      final config = ReviewPromptConfig.fromJson(const {});
      expect(config.enabled, defaults.enabled);
      expect(config.minAccountAgeMinutes, defaults.minAccountAgeMinutes);
      expect(config.minAppOpens, defaults.minAppOpens);
      expect(config.minConnections, defaults.minConnections);
      expect(config.cleanSessionsRequired, defaults.cleanSessionsRequired);
      expect(config.stableSessionSeconds, defaults.stableSessionSeconds);
      expect(config.cooldownDismissMinutes, defaults.cooldownDismissMinutes);
      expect(config.cooldownNegativeMinutes, defaults.cooldownNegativeMinutes);
      expect(config.cooldownPositiveMinutes, defaults.cooldownPositiveMinutes);
      expect(config.yearlyCap, defaults.yearlyCap);
    });

    test('reads provided values', () {
      final config = ReviewPromptConfig.fromJson(const {
        'enabled': false,
        'minAccountAgeMinutes': 14,
        'minAppOpens': 8,
        'minConnections': 20,
        'cleanSessionsRequired': 2,
        'stableSessionSeconds': 120,
        'cooldownDismissMinutes': 45,
        'cooldownNegativeMinutes': 90,
        'cooldownPositiveMinutes': 120,
        'yearlyCap': 5,
      });
      expect(config.enabled, isFalse);
      expect(config.minAccountAgeMinutes, 14);
      expect(config.minAppOpens, 8);
      expect(config.minConnections, 20);
      expect(config.cleanSessionsRequired, 2);
      expect(config.stableSessionSeconds, 120);
      expect(config.cooldownDismissMinutes, 45);
      expect(config.cooldownNegativeMinutes, 90);
      expect(config.cooldownPositiveMinutes, 120);
      expect(config.yearlyCap, 5);
    });

    test('accepts zero but rejects negative and wrong types per field', () {
      final config = ReviewPromptConfig.fromJson(const {
        'minAccountAgeMinutes': 0, // valid
        'minAppOpens': -1, // negative → default
        'minConnections': 'nope', // wrong type → default
        'enabled': 'yes', // wrong type → default
      });
      expect(config.minAccountAgeMinutes, 0);
      expect(config.minAppOpens, 5);
      expect(config.minConnections, 10);
      expect(config.enabled, isTrue);
    });
  });
}
