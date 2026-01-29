import 'dart:async';

import 'package:mysterium_vpn/models/push_notifications_user.dart';
import 'package:mysterium_vpn/repositories/repositories.dart';

class DesktopNotificationsRepository implements NotificationsRepository {
  static const bool _hasPermission = false;

  @override
  Future<bool> canRequestPermission() async => false;

  @override
  bool getPermissionStatus() => _hasPermission;

  @override
  Stream<bool> getPermissionStatusStream() => const Stream<bool>.empty();

  @override
  Stream<PushNotificationsUser> getUser() => const Stream<PushNotificationsUser>.empty();

  @override
  Future<void> init() async {
    // no-op
  }

  @override
  Future<void> login({
    required String userId,
    required String userEmail,
  }) async {
    // no-op
  }

  @override
  Future<void> logout() async {
    // no-op
  }

  @override
  Future<void> openAppNotificationsSettings() async {
    // no-op
  }

  @override
  Future<bool> requestPermission() async => false;

  @override
  Future<void> setTags(Map<String, String> tags) async {
    // no-op
  }
}
