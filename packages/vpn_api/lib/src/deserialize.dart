import 'package:vpn_api/src/model/api_error.dart';
import 'package:vpn_api/src/model/activation_authorization_request.dart';
import 'package:vpn_api/src/model/auth_check_response.dart';
import 'package:vpn_api/src/model/auth_config_response.dart';
import 'package:vpn_api/src/model/check_auth401_response.dart';
import 'package:vpn_api/src/model/check_auth401_response_error.dart';
import 'package:vpn_api/src/model/check_auth401_response_error_fields_value.dart';
import 'package:vpn_api/src/model/code_authorization_request.dart';
import 'package:vpn_api/src/model/connection_config_regions_query.dart';
import 'package:vpn_api/src/model/connection_config_regions_response.dart';
import 'package:vpn_api/src/model/connection_config_request_query.dart';
import 'package:vpn_api/src/model/connection_config_response.dart';
import 'package:vpn_api/src/model/connection_killed_message.dart';
import 'package:vpn_api/src/model/connection_location.dart';
import 'package:vpn_api/src/model/connection_location_city.dart';
import 'package:vpn_api/src/model/connection_locations_request_query.dart';
import 'package:vpn_api/src/model/connection_message.dart';
import 'package:vpn_api/src/model/connection_message_location.dart';
import 'package:vpn_api/src/model/connection_region.dart';
import 'package:vpn_api/src/model/country.dart';
import 'package:vpn_api/src/model/create_adyen_subscription_request.dart';
import 'package:vpn_api/src/model/create_adyen_subscription_response.dart';
import 'package:vpn_api/src/model/create_apple_subscription_request.dart';
import 'package:vpn_api/src/model/create_apple_subscription_response.dart';
import 'package:vpn_api/src/model/create_generic_subscription_request.dart';
import 'package:vpn_api/src/model/create_generic_subscription_response.dart';
import 'package:vpn_api/src/model/create_google_subscription_request.dart';
import 'package:vpn_api/src/model/create_google_subscription_response.dart';
import 'package:vpn_api/src/model/disconnect_query.dart';
import 'package:vpn_api/src/model/field_error.dart';
import 'package:vpn_api/src/model/get_location_response.dart';
import 'package:vpn_api/src/model/get_subscription_response.dart';
import 'package:vpn_api/src/model/healthcheck200_response.dart';
import 'package:vpn_api/src/model/healthcheck_message.dart';
import 'package:vpn_api/src/model/healthcheck_response.dart';
import 'package:vpn_api/src/model/https_connect_request.dart';
import 'package:vpn_api/src/model/invoice.dart';
import 'package:vpn_api/src/model/invoices_request.dart';
import 'package:vpn_api/src/model/invoices_response.dart';
import 'package:vpn_api/src/model/invoices_response_paging.dart';
import 'package:vpn_api/src/model/location_rate.dart';
import 'package:vpn_api/src/model/magic_link_redirect_request_query.dart';
import 'package:vpn_api/src/model/magic_link_request.dart';
import 'package:vpn_api/src/model/magic_link_response.dart';
import 'package:vpn_api/src/model/marketing_permissions_request.dart';
import 'package:vpn_api/src/model/o_auth2_authorization_request.dart';
import 'package:vpn_api/src/model/o_auth2_authorization_response.dart';
import 'package:vpn_api/src/model/o_auth2_token_introspection_request.dart';
import 'package:vpn_api/src/model/o_auth2_token_introspection_response.dart';
import 'package:vpn_api/src/model/o_auth2_token_request.dart';
import 'package:vpn_api/src/model/o_auth2_token_request_one_of.dart';
import 'package:vpn_api/src/model/o_auth2_token_request_one_of1.dart';
import 'package:vpn_api/src/model/o_auth2_token_request_one_of2.dart';
import 'package:vpn_api/src/model/o_auth2_token_request_one_of3.dart';
import 'package:vpn_api/src/model/o_auth2_token_request_one_of3_authorization.dart';
import 'package:vpn_api/src/model/o_auth2_token_response.dart';
import 'package:vpn_api/src/model/order_summary_request.dart';
import 'package:vpn_api/src/model/order_summary_response.dart';
import 'package:vpn_api/src/model/proxy_connect_response.dart';
import 'package:vpn_api/src/model/proxy_connect_response_proxy_config.dart';
import 'package:vpn_api/src/model/rate_connection_request.dart';
import 'package:vpn_api/src/model/request_activation200_response.dart';
import 'package:vpn_api/src/model/request_activation_request.dart';
import 'package:vpn_api/src/model/subscribe200_response.dart';
import 'package:vpn_api/src/model/subscribe_request.dart';
import 'package:vpn_api/src/model/subscription_config_response.dart';
import 'package:vpn_api/src/model/subscription_config_response_gateways_inner.dart';
import 'package:vpn_api/src/model/subscription_config_response_plans_inner.dart';
import 'package:vpn_api/src/model/subscription_config_response_plans_inner_interval.dart';
import 'package:vpn_api/src/model/subscription_config_response_plans_inner_price.dart';
import 'package:vpn_api/src/model/subscription_config_response_plans_inner_prices_inner.dart';
import 'package:vpn_api/src/model/user_callback_request.dart';
import 'package:vpn_api/src/model/wireguard_connect_request.dart';
import 'package:vpn_api/src/model/wireguard_connect_response.dart';

