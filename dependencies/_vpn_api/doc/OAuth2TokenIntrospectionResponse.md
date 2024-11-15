# vpn_api.model.OAuth2TokenIntrospectionResponse

## Load the model package
```dart
import 'package:vpn_api/api.dart';
```

## Properties
Name | Type | Description | Notes
------------ | ------------- | ------------- | -------------
**active** | **bool** | Boolean indicator of whether or not the presented token is currently active | 
**username** | **String** | Username (e-mail) associated with the presented token | [optional] 
**sub** | **String** | User ID | [optional] 
**exp** | **num** | Integer timestamp, measured in the number of seconds since January 1 1970 UTC, indicating when this token will expire, as defined in JWT | [optional] 

[[Back to Model list]](../README.md#documentation-for-models) [[Back to API list]](../README.md#documentation-for-api-endpoints) [[Back to README]](../README.md)


