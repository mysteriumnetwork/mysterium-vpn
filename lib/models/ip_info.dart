// Package imports:
import 'package:freezed_annotation/freezed_annotation.dart';

part 'ip_info.freezed.dart';

part 'ip_info.g.dart';

@freezed
abstract class IPInfo with _$IPInfo {
  const factory IPInfo({required String ip, required String country, required String city}) =
      _IPInfo;

  const IPInfo._();

  factory IPInfo.fromJson(Map<String, dynamic> json) => _$IPInfoFromJson(json);
}
