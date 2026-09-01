import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/repositories/notifications/desktop_notifications_repository.dart';

void main() {
  late DesktopNotificationsRepository repo;

  setUp(() {
    repo = DesktopNotificationsRepository();
  });

  test('init / clearToken / openAppNotificationsSettings are no-ops', () async {
    await repo.init();
    await repo.clearToken();
    await repo.openAppNotificationsSettings();
    await repo.dispose();
    // None of the above should throw.
  });

  test('permission queries return false', () async {
    expect(repo.getPermissionStatus(), isFalse);
    expect(await repo.refreshPermissionStatus(), isFalse);
    expect(await repo.requestPermission(), isFalse);
    expect(await repo.canRequestPermission(), isFalse);
  });

  test('there is no device token', () {
    expect(repo.currentToken, isNull);
  });

  test('streams emit nothing and complete', () async {
    expect(await repo.tokenStream.toList(), isEmpty);
    expect(await repo.getPermissionStatusStream().toList(), isEmpty);
    expect(await repo.getNotificationsStream().toList(), isEmpty);
    expect(await repo.getReceivedStream().toList(), isEmpty);
  });
}
