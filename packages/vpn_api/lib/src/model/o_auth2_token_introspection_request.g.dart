// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'o_auth2_token_introspection_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OAuth2TokenIntrospectionRequest _$OAuth2TokenIntrospectionRequestFromJson(
        Map<String, dynamic> json) =>
    $checkedCreate(
      'OAuth2TokenIntrospectionRequest',
      json,
      ($checkedConvert) {
        final val = OAuth2TokenIntrospectionRequest(
          token: $checkedConvert('token', (v) => v as String?),
        );
        return val;
      },
    );

Map<String, dynamic> _$OAuth2TokenIntrospectionRequestToJson(
    OAuth2TokenIntrospectionRequest instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('token', instance.token);
  return val;
}
