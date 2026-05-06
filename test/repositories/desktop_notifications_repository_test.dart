import 'package:flutter_test/flutter_test.dart';
import 'package:mysterium_vpn/repositories/notifications/desktop_notifications_repository.dart';

void main() {
  late DesktopNotificationsRepository repo;

  setUp(() {
    repo = DesktopNotificationsRepository();
  });

  test('init / login / logout / setTags / openAppNotificationsSettings are no-ops', () async {
    await repo.init();
    await repo.login(userId: 'u1', userEmail: 'u@e.com');
    await repo.logout();
    await repo.setTags({'key': 'value'});
    await repo.openAppNotificationsSettings();
    await repo.dispose();
    // None of the above should throw.
  });

  test('permission queries return false', () async {
    expect(repo.getPermissionStatus(), isFalse);
    expect(await repo.requestPermission(), isFalse);
    expect(await repo.canRequestPermission(), isFalse);
  });

  test('streams emit nothing and complete', () async {
    expect(await repo.getUser().toList(), isEmpty);
    expect(await repo.getPermissionStatusStream().toList(), isEmpty);
    expect(await repo.getNotificationsStream().toList(), isEmpty);
  });
}
