// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'push_notifications_user.freezed.dart';
part 'push_notifications_user.g.dart';

@freezed
abstract class PushNotificationsUser with _$PushNotificationsUser {
  factory PushNotificationsUser({
    required String? pushNotificationsId,
    required String? userId,
    required Map<String, String>? tags,
  }) = _PushNotificationsUser;
  factory PushNotificationsUser.fromJson(Map<String, dynamic> json) =>
      _$PushNotificationsUserFromJson(json);
}
