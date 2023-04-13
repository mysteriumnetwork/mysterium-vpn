import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/services/local_db_service.dart';

part 'analytics_store.g.dart';

// ignore: library_private_types_in_public_api
class AnalyticsStore = _AnalyticsStore with _$AnalyticsStore;

abstract class _AnalyticsStore with Store {
  _AnalyticsStore({required FirebaseAnalytics analytics, required LocalDBService localDb})
      : _analytics = analytics,
        _localDb = localDb;

  final FirebaseAnalytics _analytics;
  final LocalDBService _localDb;

  @action
  Future<void> logEvent(AnalyticsEvent event, Map<String, dynamic> parameters) async {
    await _analytics.logEvent(name: event.toSnakeCase, parameters: parameters);
  }

  @action
  Future<void> setUserId(String id) async {
    await _analytics.setUserId(id: id);
  }

  @action
  Future<void> setUserProperty(String name, String value) async {
    await _analytics.setUserProperty(name: name, value: value);
  }

  @action
  Future<void> setScreenName(String name) async {
    await _analytics.setCurrentScreen(screenName: name);
  }

  @action
  Future<void> setSessionTimeoutDuration() async {
    await _analytics.logAppOpen();
  }

  @action
  Future<void> setLogin([AuthMethod loginMethod = AuthMethod.email]) async {
    await _analytics.logLogin(loginMethod: loginMethod.name);
  }

  @action
  Future<void> setSignUp(String userId, [AuthMethod signUpMethod = AuthMethod.email]) async {
    if (!_localDb.checkUserExistance(userId)) {
      await _analytics.logSignUp(signUpMethod: signUpMethod.name);
    }
  }

  @action
  Future<void> setLogOut(String userId) async {
    await logEvent(AnalyticsEvent.logout, {'user_email': userId});
  }
}
