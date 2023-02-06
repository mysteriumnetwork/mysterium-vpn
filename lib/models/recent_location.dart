import 'package:freezed_annotation/freezed_annotation.dart';

part 'recent_location.freezed.dart';
part 'recent_location.g.dart';

@freezed
class RecentLocation with _$RecentLocation {
  const factory RecentLocation({
    required String name,
    required Duration duration,
  }) = _RecentLocation;

  factory RecentLocation.fromJson(Map<String, Object?> json) => _$RecentLocationFromJson(json);
}
