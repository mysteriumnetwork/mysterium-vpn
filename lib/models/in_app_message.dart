import 'package:freezed_annotation/freezed_annotation.dart';

part 'in_app_message.freezed.dart';

part 'in_app_message.g.dart';

enum InAppMessageType {
  popup,
  banner;
}

@Freezed(unionKey: 'type')
sealed class InAppMessage with _$InAppMessage {
  const InAppMessage._();

  const factory InAppMessage.popup({
    required String id,
    required String title,
    required String? message,
    required String? imageUrl,
    required List<InAppMessageAction> actions,
  }) = InAppPopup;

  const factory InAppMessage.banner({
    required String id,
    required String title,
    required String? iconUrl,
    required InAppMessageAction? action,
  }) = InAppBanner;

  factory InAppMessage.fromJson(Map<String, dynamic> json) => _$InAppMessageFromJson(json);
}

@Freezed(unionKey: 'type')
sealed class InAppMessageTrigger with _$InAppMessageTrigger {
  const InAppMessageTrigger._();

  const factory InAppMessageTrigger.appLaunch({required Duration repeatInterval}) = AppLaunch;

  factory InAppMessageTrigger.fromJson(Map<String, dynamic> json) =>
      _$InAppMessageTriggerFromJson(json);
}

@Freezed(unionKey: 'type')
sealed class InAppMessageAction with _$InAppMessageAction {
  const factory InAppMessageAction.primary({
    required String label,
    required String url,
  }) = InAppActionPrimary;

  const factory InAppMessageAction.secondary({
    required String label,
    required String url,
  }) = InAppActionSecondary;

  const InAppMessageAction._();

  factory InAppMessageAction.fromJson(Map<String, dynamic> json) =>
      _$InAppMessageActionFromJson(json);
}
