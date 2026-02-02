// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'push_notification.freezed.dart';
part 'push_notification.g.dart';

@freezed
abstract class PushNotification with _$PushNotification {
  factory PushNotification({
    required String? id,
    required String? title,
    required String? body,
    required String? launchUrl,
    required Map<String, dynamic>? additionalData,
    required Map<String, dynamic>? rawPayload,
    required String? category,
  }) = _PushNotification;
  factory PushNotification.fromJson(Map<String, dynamic> json) => _$PushNotificationFromJson(json);
}
