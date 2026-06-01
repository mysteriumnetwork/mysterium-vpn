// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'campaign_view.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MessageData _$MessageDataFromJson(Map<String, dynamic> json) => _MessageData(
  type: $enumDecode(_$_MessageTypeEnumMap, json['type']),
  requestId: json['requestId'] as String?,
  payload: json['payload'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$MessageDataToJson(_MessageData instance) => <String, dynamic>{
  'type': _$_MessageTypeEnumMap[instance.type]!,
  'requestId': instance.requestId,
  'payload': instance.payload,
};

const _$_MessageTypeEnumMap = {
  _MessageType.orderSummary: 'order_summary',
  _MessageType.subscribe: 'subscribe',
  _MessageType.subscriptionUpgrade: 'subscription_upgrade',
  _MessageType.unknown: 'unknown',
};

_OrderSummaryRequestData _$OrderSummaryRequestDataFromJson(Map<String, dynamic> json) =>
    _OrderSummaryRequestData(
      planId: json['planId'] as String,
      country: json['country'] as String,
      state: json['state'] as String?,
      couponCode: json['couponCode'] as String?,
    );

Map<String, dynamic> _$OrderSummaryRequestDataToJson(_OrderSummaryRequestData instance) =>
    <String, dynamic>{
      'planId': instance.planId,
      'country': instance.country,
      'state': instance.state,
      'couponCode': instance.couponCode,
    };

_OrderSummaryResponseData _$OrderSummaryResponseDataFromJson(Map<String, dynamic> json) =>
    _OrderSummaryResponseData(
      orderTotal: json['orderTotal'] as String,
      couponError: json['couponError'] as String?,
    );

Map<String, dynamic> _$OrderSummaryResponseDataToJson(_OrderSummaryResponseData instance) =>
    <String, dynamic>{'orderTotal': instance.orderTotal, 'couponError': instance.couponError};

_SubscribePayloadData _$SubscribePayloadDataFromJson(Map<String, dynamic> json) =>
    _SubscribePayloadData(
      planId: json['planId'] as String,
      couponCode: json['couponCode'] as String?,
    );

Map<String, dynamic> _$SubscribePayloadDataToJson(_SubscribePayloadData instance) =>
    <String, dynamic>{'planId': instance.planId, 'couponCode': instance.couponCode};
