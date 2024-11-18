# vpn_api.model.OAuth2TokenRequest

## Load the model package
```dart
import 'package:vpn_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**grantType** | **String** |  | 
**clientId** | **String** |  | 
**refreshToken** | **String** |  | 
**codeVerifier** | **String** |  | 
**code** | **String** | Google authorization code for retrieving access token | 
**googleIdToken** | **String** | Google access token. Required if authorization code is not provided. | [optional] 
**authorization** | [**OAuth2TokenRequestOneOf3Authorization**](OAuth2TokenRequestOneOf3Authorization.md) |  | 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


