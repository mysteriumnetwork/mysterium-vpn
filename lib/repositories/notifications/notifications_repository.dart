abstract class NotificationsRepository {
  Future<void> init();
  Future<void> setUserId(String userId);
  Future<bool> requestPermission();
  bool getPermissionStatus();
  Future<bool> openAppNotificationsSettings();
}
