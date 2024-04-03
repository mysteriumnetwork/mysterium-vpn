// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ip_info.freezed.dart';
part 'ip_info.g.dart';

@freezed
class IPInfo with _$IPInfo {
  factory IPInfo({
    required String ip,
    required String country,
    required String city,
  }) = _IPInfo;

  factory IPInfo.fromJson(Map<String, dynamic> json) => _$IPInfoFromJson(json);
}
