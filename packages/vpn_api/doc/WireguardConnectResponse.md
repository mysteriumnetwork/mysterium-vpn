# vpn_api.model.WireguardConnectResponse

## Load the model package
```dart
import 'package:vpn_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**id** | **String** | Unique identifier of prepared connection | 
**wgConfig** | **String** | Wireguard connection configuration with a placeholder for %private_key% | 
**hash** | **String** | Hash representing provider id | 
**exitIp** | **String** | Exit IP of provider | [optional] 
**limitExceeded** | **bool** |  | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


