# vpn_api.api.Location

## Load the API package
```dart
import 'package:vpn_api/api.dart';
```

All URIs are relative to *http://localhost:3030/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**location**](Location.md#location) | **GET** /subscription/location | Get location


# **location**
> GetLocationResponse location()

Get location

### Example
```dart
import 'package:vpn_api/api.dart';

final api = VpnApi().getLocation();

try {
    final response = api.location();
    print(response);
} catch on DioException (e) {
    print('Exception when calling Location->location: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**GetLocationResponse**](GetLocationResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

