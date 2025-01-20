# vpn_api.api.Authentication

## Load the API package
```dart
import 'package:vpn_api/api.dart';
```

All URIs are relative to *http://localhost:3030/api/v1*

Method | HTTP request | Description
------------- | ------------- | -------------
[**authConfig**](Authentication.md#authconfig) | **GET** /auth/config | Get authentication configuration
[**checkAuth**](Authentication.md#checkauth) | **GET** /auth/check | Get authentication status
[**getActivationStatus**](Authentication.md#getactivationstatus) | **GET** /auth/activation/{id} | Get activation request status
[**introspectToken**](Authentication.md#introspecttoken) | **POST** /oauth/introspect | OAuth Token introspection endpoint [RFC 7662]
[**logout**](Authentication.md#logout) | **POST** /auth/logout | Deletes authentication cookie (effective on web only)
[**redirectMagicLink**](Authentication.md#redirectmagiclink) | **GET** /magic-link/redirect | Redirect from magic link click
[**requestActivation**](Authentication.md#requestactivation) | **POST** /auth/activation | Create session activation request
[**requestMagicLink**](Authentication.md#requestmagiclink) | **POST** /magic-link | Request magic link
[**token**](Authentication.md#token) | **POST** /oauth/token | OAuth Token endpoint [RFC 6749]. Requires Proof Key for Code Exchange (PKCE) [RFC 7636].


# **authConfig**
> AuthConfigResponse authConfig()

Get authentication configuration

### Example
```dart
import 'package:vpn_api/api.dart';

final api = VpnApi().getAuthentication();

try {
    final response = api.authConfig();
    print(response);
} catch on DioException (e) {
    print('Exception when calling Authentication->authConfig: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**AuthConfigResponse**](AuthConfigResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **checkAuth**
> AuthCheckResponse checkAuth()

Get authentication status

### Example
```dart
import 'package:vpn_api/api.dart';

final api = VpnApi().getAuthentication();

try {
    final response = api.checkAuth();
    print(response);
} catch on DioException (e) {
    print('Exception when calling Authentication->checkAuth: $e\n');
}
```

### Parameters
This endpoint does not need any parameter.

### Return type

[**AuthCheckResponse**](AuthCheckResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **getActivationStatus**
> RequestActivation200Response getActivationStatus(id)

Get activation request status

### Example
```dart
import 'package:vpn_api/api.dart';

final api = VpnApi().getAuthentication();
final String id = id_example; // String | 

try {
    final response = api.getActivationStatus(id);
    print(response);
} catch on DioException (e) {
    print('Exception when calling Authentication->getActivationStatus: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **id** | **String**|  | 

### Return type

[**RequestActivation200Response**](RequestActivation200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **introspectToken**
> OAuth2TokenIntrospectionResponse introspectToken(token)

OAuth Token introspection endpoint [RFC 7662]

### Example
```dart
import 'package:vpn_api/api.dart';

final api = VpnApi().getAuthentication();
final String token = token_example; // String | Token to be introspected. Optional when token is presented via Authorization header.

try {
    final response = api.introspectToken(token);
    print(response);
} catch on DioException (e) {
    print('Exception when calling Authentication->introspectToken: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **token** | **String**| Token to be introspected. Optional when token is presented via Authorization header. | [optional] 

### Return type

[**OAuth2TokenIntrospectionResponse**](OAuth2TokenIntrospectionResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/x-www-form-urlencoded, application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **logout**
> logout()

Deletes authentication cookie (effective on web only)

### Example
```dart
import 'package:vpn_api/api.dart';

final api = VpnApi().getAuthentication();

try {
    api.logout();
} catch on DioException (e) {
    print('Exception when calling Authentication->logout: $e\n');
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

# **redirectMagicLink**
> redirectMagicLink(code, continueTo, redirectUrl)

Redirect from magic link click

### Example
```dart
import 'package:vpn_api/api.dart';

final api = VpnApi().getAuthentication();
final String code = code_example; // String | 
final String continueTo = continueTo_example; // String | 
final String redirectUrl = redirectUrl_example; // String | 

try {
    api.redirectMagicLink(code, continueTo, redirectUrl);
} catch on DioException (e) {
    print('Exception when calling Authentication->redirectMagicLink: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **code** | **String**|  | 
 **continueTo** | **String**|  | [optional] 
 **redirectUrl** | **String**|  | [optional] 

### Return type

void (empty response body)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: Not defined
 - **Accept**: Not defined

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **requestActivation**
> RequestActivation200Response requestActivation(requestActivationRequest)

Create session activation request

### Example
```dart
import 'package:vpn_api/api.dart';

final api = VpnApi().getAuthentication();
final RequestActivationRequest requestActivationRequest = ; // RequestActivationRequest | 

try {
    final response = api.requestActivation(requestActivationRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling Authentication->requestActivation: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **requestActivationRequest** | [**RequestActivationRequest**](RequestActivationRequest.md)|  | [optional] 

### Return type

[**RequestActivation200Response**](RequestActivation200Response.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **requestMagicLink**
> MagicLinkResponse requestMagicLink(magicLinkRequest)

Request magic link

### Example
```dart
import 'package:vpn_api/api.dart';

final api = VpnApi().getAuthentication();
final MagicLinkRequest magicLinkRequest = ; // MagicLinkRequest | 

try {
    final response = api.requestMagicLink(magicLinkRequest);
    print(response);
} catch on DioException (e) {
    print('Exception when calling Authentication->requestMagicLink: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **magicLinkRequest** | [**MagicLinkRequest**](MagicLinkRequest.md)|  | [optional] 

### Return type

[**MagicLinkResponse**](MagicLinkResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

# **token**
> OAuth2TokenResponse token(grantType, clientId, refreshToken, codeVerifier, code, googleIdToken, authorization)

OAuth Token endpoint [RFC 6749]. Requires Proof Key for Code Exchange (PKCE) [RFC 7636].

### Example
```dart
import 'package:vpn_api/api.dart';

final api = VpnApi().getAuthentication();
final String grantType = grantType_example; // String | 
final String clientId = clientId_example; // String | 
final String refreshToken = refreshToken_example; // String | 
final String codeVerifier = codeVerifier_example; // String | 
final String code = code_example; // String | Google authorization code for retrieving access token
final String googleIdToken = googleIdToken_example; // String | Google access token. Required if authorization code is not provided.
final OAuth2TokenRequestOneOf3Authorization authorization = ; // OAuth2TokenRequestOneOf3Authorization | 

try {
    final response = api.token(grantType, clientId, refreshToken, codeVerifier, code, googleIdToken, authorization);
    print(response);
} catch on DioException (e) {
    print('Exception when calling Authentication->token: $e\n');
}
```

### Parameters

Name | Type | Description  | Notes
------------- | ------------- | ------------- | -------------
 **grantType** | **String**|  | [optional] 
 **clientId** | **String**|  | [optional] 
 **refreshToken** | **String**|  | [optional] 
 **codeVerifier** | **String**|  | [optional] 
 **code** | **String**| Google authorization code for retrieving access token | [optional] 
 **googleIdToken** | **String**| Google access token. Required if authorization code is not provided. | [optional] 
 **authorization** | [**OAuth2TokenRequestOneOf3Authorization**](OAuth2TokenRequestOneOf3Authorization.md)|  | [optional] 

### Return type

[**OAuth2TokenResponse**](OAuth2TokenResponse.md)

### Authorization

No authorization required

### HTTP request headers

 - **Content-Type**: application/x-www-form-urlencoded, application/json
 - **Accept**: application/json

[[Back to top]](#) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to Model list]](../README.md#documentation-for-models) [[Back to README]](../README.md)

