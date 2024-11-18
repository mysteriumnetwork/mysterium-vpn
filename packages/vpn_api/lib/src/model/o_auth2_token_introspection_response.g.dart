// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'o_auth2_token_introspection_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OAuth2TokenIntrospectionResponse _$OAuth2TokenIntrospectionResponseFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'OAuth2TokenIntrospectionResponse',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['active'],
        );
        final val = OAuth2TokenIntrospectionResponse(
          active: $checkedConvert('active', (v) => v as bool),
          username: $checkedConvert('username', (v) => v as String?),
          sub: $checkedConvert('sub', (v) => v as String?),
          exp: $checkedConvert('exp', (v) => v as num?),
        );
        return val;
      },
    );

Map<String, dynamic> _$OAuth2TokenIntrospectionResponseToJson(
    OAuth2TokenIntrospectionResponse instance) {
  final val = <String, dynamic>{
    'active': instance.active,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('username', instance.username);
  writeNotNull('sub', instance.sub);
  writeNotNull('exp', instance.exp);
  return val;
}
