// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'vpn_connection.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_VpnConnection _$$_VpnConnectionFromJson(Map<String, dynamic> json) => _$_VpnConnection(
      connectionIP: json['connectionIP'] as String,
      connectionStatus: $enumDecode(_$ConnectionStatusEnumMap, json['connectionStatus']),
      location: json['location'] as String,
    );

Map<String, dynamic> _$$_VpnConnectionToJson(_$_VpnConnection instance) => <String, dynamic>{
      'connectionIP': instance.connectionIP,
      'connectionStatus': _$ConnectionStatusEnumMap[instance.connectionStatus]!,
      'location': instance.location,
    };

const _$ConnectionStatusEnumMap = {
  ConnectionStatus.connected: 'connected',
  ConnectionStatus.disconnected: 'disconnected',
};
