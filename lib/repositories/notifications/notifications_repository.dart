import 'package:mysterium_vpn/models/models.dart';

abstract class NotificationsRepository {
  Future<void> init();
  Future<bool> requestPermission();
  bool getPermissionStatus();
  Future<bool> openAppNotificationsSettings();
  Future<void> login({required String userId, required String userEmail});
  Future<void> logout();
  Future<void> setTags(Map<String, String> tags);
  Stream<PushNotificationsUser> getUser();
}
