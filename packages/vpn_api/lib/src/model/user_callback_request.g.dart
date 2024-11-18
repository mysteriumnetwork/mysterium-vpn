// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_callback_request.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserCallbackRequest _$UserCallbackRequestFromJson(Map<String, dynamic> json) => $checkedCreate(
      'UserCallbackRequest',
      json,
      ($checkedConvert) {
        $checkKeys(
          json,
          requiredKeys: const ['gateway_id'],
        );
        final val = UserCallbackRequest(
          gatewayId: $checkedConvert(
              'gateway_id', (v) => $enumDecode(_$UserCallbackRequestGatewayIdEnumEnumMap, v)),
          payload: $checkedConvert('payload', (v) => v as String?),
          transactionId: $checkedConvert('transaction_id', (v) => v as String?),
        );
        return val;
      },
      fieldKeyMap: const {'gatewayId': 'gateway_id', 'transactionId': 'transaction_id'},
    );

Map<String, dynamic> _$UserCallbackRequestToJson(UserCallbackRequest instance) {
  final val = <String, dynamic>{
    'gateway_id': _$UserCallbackRequestGatewayIdEnumEnumMap[instance.gatewayId]!,
  };

  void writeNotNull(String key, dynamic value) {
    if (value != null) {
      val[key] = value;
    }
  }

  writeNotNull('payload', instance.payload);
  writeNotNull('transaction_id', instance.transactionId);
  return val;
}

const _$UserCallbackRequestGatewayIdEnumEnumMap = {
  UserCallbackRequestGatewayIdEnum.apple: 'apple',
  UserCallbackRequestGatewayIdEnum.google: 'google',
};
