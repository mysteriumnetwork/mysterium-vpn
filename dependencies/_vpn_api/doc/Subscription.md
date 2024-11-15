# vpn_api.api.Subscription

## Load the API package
```dart
import 'package:vpn_api/api.dart';
```

All URIs are relative to *http://localhost:3030/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**invoices**](Subscription.md#invoices) | **POST** /subscription/invoices | Get invoices list with pagination
[**orderSummary**](Subscription.md#ordersummary) | **POST** /subscription/order-summary | Preview order summary breakdown
[**subscribe**](Subscription.md#subscribe) | **POST** /subscription | Create subscription
[**subscriptionConfig**](Subscription.md#subscriptionconfig) | **GET** /subscription/config | Get subscription options
[**subscriptionStatus**](Subscription.md#subscriptionstatus) | **GET** /subscription | Get subscription status
[**subscriptionUserCallback**](Subscription.md#subscriptionusercallback) | **POST** /subscription/user-callback | Post user callback of payment


# **invoices**
> InvoicesResponse invoices(invoicesRequest)

Get invoices list with pagination

### Example
```dart
import 'package:vpn_api/api.dart';

final api = VpnApi().getSubscription();
final InvoicesRequest invoicesRequest = ; // InvoicesRequest | 

try {
    final response = api.invoices(invoicesRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling Subscription->invoices: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **invoicesRequest** | [**InvoicesRequest**](InvoicesRequest.md)|  | [optional] 

### Return type

[**InvoicesResponse**](InvoicesResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **orderSummary**
> OrderSummaryResponse orderSummary(orderSummaryRequest)

Preview order summary breakdown

### Example
```dart
import 'package:vpn_api/api.dart';

final api = VpnApi().getSubscription();
final OrderSummaryRequest orderSummaryRequest = ; // OrderSummaryRequest | 

try {
    final response = api.orderSummary(orderSummaryRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling Subscription->orderSummary: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **orderSummaryRequest** | [**OrderSummaryRequest**](OrderSummaryRequest.md)|  | [optional] 

### Return type

[**OrderSummaryResponse**](OrderSummaryResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **subscribe**
> Subscribe200Response subscribe(subscribeRequest)

Create subscription

### Example
```dart
import 'package:vpn_api/api.dart';

final api = VpnApi().getSubscription();
final SubscribeRequest subscribeRequest = ; // SubscribeRequest | 

try {
    final response = api.subscribe(subscribeRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling Subscription->subscribe: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **subscribeRequest** | [**SubscribeRequest**](SubscribeRequest.md)|  | [optional] 

### Return type

[**Subscribe200Response**](Subscribe200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **subscriptionConfig**
> SubscriptionConfigResponse subscriptionConfig()

Get subscription options

### Example
```dart
import 'package:vpn_api/api.dart';

final api = VpnApi().getSubscription();

try {
    final response = api.subscriptionConfig();
    print(response);
} catch on DioException (e) {
    print('Exception when calling Subscription->subscriptionConfig: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**SubscriptionConfigResponse**](SubscriptionConfigResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **subscriptionStatus**
> GetSubscriptionResponse subscriptionStatus()

Get subscription status

### Example
```dart
import 'package:vpn_api/api.dart';

final api = VpnApi().getSubscription();

try {
    final response = api.subscriptionStatus();
    print(response);
} catch on DioException (e) {
    print('Exception when calling Subscription->subscriptionStatus: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**GetSubscriptionResponse**](GetSubscriptionResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **subscriptionUserCallback**
> subscriptionUserCallback(userCallbackRequest)

Post user callback of payment

### Example
```dart
import 'package:vpn_api/api.dart';

final api = VpnApi().getSubscription();
final UserCallbackRequest userCallbackRequest = ; // UserCallbackRequest | 

try {
    api.subscriptionUserCallback(userCallbackRequest);
} catch on DioException (e) {
    print('Exception when calling Subscription->subscriptionUserCallback: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **userCallbackRequest** | [**UserCallbackRequest**](UserCallbackRequest.md)|  | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

