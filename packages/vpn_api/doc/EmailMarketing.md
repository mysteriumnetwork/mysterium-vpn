# vpn_api.api.EmailMarketing

## Load the API package
```dart
import 'package:vpn_api/api.dart';
```

All URIs are relative to *http://localhost:3030/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**setMarketingConsent**](EmailMarketing.md#setmarketingconsent) | **POST** /email-marketing/marketing-consent | Set marketing consent


# **setMarketingConsent**
> setMarketingConsent(marketingPermissionsRequest)

Set marketing consent

### Example
```dart
import 'package:vpn_api/api.dart';

final api = VpnApi().getEmailMarketing();
final MarketingPermissionsRequest marketingPermissionsRequest = ; // MarketingPermissionsRequest | 

try {
    api.setMarketingConsent(marketingPermissionsRequest);
} catch on DioException (e) {
    print('Exception when calling EmailMarketing->setMarketingConsent: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **marketingPermissionsRequest** | [**MarketingPermissionsRequest**](MarketingPermissionsRequest.md)|  | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