final _regList = RegExp(r'^List<(.*)>$');
final _regSet = RegExp(r'^Set<(.*)>$');
final _regMap = RegExp(r'^Map<String,(.*)>$');

ReturnType deserialize<ReturnType, BaseType>(dynamic value, String targetType,
    {bool growable = true}) {
  switch (targetType) {
    case 'String':
      return '$value' as ReturnType;
    case 'int':
      return (value is int ? value : int.parse('$value')) as ReturnType;
    case 'bool':
      if (value is bool) {
        return value as ReturnType;
      }
      final valueString = '$value'.toLowerCase();
      return (valueString == 'true' || valueString == '1') as ReturnType;
    case 'double':
      return (value is double ? value : double.parse('$value')) as ReturnType;
    case 'APIError':
      return APIError.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'ActivationAuthorizationRequest':
      return ActivationAuthorizationRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'AuthCheckResponse':
      return AuthCheckResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'AuthConfigResponse':
      return AuthConfigResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'CheckAuth401Response':
      return CheckAuth401Response.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'CheckAuth401ResponseError':
      return CheckAuth401ResponseError.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'CheckAuth401ResponseErrorFieldsValue':
      return CheckAuth401ResponseErrorFieldsValue.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'CodeAuthorizationRequest':
      return CodeAuthorizationRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'ConnectionConfigRegionsQuery':
      return ConnectionConfigRegionsQuery.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'ConnectionConfigRegionsResponse':
      return ConnectionConfigRegionsResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'ConnectionConfigRequestQuery':
      return ConnectionConfigRequestQuery.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'ConnectionConfigResponse':
      return ConnectionConfigResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'ConnectionKilledMessage':
      return ConnectionKilledMessage.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'ConnectionLocation':
      return ConnectionLocation.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'ConnectionLocationCity':
      return ConnectionLocationCity.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'ConnectionLocationsRequestQuery':
      return ConnectionLocationsRequestQuery.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'ConnectionMessage':
      return ConnectionMessage.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'ConnectionMessageLocation':
      return ConnectionMessageLocation.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'ConnectionRegion':
      return ConnectionRegion.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'Country':
      return Country.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'CreateAdyenSubscriptionRequest':
      return CreateAdyenSubscriptionRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'CreateAdyenSubscriptionResponse':
      return CreateAdyenSubscriptionResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'CreateAppleSubscriptionRequest':
      return CreateAppleSubscriptionRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'CreateAppleSubscriptionResponse':
      return CreateAppleSubscriptionResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'CreateGenericSubscriptionRequest':
      return CreateGenericSubscriptionRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'CreateGenericSubscriptionResponse':
      return CreateGenericSubscriptionResponse.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'CreateGoogleSubscriptionRequest':
      return CreateGoogleSubscriptionRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'CreateGoogleSubscriptionResponse':
      return CreateGoogleSubscriptionResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'DisconnectQuery':
      return DisconnectQuery.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'FieldError':
      return FieldError.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'GetLocationResponse':
      return GetLocationResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'GetSubscriptionResponse':
      return GetSubscriptionResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'Healthcheck200Response':
      return Healthcheck200Response.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'HealthcheckMessage':
      return HealthcheckMessage.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'HealthcheckResponse':
      return HealthcheckResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'HttpsConnectRequest':
      return HttpsConnectRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'Invoice':
      return Invoice.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'InvoicesRequest':
      return InvoicesRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'InvoicesResponse':
      return InvoicesResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'InvoicesResponsePaging':
      return InvoicesResponsePaging.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'LocationRate':
      return LocationRate.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'MagicLinkRedirectRequestQuery':
      return MagicLinkRedirectRequestQuery.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'MagicLinkRequest':
      return MagicLinkRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'MagicLinkResponse':
      return MagicLinkResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'MarketingPermissionsRequest':
      return MarketingPermissionsRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'OAuth2AuthorizationRequest':
      return OAuth2AuthorizationRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'OAuth2AuthorizationResponse':
      return OAuth2AuthorizationResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'OAuth2TokenIntrospectionRequest':
      return OAuth2TokenIntrospectionRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'OAuth2TokenIntrospectionResponse':
      return OAuth2TokenIntrospectionResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'OAuth2TokenRequest':
      return OAuth2TokenRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'OAuth2TokenRequestOneOf':
      return OAuth2TokenRequestOneOf.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'OAuth2TokenRequestOneOf1':
      return OAuth2TokenRequestOneOf1.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'OAuth2TokenRequestOneOf2':
      return OAuth2TokenRequestOneOf2.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'OAuth2TokenRequestOneOf3':
      return OAuth2TokenRequestOneOf3.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'OAuth2TokenRequestOneOf3Authorization':
      return OAuth2TokenRequestOneOf3Authorization.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'OAuth2TokenResponse':
      return OAuth2TokenResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'OrderSummaryRequest':
      return OrderSummaryRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'OrderSummaryResponse':
      return OrderSummaryResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'ProxyConnectResponse':
      return ProxyConnectResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'ProxyConnectResponseProxyConfig':
      return ProxyConnectResponseProxyConfig.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'RateConnectionRequest':
      return RateConnectionRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'RequestActivation200Response':
      return RequestActivation200Response.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'RequestActivationRequest':
      return RequestActivationRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'Subscribe200Response':
      return Subscribe200Response.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'SubscribeRequest':
      return SubscribeRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'SubscriptionConfigResponse':
      return SubscriptionConfigResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'SubscriptionConfigResponseGatewaysInner':
      return SubscriptionConfigResponseGatewaysInner.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'SubscriptionConfigResponsePlansInner':
      return SubscriptionConfigResponsePlansInner.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'SubscriptionConfigResponsePlansInnerInterval':
      return SubscriptionConfigResponsePlansInnerInterval.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'SubscriptionConfigResponsePlansInnerPrice':
      return SubscriptionConfigResponsePlansInnerPrice.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'SubscriptionConfigResponsePlansInnerPricesInner':
      return SubscriptionConfigResponsePlansInnerPricesInner.fromJson(value as Map<String, dynamic>)
          as ReturnType;
    case 'UserCallbackRequest':
      return UserCallbackRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'WireguardConnectRequest':
      return WireguardConnectRequest.fromJson(value as Map<String, dynamic>) as ReturnType;
    case 'WireguardConnectResponse':
      return WireguardConnectResponse.fromJson(value as Map<String, dynamic>) as ReturnType;
    default:
      RegExpMatch? match;

      if (value is List && (match = _regList.firstMatch(targetType)) != null) {
        targetType = match![1]!; // ignore: parameter_assignments
        return value
            .map<BaseType>(
                (dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable))
            .toList(growable: growable) as ReturnType;
      }
      if (value is Set && (match = _regSet.firstMatch(targetType)) != null) {
        targetType = match![1]!; // ignore: parameter_assignments
        return value
            .map<BaseType>(
                (dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable))
            .toSet() as ReturnType;
      }
      if (value is Map && (match = _regMap.firstMatch(targetType)) != null) {
        targetType = match![1]!.trim(); // ignore: parameter_assignments
        return Map<String, BaseType>.fromIterables(
          value.keys as Iterable<String>,
          value.values.map(
              (dynamic v) => deserialize<BaseType, BaseType>(v, targetType, growable: growable)),
        ) as ReturnType;
      }
      break;
  }
  throw Exception('Cannot deserialize');
}
