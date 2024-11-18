// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'magic_link_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MagicLinkResponse _$MagicLinkResponseFromJson(Map<String, dynamic> json) => $checkedCreate(
      'MagicLinkResponse',
      json,
      ($checkedConvert) {
        final val = MagicLinkResponse(
          code: $checkedConvert('code', (v) => v as String?),
        );
        return val;
      },
    );

Map<String, dynamic> _$MagicLinkResponseToJson(MagicLinkResponse instance) {
  final val = <String, dynamic>{};

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('code', instance.code);
  return val;
}
