// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marketing_permissions_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MarketingPermissionsRequest _$MarketingPermissionsRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'MarketingPermissionsRequest',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['consent'],
        );
        final val = MarketingPermissionsRequest(
          consent: $checkedConvert('consent', (v) => v as bool),
        );
        return val;
      },
    );

Map<String, dynamic> _$MarketingPermissionsRequestToJson(MarketingPermissionsRequest instance) =>
    <String, dynamic>{
      'consent': instance.consent,
    };
