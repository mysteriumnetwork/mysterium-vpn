// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'magic_link_redirect_request_query.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MagicLinkRedirectRequestQuery _$MagicLinkRedirectRequestQueryFromJson(Map<String, dynamic> json) =>
    $checkedCreate(
      'MagicLinkRedirectRequestQuery',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['code'],
        );
        final val = MagicLinkRedirectRequestQuery(
          code: $checkedConvert('code', (v) => v as String),
          continueTo: $checkedConvert('continue_to', (v) => v as String?),
          redirectUrl: $checkedConvert('redirect_url', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {'continueTo': 'continue_to', 'redirectUrl': 'redirect_url'},
    );

Map<String, dynamic> _$MagicLinkRedirectRequestQueryToJson(MagicLinkRedirectRequestQuery instance) {
  final val = <String, dynamic>{
    'code': instance.code,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('continue_to', instance.continueTo);
  writeNotNull('redirect_url', instance.redirectUrl);
  return val;
}
