# vpn_api.api.Infrastructure

## Load the API package
```dart
import 'package:vpn_api/api.dart';
```

All URIs are relative to *http://localhost:3030/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**healthcheck**](Infrastructure.md#healthcheck) | **GET** /healthcheck | Check whether the API is up


# **healthcheck**
> Healthcheck200Response healthcheck()

Check whether the API is up

### Example
```dart
import 'package:vpn_api/api.dart';

final api = VpnApi().getInfrastructure();

try {
    final response = api.healthcheck();
    print(response);
} catch on DioException (e) {
    print('Exception when calling Infrastructure->healthcheck: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**Healthcheck200Response**](Healthcheck200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

