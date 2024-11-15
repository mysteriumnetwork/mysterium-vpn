// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'request_activation_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

RequestActivationRequest _$RequestActivationRequestFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'RequestActivationRequest',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['id'],
        );
        final val = RequestActivationRequest(
          id: $checkedConvert('id', (v) => v as String),
        );
        return val;
      },
    );

Map<String, dynamic> _$RequestActivationRequestToJson(RequestActivationRequest instance) =>
    <String, dynamic>{
      'id': instance.id,
    };
