import 'dart:async';

import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/repositories/repositories.dart';

/// No-op on desktop: firebase_messaging has no Windows support and macOS/Linux
/// push is out of scope.
class DesktopNotificationsRepository implements NotificationsRepository {
  @override
  Future<void> init() async {
    // no-op
  }

  @override
  Future<bool> requestPermission() async => false;

  @override
  bool getPermissionStatus() => false;

  @override
  Future<bool> refreshPermissionStatus() async => false;

  @override
  Future<bool> canRequestPermission() async => false;

  @override
  Stream<bool> getPermissionStatusStream() => const Stream<bool>.empty();

  @override
  Future<void> openAppNotificationsSettings() async {
    // no-op
  }

  @override
  String? get currentToken => null;

  @override
  Stream<String> get tokenStream => const Stream<String>.empty();

  @override
  Future<void> clearToken() async {
    // no-op
  }

  @override
  Stream<PushNotification> getNotificationsStream() => const Stream<PushNotification>.empty();

  @override
  Stream<PushNotification> getReceivedStream() => const Stream<PushNotification>.empty();

  @override
  Future<void> reportEvent(PushNotification notification, NotifierEventType type) async {
    // no-op
  }

  @override
  Future<void> dispose() async {
    // no-op
  }
}
