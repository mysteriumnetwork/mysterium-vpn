import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mysterium_vpn/repositories/notifications/onesignal_notifications_repository.dart';
import 'package:talker/talker.dart';

import 'onesignal_notifications_repository_test.mocks.dart';

// Most OneSignal methods invoke the static `OneSignal.X` platform interface
// which isn't available in pure unit tests — covering them would require a
// real device. These tests cover only what is safe without the platform.
@GenerateNiceMocks([MockSpec<Talker>()])
void main() {
  late MockTalker logger;
  late OnesignalNotificationsRepository repo;

  setUp(() {
    logger = MockTalker();
    repo = OnesignalNotificationsRepository(logger: logger);
  });

  test('dispose is safe on a fresh instance with no streams attached', () async {
    await repo.dispose();
  });

  test('dispose is idempotent', () async {
    await repo.dispose();
    await repo.dispose();
  });
}
