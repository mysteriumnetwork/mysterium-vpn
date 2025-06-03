//
// AUTO-GENERATED FILE, DO NOT MODIFY!
//

import 'package:dio/dio.dart';
import 'package:vpn_api/src/auth/api_key_auth.dart';
import 'package:vpn_api/src/auth/basic_auth.dart';
import 'package:vpn_api/src/auth/bearer_auth.dart';
import 'package:vpn_api/src/auth/oauth.dart';
import 'package:vpn_api/src/api/authentication.dart';
import 'package:vpn_api/src/api/connection.dart';
import 'package:vpn_api/src/api/email_marketing.dart';
import 'package:vpn_api/src/api/infrastructure.dart';
import 'package:vpn_api/src/api/location.dart';
import 'package:vpn_api/src/api/subscription.dart';

class VpnApi {
  static const String basePath = r'http://localhost:3030/api/v1';

  final Dio dio;
  VpnApi({
    Dio? dio,
    String? basePathOverride,
    List<Interceptor>? interceptors,
  }) : this.dio = dio ??
            Dio(BaseOptions(
              baseUrl: basePathOverride ?? basePath,
              connectTimeout: const Duration(milliseconds: 5000),
              receiveTimeout: const Duration(milliseconds: 3000),
            )) {
    if (interceptors == null) {
      this.dio.interceptors.addAll([
        OAuthInterceptor(),
        BasicAuthInterceptor(),
        BearerAuthInterceptor(),
        ApiKeyAuthInterceptor(),
      ]);
    } else {
      this.dio.interceptors.addAll(interceptors);
    }
  }

  void setOAuthToken(String name, String token) {
    if (this.dio.interceptors.any((i) => i is OAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is OAuthInterceptor) as OAuthInterceptor)
          .tokens[name] = token;
    }
  }

  void setBearerAuth(String name, String token) {
    if (this.dio.interceptors.any((i) => i is BearerAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is BearerAuthInterceptor) as BearerAuthInterceptor)
          .tokens[name] = token;
    }
  }

  void setBasicAuth(String name, String username, String password) {
    if (this.dio.interceptors.any((i) => i is BasicAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((i) => i is BasicAuthInterceptor) as BasicAuthInterceptor)
          .authInfo[name] = BasicAuthInfo(username, password);
    }
  }

  void setApiKey(String name, String apiKey) {
    if (this.dio.interceptors.any((i) => i is ApiKeyAuthInterceptor)) {
      (this.dio.interceptors.firstWhere((element) => element is ApiKeyAuthInterceptor)
              as ApiKeyAuthInterceptor)
          .apiKeys[name] = apiKey;
    }
  }

  /// Get Authentication instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  Authentication getAuthentication() {
    return Authentication(dio);
  }

  /// Get Connection instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  Connection getConnection() {
    return Connection(dio);
  }

  /// Get EmailMarketing instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  EmailMarketing getEmailMarketing() {
    return EmailMarketing(dio);
  }

  /// Get Infrastructure instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  Infrastructure getInfrastructure() {
    return Infrastructure(dio);
  }

  /// Get Location instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  Location getLocation() {
    return Location(dio);
  }

  /// Get Subscription instance, base route and serializer can be overridden by a given but be careful,
  /// by doing that all interceptors will not be executed
  Subscription getSubscription() {
    return Subscription(dio);
  }
}
