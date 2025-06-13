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
[**connectionConfigRegions**](Connection.md#connectionconfigregions) | **GET** /connection/config/regions | Get connection region options
[**connectionLocations**](Connection.md#connectionlocations) | **GET** /connection/locations | Get connection locations
[**disconnect**](Connection.md#disconnect) | **GET** /connection/disconnect | Disconnect from the current Wireguard connection
[**disconnectAll**](Connection.md#disconnectall) | **GET** /connection/disconnect-all | Disconnect all Wireguard connections
[**rateConnection**](Connection.md#rateconnection) | **POST** /connection/rate-connection | Rate connection


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
> ConnectionConfigResponse connectionConfig(ipType)

Get connection options

### Example
```dart
import 'package:vpn_api/api.dart';

final api = VpnApi().getConnection();
final String ipType = ipType_example; // String | 

try {
    final response = api.connectionConfig(ipType);
    print(response);
} catch on DioException (e) {
    print('Exception when calling Connection->connectionConfig: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ipType** | **String**|  | [optional] 

### Return type

[**ConnectionConfigResponse**](ConnectionConfigResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **connectionConfigRegions**
> ConnectionConfigRegionsResponse connectionConfigRegions(ipType)

Get connection region options

### Example
```dart
import 'package:vpn_api/api.dart';

final api = VpnApi().getConnection();
final String ipType = ipType_example; // String | 

try {
    final response = api.connectionConfigRegions(ipType);
    print(response);
} catch on DioException (e) {
    print('Exception when calling Connection->connectionConfigRegions: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ipType** | **String**|  | [optional] 

### Return type

[**ConnectionConfigRegionsResponse**](ConnectionConfigRegionsResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **connectionLocations**
> List<ConnectionLocation> connectionLocations(ipType)

Get connection locations

### Example
```dart
import 'package:vpn_api/api.dart';

final api = VpnApi().getConnection();
final String ipType = ipType_example; // String | 

try {
    final response = api.connectionLocations(ipType);
    print(response);
} catch on DioException (e) {
    print('Exception when calling Connection->connectionLocations: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **ipType** | **String**|  | [optional] 

### Return type

[**List&lt;ConnectionLocation&gt;**](ConnectionLocation.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **disconnect**
> disconnect(publicKey)

Disconnect from the current Wireguard connection

### Example
```dart
import 'package:vpn_api/api.dart';

final api = VpnApi().getConnection();
final String publicKey = aJxmamM5IUbxkevqSGcOIASETCxeRl71iXPVbqT1gz0=; // String | 

try {
    api.disconnect(publicKey);
} catch on DioException (e) {
    print('Exception when calling Connection->disconnect: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **publicKey** | **String**|  | 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **disconnectAll**
> disconnectAll()

Disconnect all Wireguard connections

### Example
```dart
import 'package:vpn_api/api.dart';

final api = VpnApi().getConnection();

try {
    api.disconnectAll();
} catch on DioException (e) {
    print('Exception when calling Connection->disconnectAll: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **rateConnection**
> rateConnection(rateConnectionRequest)

Rate connection

### Example
```dart
import 'package:vpn_api/api.dart';

final api = VpnApi().getConnection();
final RateConnectionRequest rateConnectionRequest = ; // RateConnectionRequest | 

try {
    api.rateConnection(rateConnectionRequest);
} catch on DioException (e) {
    print('Exception when calling Connection->rateConnection: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **rateConnectionRequest** | [**RateConnectionRequest**](RateConnectionRequest.md)|  | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

