// Package imports:
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'report_broken_node_request.freezed.dart';
part 'report_broken_node_request.g.dart';

@freezed
class ReportBrokenNodeRequest with _$ReportBrokenNodeRequest {
  factory ReportBrokenNodeRequest({
    @JsonKey(name: 'public_key') required String publicKey,
    @JsonKey(name: 'destination_country') required String destinationCountry,
    @JsonKey(name: 'os_type') required String osType,
    @JsonKey(name: 'app_version') required String appVersion,
    @JsonKey(name: 'hash') required String hashValue,
    @JsonKey(name: 'origin_country') String? originCountry,
    @JsonKey(name: 'internet_type') ConnectivityResult? connectivityType,
  }) = _ReportBrokenNodeRequest;

  factory ReportBrokenNodeRequest.fromJson(Map<String, dynamic> json) =>
      _$ReportBrokenNodeRequestFromJson(json);
}
