import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/models/models.dart';

void main() {
  group('ReviewPromptConfig.fromJson', () {
    test('uses defaults for an empty payload', () {
      const defaults = ReviewPromptConfig();
      final config = ReviewPromptConfig.fromJson(const {});
      expect(config.enabled, defaults.enabled);
      expect(config.minAccountAgeDays, defaults.minAccountAgeDays);
      expect(config.minAppOpens, defaults.minAppOpens);
      expect(config.minConnections, defaults.minConnections);
      expect(config.cleanSessionsRequired, defaults.cleanSessionsRequired);
      expect(config.stableSessionSeconds, defaults.stableSessionSeconds);
      expect(config.cooldownDismissDays, defaults.cooldownDismissDays);
      expect(config.cooldownNegativeDays, defaults.cooldownNegativeDays);
      expect(config.cooldownPositiveDays, defaults.cooldownPositiveDays);
      expect(config.yearlyCap, defaults.yearlyCap);
    });

    test('reads provided values', () {
      final config = ReviewPromptConfig.fromJson(const {
        'enabled': false,
        'minAccountAgeDays': 14,
        'minAppOpens': 8,
        'minConnections': 20,
        'cleanSessionsRequired': 2,
        'stableSessionSeconds': 120,
        'cooldownDismissDays': 45,
        'cooldownNegativeDays': 90,
        'cooldownPositiveDays': 120,
        'yearlyCap': 5,
      });
      expect(config.enabled, isFalse);
      expect(config.minAccountAgeDays, 14);
      expect(config.minAppOpens, 8);
      expect(config.minConnections, 20);
      expect(config.cleanSessionsRequired, 2);
      expect(config.stableSessionSeconds, 120);
      expect(config.cooldownDismissDays, 45);
      expect(config.cooldownNegativeDays, 90);
      expect(config.cooldownPositiveDays, 120);
      expect(config.yearlyCap, 5);
    });

    test('accepts zero but rejects negative and wrong types per field', () {
      final config = ReviewPromptConfig.fromJson(const {
        'minAccountAgeDays': 0, // valid
        'minAppOpens': -1, // negative → default
        'minConnections': 'nope', // wrong type → default
        'enabled': 'yes', // wrong type → default
      });
      expect(config.minAccountAgeDays, 0);
      expect(config.minAppOpens, 5);
      expect(config.minConnections, 10);
      expect(config.enabled, isTrue);
    });
  });
}
