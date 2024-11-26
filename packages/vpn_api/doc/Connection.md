# vpn_api.api.Connection

## Load the API package
```dart
import 'package:vpn_api/api.dart';
```

All URIs are relative to *http://localhost:3030/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**connect**](Connection.md#connect) | **POST** /connection/connect | Get Wireguard configuration template given connect options
[**connectProxy**](Connection.md#connectproxy) | **POST** /connection/connect-proxy | Get proxy configuration given connect options
[**connectionConfig**](Connection.md#connectionconfig) | **GET** /connection/config | Get connection options


# **connect**
> WireguardConnectResponse connect(wireguardConnectRequest)

Get Wireguard configuration template given connect options

### Example
```dart
import 'package:vpn_api/api.dart';

final api = VpnApi().getConnection();
final WireguardConnectRequest wireguardConnectRequest = ; // WireguardConnectRequest | 

try {
    final response = api.connect(wireguardConnectRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling Connection->connect: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **wireguardConnectRequest** | [**WireguardConnectRequest**](WireguardConnectRequest.md)|  | [optional] 

### Return type

[**WireguardConnectResponse**](WireguardConnectResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **connectProxy**
> ProxyConnectResponse connectProxy(httpsConnectRequest)

Get proxy configuration given connect options

### Example
```dart
import 'package:vpn_api/api.dart';

final api = VpnApi().getConnection();
final HttpsConnectRequest httpsConnectRequest = ; // HttpsConnectRequest | 

try {
    final response = api.connectProxy(httpsConnectRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling Connection->connectProxy: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **httpsConnectRequest** | [**HttpsConnectRequest**](HttpsConnectRequest.md)|  | [optional] 

### Return type

[**ProxyConnectResponse**](ProxyConnectResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **connectionConfig**
> ConnectionConfigResponse connectionConfig()

Get connection options

### Example
```dart
import 'package:vpn_api/api.dart';

final api = VpnApi().getConnection();

try {
    final response = api.connectionConfig();
    print(response);
} catch on DioException (e) {
    print('Exception when calling Connection->connectionConfig: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**ConnectionConfigResponse**](ConnectionConfigResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

