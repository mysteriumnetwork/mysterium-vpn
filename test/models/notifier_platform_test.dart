import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/models/models.dart';

void main() {
  group('registration', () {
    test('a macOS registration round-trips as macos locally', () {
      const value = NotifierRegistration(
        externalUserId: 'u',
        token: 't',
        platform: NotifierPlatform.macos,
        contractVersion: kNotifierContractVersion,
      );

      expect(NotifierRegistration.fromJson(value.toJson()).platform, NotifierPlatform.macos);
    });

    test('a Mac and an iPhone with the same token are different identities', () {
      const mac = NotifierRegistration(
        externalUserId: 'u',
        token: 't',
        platform: NotifierPlatform.macos,
        contractVersion: kNotifierContractVersion,
      );
      const phone = NotifierRegistration(
        externalUserId: 'u',
        token: 't',
        platform: NotifierPlatform.ios,
        contractVersion: kNotifierContractVersion,
      );

      expect(mac.matches(phone), isFalse);
    });
  });
}
