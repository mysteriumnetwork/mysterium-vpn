import 'dart:convert';

import 'package:collection/collection.dart';
import 'package:mobx/mobx.dart';
import 'package:mysterium_vpn/common/constants/constants.dart';
import 'package:mysterium_vpn/common/extensions/string.dart';
import 'package:mysterium_vpn/env.dart';
import 'package:mysterium_vpn/models/models.dart';
import 'package:mysterium_vpn/stores/stores.dart';

part 'remote_config_store.g.dart';

enum _FeatureToggleKey {
  isServiceAvailable,
  isServiceAvailableMessage,
  hideDeleteAccount,
  minAndroidBuildNumber,
  minIosBuildNumber,
  minWindowsBuildNumber,
  minWindowsStandAloneBuildNumber,
  minMacosBuildNumber,
  hideMalwareBlocker,
  hideNotSafeContentBlocker,
  malwareBlockerDnsAddress,
  notSafeContentBlockerDnsAddress,
  mqttExperiment,
  locationsRefreshInterval,
  sentryDsn,
  hideResetAppSetting,
  browseUnauthenticated,
  shouldCheckUdp,
  latestStableAppVersion,
  cancelSurveyOptions,
  useStoreVersionChecker,
  enableQaHelpers,
  showCitiesAndStates,
  countriesWithCitiesOnMap,
  showUserIntents,
  userIntentBlacklist,
  userIntentsRefreshInterval,
  recentLocationsLimit,
  mapConfig,
  limitedTimeOfferExpiryDate,
  limitedTimeOfferId,
  isProtocolPickerAvailable,
  planFeatures,
  plansBestValue,
  upgradeSubscriptionPage,
  manageSubscriptionPage,
  promotionalBannerContent,
  pushNotifPermissionPromptCooldown,
  checkoutWebRedirectUrl,
  gatewaysSupportingUpgrade,
  pricingMonthly,
  countriesWithStates,
  hideReedemCode,
  canShowNoSubsOnboardingFlow,
  residentialEducationConnectThreshold,
  residentialReminderIntervalMinutes,
  reviewPromptConfig,
  canShowSubscriptionOnboardingFlow,
  locationsPullToRefreshEnabled,
  locationsRefreshButtonEnabled,
  newsCenterEnabled,
  newsCenterRefreshIntervalMinutes,
  showApiVersion,
  subscriptionFreezeDurations,
}

class RemoteConfigStore = RemoteConfigStoreBase with _$RemoteConfigStore;

abstract class RemoteConfigStoreBase extends ConfigCatStore with Store {
  RemoteConfigStoreBase(super.client, super.logger, {bool isDev = false}) : _isDev = isDev;

  final bool _isDev;

  @computed
  bool get isServiceAvailable {
    if (config.containsKey(_FeatureToggleKey.isServiceAvailable.name)) {
      return config[_FeatureToggleKey.isServiceAvailable.name] as bool;
    }
    return true;
  }

  @computed
  String get isServiceAvailableMessage {
    if (config.containsKey(_FeatureToggleKey.isServiceAvailableMessage.name)) {
      return config[_FeatureToggleKey.isServiceAvailableMessage.name] as String;
    }
    return 'Service is not available. Please try again later.';
  }

  @computed
  bool get hideDeleteAccount {
    if (config.containsKey(_FeatureToggleKey.hideDeleteAccount.name)) {
      return config[_FeatureToggleKey.hideDeleteAccount.name] as bool;
    }
    return false;
  }

  @computed
  String get minMacosBuildNumber {
    if (config.containsKey(_FeatureToggleKey.minMacosBuildNumber.name)) {
      return config[_FeatureToggleKey.minMacosBuildNumber.name] as String;
    }
    return '0';
  }

  @computed
  String get minWindowsStandAloneBuildNumber {
    if (config.containsKey(_FeatureToggleKey.minWindowsStandAloneBuildNumber.name)) {
      return config[_FeatureToggleKey.minWindowsStandAloneBuildNumber.name] as String;
    }
    return '0';
  }

  @computed
  String get minWindowsBuildNumber {
    if (config.containsKey(_FeatureToggleKey.minWindowsBuildNumber.name)) {
      return config[_FeatureToggleKey.minWindowsBuildNumber.name] as String;
    }
    return '0';
  }

  @computed
  String get minAndroidBuildNumber {
    if (config.containsKey(_FeatureToggleKey.minAndroidBuildNumber.name)) {
      return config[_FeatureToggleKey.minAndroidBuildNumber.name] as String;
    }
    return '0';
  }

  @computed
  String get minIosBuildNumber {
    if (config.containsKey(_FeatureToggleKey.minIosBuildNumber.name)) {
      return config[_FeatureToggleKey.minIosBuildNumber.name] as String;
    }
    return '0';
  }

  @computed
  bool get hideMalwareBlocker {
    if (config.containsKey(_FeatureToggleKey.hideMalwareBlocker.name)) {
      return config[_FeatureToggleKey.hideMalwareBlocker.name] as bool;
    }
    return false;
  }

  @computed
  bool get hideNotSafeContentBlocker {
    if (config.containsKey(_FeatureToggleKey.hideNotSafeContentBlocker.name)) {
      return config[_FeatureToggleKey.hideNotSafeContentBlocker.name] as bool;
    }
    return false;
  }

  @computed
  String get malwareBlockerDnsAddress {
    if (config.containsKey(_FeatureToggleKey.malwareBlockerDnsAddress.name)) {
      return config[_FeatureToggleKey.malwareBlockerDnsAddress.name] as String;
    }
    return malwareContentBlockerDomainAddress;
  }

  @computed
  String get notSafeContentBlockerDnsAddress {
    if (config.containsKey(_FeatureToggleKey.notSafeContentBlockerDnsAddress.name)) {
      return config[_FeatureToggleKey.notSafeContentBlockerDnsAddress.name] as String;
    }
    return notSafeContentBlockerDomainAddress;
  }

  @computed
  bool get mqttExperiment {
    if (config.containsKey(_FeatureToggleKey.mqttExperiment.name)) {
      return config[_FeatureToggleKey.mqttExperiment.name] as bool;
    }
    return false;
  }

  @computed
  Duration get locationsRefreshInterval {
    if (config.containsKey(_FeatureToggleKey.locationsRefreshInterval.name)) {
      final raw = config[_FeatureToggleKey.locationsRefreshInterval.name];
      if (raw is int) {
        return Duration(seconds: raw);
      }
    }
    return const Duration(minutes: 10);
  }

  @computed
  String? get sentryDsn {
    if (config.containsKey(_FeatureToggleKey.sentryDsn.name)) {
      return config[_FeatureToggleKey.sentryDsn.name] as String;
    }
    return null;
  }

  @computed
  bool get hideResetAppSetting {
    if (config.containsKey(_FeatureToggleKey.hideResetAppSetting.name)) {
      return config[_FeatureToggleKey.hideResetAppSetting.name] as bool;
    }
    return false;
  }

  @computed
  bool get browseUnauthenticated {
    if (config.containsKey(_FeatureToggleKey.browseUnauthenticated.name)) {
      return config[_FeatureToggleKey.browseUnauthenticated.name] as bool;
    }
    return false;
  }

  @computed
  bool get shouldCheckUdp {
    if (config.containsKey(_FeatureToggleKey.shouldCheckUdp.name)) {
      return config[_FeatureToggleKey.shouldCheckUdp.name] as bool;
    }
    return true;
  }

  @computed
  String get latestStableAppVersion {
    if (config.containsKey(_FeatureToggleKey.latestStableAppVersion.name)) {
      return config[_FeatureToggleKey.latestStableAppVersion.name] as String;
    }
    return '2.0.2';
  }

  @computed
  Set<String>? get cancelSubscriptionReasonKeys {
    if (config.containsKey(_FeatureToggleKey.cancelSurveyOptions.name)) {
      final raw = config[_FeatureToggleKey.cancelSurveyOptions.name].toString();
      final json = jsonDecode(raw);
      if (json is Iterable) {
        return json.map((it) => it.toString()).toSet();
      }
    }
    return null;
  }

  @computed
  bool get useStoreVersionChecker {
    if (config.containsKey(_FeatureToggleKey.useStoreVersionChecker.name)) {
      return config[_FeatureToggleKey.useStoreVersionChecker.name] as bool;
    }
    return true;
  }

  @computed
  bool get enableQaHelpers {
    if (config.containsKey(_FeatureToggleKey.enableQaHelpers.name)) {
      return config[_FeatureToggleKey.enableQaHelpers.name] as bool;
    }
    return _isDev; // Enable QA helpers in development mode
  }

  @computed
  bool get showCitiesAndStates {
    if (config.containsKey(_FeatureToggleKey.showCitiesAndStates.name)) {
      return config[_FeatureToggleKey.showCitiesAndStates.name] as bool;
    }
    return false;
  }

  /// Whether pull-to-refresh on the locations list is enabled.
  @computed
  bool get locationsPullToRefreshEnabled {
    final value = config[_FeatureToggleKey.locationsPullToRefreshEnabled.name];
    if (value is bool) {
      return value;
    }
    return true;
  }

  /// Whether the News Center feature (bell entry point + feed page) is enabled.
  /// Defaults to `true` (on in dev and prod); ConfigCat can flip it to `false`
  /// as a kill switch.
  @computed
  bool get newsCenterEnabled {
    final value = config[_FeatureToggleKey.newsCenterEnabled.name];
    if (value is bool) {
      return value;
    }
    return true;
  }

  /// How long the app must stay backgrounded before the News Center feed is
  /// auto-refreshed on resume, in minutes. `0` disables the auto-refresh.
  /// Defaults to 30 minutes; a missing, wrong-typed, or negative value falls
  /// back to the default.
  @computed
  int get newsCenterRefreshIntervalMinutes {
    const defaultMinutes = 30;
    final value = config[_FeatureToggleKey.newsCenterRefreshIntervalMinutes.name];
    if (value is int && value >= 0) {
      return value;
    }
    return defaultMinutes;
  }

  /// Whether the per-tab refresh icon button on the locations list is enabled.
  @computed
  bool get locationsRefreshButtonEnabled {
    final value = config[_FeatureToggleKey.locationsRefreshButtonEnabled.name];
    if (value is bool) {
      return value;
    }
    return true;
  }

  @computed
  Set<String> get countriesWithCitiesOnMap {
    try {
      if (config.containsKey(_FeatureToggleKey.countriesWithCitiesOnMap.name)) {
        final raw = config[_FeatureToggleKey.countriesWithCitiesOnMap.name];
        final decoded = jsonDecode(raw.toString()) as List;
        return decoded.map((it) => it.toString()).toSet();
      }
    } catch (e, stack) {
      logger.handle(e, stack);
    }
    return const <String>{};
  }

  @computed
  bool get showUserIntents {
    if (config.containsKey(_FeatureToggleKey.showUserIntents.name)) {
      return config[_FeatureToggleKey.showUserIntents.name] as bool;
    }
    return false;
  }

  @computed
  Set<UserIntent> get userIntentBlacklist {
    try {
      if (config.containsKey(_FeatureToggleKey.userIntentBlacklist.name)) {
        final raw = config[_FeatureToggleKey.userIntentBlacklist.name];
        final decoded = jsonDecode(raw.toString()) as List;
        final keys = decoded.map((it) => it.toString()).toSet();

        return keys
            .map(
              (key) => UserIntent.values.firstWhereOrNull((it) => it.key == key || it.name == key),
            )
            .nonNulls
            .toSet();
      }
    } catch (e, stack) {
      logger.handle(e, stack);
    }
    return {};
  }

  @computed
  Duration get userIntentsRefreshInterval {
    if (config.containsKey(_FeatureToggleKey.userIntentsRefreshInterval.name)) {
      final raw = config[_FeatureToggleKey.userIntentsRefreshInterval.name];
      if (raw is int) {
        return Duration(seconds: raw);
      }
    }
    return const Duration(minutes: 10);
  }

  @computed
  int get recentLocationsLimit {
    if (config.containsKey(_FeatureToggleKey.recentLocationsLimit.name)) {
      final raw = config[_FeatureToggleKey.recentLocationsLimit.name];
      if (raw is int && raw >= 0) {
        return raw;
      }
    }
    return 5;
  }

  @computed
  MapConfig get mapConfig {
    if (config.containsKey(_FeatureToggleKey.mapConfig.name)) {
      final raw = config[_FeatureToggleKey.mapConfig.name];
      try {
        final decoded = jsonDecode(raw.toString()) as Map<String, dynamic>;
        return MapConfig.fromJson(decoded);
      } catch (e, stack) {
        logger.handle(e, stack);
      }
    }

    return const MapConfig();
  }

  @computed
  String? get limitedTimeOfferId {
    if (config.containsKey(_FeatureToggleKey.limitedTimeOfferId.name)) {
      final raw = config[_FeatureToggleKey.limitedTimeOfferId.name];
      return raw.toString();
    }
    return null;
  }

  @computed
  DateTime? get limitedTimeOfferExpiryDate {
    if (config.containsKey(_FeatureToggleKey.limitedTimeOfferExpiryDate.name)) {
      final raw = config[_FeatureToggleKey.limitedTimeOfferExpiryDate.name];
      try {
        return DateTime.parse(raw.toString());
      } catch (e, stack) {
        logger.handle(e, stack);
      }
    }
    return null;
  }

  @computed
  bool get isProtocolPickerAvailable {
    if (config.containsKey(_FeatureToggleKey.isProtocolPickerAvailable.name)) {
      return config[_FeatureToggleKey.isProtocolPickerAvailable.name] as bool;
    }
    return false;
  }

  @computed
  List<SubscriptionPlanFeatures> get planFeatures {
    try {
      if (config.containsKey(_FeatureToggleKey.planFeatures.name)) {
        final raw = config[_FeatureToggleKey.planFeatures.name].toString();
        final json = jsonDecode(raw) as Iterable;
        return json
            .map((it) => SubscriptionPlanFeatures.fromJson(it as Map<String, dynamic>))
            .toList();
      }
    } catch (e, stack) {
      logger.handle(e, stack);
    }
    return [
      SubscriptionPlanFeatures(
        name: 'subscriptionPlanNameBasic',
        planIds: {'plan_monthly_basic', 'plan_yearly_basic'},
        previewFeatures: {
          'subscriptionPlanPF1Basic',
          'subscriptionPlanPF2Basic',
          'subscriptionPlanPF3Basic',
          'subscriptionPlanPF4Basic',
        },
        detailedFeatures: {
          'subscriptionPlanMoneyBack': true,
          'subscriptionPlanDevicesSecured': 6,
          'subscriptionPlanSupportedCountries': 57,
          'subscriptionPlanServers': 10,
          'subscriptionPlanWireGuard': true,
          'subscriptionPlanDoubleVPN': true,
          'subscriptionPlanResidentialIPs': false,
          'subscriptionPlanCityLevel': false,
          'subscriptionPlanMalwareBlocker': false,
        },
      ),
      SubscriptionPlanFeatures(
        name: 'subscriptionPlanNamePlus',
        planIds: {'plan_monthly_plus', 'plan_yearly_plus'},
        previewFeatures: {
          'subscriptionPlanPF1Plus',
          'subscriptionPlanPF2Plus',
          'subscriptionPlanPF3Plus',
          'subscriptionPlanPF4Plus',
          'subscriptionPlanPF5Plus',
          'subscriptionPlanPF6Plus',
        },
        detailedFeatures: {
          'subscriptionPlanMoneyBack': true,
          'subscriptionPlanDevicesSecured': 10,
          'subscriptionPlanSupportedCountries': '100+',
          'subscriptionPlanServers': 100,
          'subscriptionPlanWireGuard': true,
          'subscriptionPlanDoubleVPN': true,
          'subscriptionPlanResidentialIPs': '7.500+',
          'subscriptionPlanCityLevel': true,
          'subscriptionPlanMalwareBlocker': false,
        },
      ),
    ];
  }

  @computed
  Set<String> get plansBestValue {
    if (config.containsKey(_FeatureToggleKey.plansBestValue.name)) {
      final raw = config[_FeatureToggleKey.plansBestValue.name];
      try {
        final decoded = jsonDecode(raw.toString()) as List;
        return decoded.map((it) => it.toString()).toSet();
      } catch (e, stack) {
        logger.handle(e, stack);
      }
    }
    return {'plan_monthly', 'plan_yearly', 'plan_yearly_plus', 'plan_monthly_plus'};
  }

  @computed
  String get upgradeSubscriptionPage {
    final value = config[_FeatureToggleKey.upgradeSubscriptionPage.name] as String?;
    return (value?.isNotEmpty ?? false ? value! : Env.upgradeSubscriptionPage).trim();
  }

  @computed
  String get manageSubscriptionPage {
    final value = config[_FeatureToggleKey.manageSubscriptionPage.name] as String?;
    return (value?.isNotEmpty ?? false ? value! : Env.manageSubscriptionPage).trim();
  }

  @computed
  PromotionalBanner? get promotionalBanner {
    try {
      if (config.containsKey(_FeatureToggleKey.promotionalBannerContent.name)) {
        final raw = config[_FeatureToggleKey.promotionalBannerContent.name].toString();
        if (raw == 'null' || raw.isEmpty) {
          return null;
        }
        final json = jsonDecode(raw) as Map<String, dynamic>;
        return PromotionalBanner.fromJson(json);
      }
    } catch (e, stack) {
      logger.handle(e, stack);
    }
    return null;
  }

  /// Cooldown period (in hours) for prompting the user for push notification permission
  @computed
  int get pushNotifPermissionPromptCooldown {
    if (config.containsKey(_FeatureToggleKey.pushNotifPermissionPromptCooldown.name)) {
      final raw = config[_FeatureToggleKey.pushNotifPermissionPromptCooldown.name];
      if (raw is int) {
        return raw;
      }
    }
    return 24;
  }

  @computed
  Set<String> get gatewaysSupportingUpgrade {
    try {
      if (config.containsKey(_FeatureToggleKey.gatewaysSupportingUpgrade.name)) {
        final raw = config[_FeatureToggleKey.gatewaysSupportingUpgrade.name];
        final decoded = jsonDecode(raw.toString()) as List;
        final keys = decoded.map((it) => it.toString());
        return keys.map((key) => key.toLowerCase()).toSet();
      }
    } catch (e, stack) {
      logger.handle(e, stack);
    }
    // Primer is the web payment-orchestration layer; like stripe/adyen it
    // supports upgrading via the web checkout.
    return {'stripe', 'adyen', 'primer'};
  }

  @computed
  Uri get checkoutWebRedirectUrl {
    const webAppUrl = Env.webAppUrl;
    final localUri = Uri.https(webAppUrl, '/checkout/payment-upgrade');
    if (config.containsKey(_FeatureToggleKey.checkoutWebRedirectUrl.name)) {
      final raw = config[_FeatureToggleKey.checkoutWebRedirectUrl.name];
      final uri = Uri.tryParse(raw.toString());
      return uri ?? localUri;
    }
    return localUri;
  }

  @computed
  bool get pricingMonthly {
    if (config.containsKey(_FeatureToggleKey.pricingMonthly.name)) {
      return config[_FeatureToggleKey.pricingMonthly.name] as bool;
    }
    return true;
  }

  @computed
  Set<String> get countriesWithStates {
    try {
      if (config.containsKey(_FeatureToggleKey.countriesWithStates.name)) {
        final raw = config[_FeatureToggleKey.countriesWithStates.name];
        final decoded = jsonDecode(raw.toString()) as List;
        return decoded.map((it) => it.toString().toUpperCase()).toSet();
      }
    } catch (e, stack) {
      logger.handle(e, stack);
    }
    return const <String>{};
  }

  @computed
  bool get hideReedemCode {
    if (config.containsKey(_FeatureToggleKey.hideReedemCode.name)) {
      return config[_FeatureToggleKey.hideReedemCode.name] as bool;
    }
    return false;
  }

  @computed
  bool get canShowNoSubsOnboardingFlow {
    if (config.containsKey(_FeatureToggleKey.canShowNoSubsOnboardingFlow.name)) {
      return config[_FeatureToggleKey.canShowNoSubsOnboardingFlow.name] as bool;
    }
    return true;
  }

  /// Number of residential connections required before the full education
  /// modal is shown (i.e. it shows on the Nth connect).
  @computed
  int get residentialEducationConnectThreshold {
    if (config.containsKey(_FeatureToggleKey.residentialEducationConnectThreshold.name)) {
      final raw = config[_FeatureToggleKey.residentialEducationConnectThreshold.name];
      if (raw is int && raw > 0) {
        return raw;
      }
    }
    return 2;
  }

  /// Minimum number of minutes between residential-IP education reminders.
  /// In minutes (not days) so QA can set it to 1–2 minutes in ConfigCat.
  /// Falls back to 30 days when unset.
  @computed
  Duration get residentialReminderInterval {
    if (config.containsKey(_FeatureToggleKey.residentialReminderIntervalMinutes.name)) {
      final raw = config[_FeatureToggleKey.residentialReminderIntervalMinutes.name];
      if (raw is int && raw > 0) {
        return Duration(minutes: raw);
      }
    }
    return const Duration(days: 30);
  }

  /// Tunables for the in-app review/feedback prompt, delivered as a single
  /// JSON value. Falls back to the built-in defaults when unset or malformed.
  @computed
  ReviewPromptConfig get reviewPromptConfig {
    if (config.containsKey(_FeatureToggleKey.reviewPromptConfig.name)) {
      final raw = config[_FeatureToggleKey.reviewPromptConfig.name];
      try {
        final decoded = jsonDecode(raw.toString()) as Map<String, dynamic>;
        return ReviewPromptConfig.fromJson(decoded);
      } catch (e, stack) {
        logger.handle(e, stack);
      }
    }
    return const ReviewPromptConfig();
  }

  @computed
  bool get canShowSubscriptionOnboardingFlow {
    if (config.containsKey(_FeatureToggleKey.canShowSubscriptionOnboardingFlow.name)) {
      return config[_FeatureToggleKey.canShowSubscriptionOnboardingFlow.name] as bool;
    }
    return true;
  }

  @computed
  bool get showApiVersion {
    if (config.containsKey(_FeatureToggleKey.showApiVersion.name)) {
      return config[_FeatureToggleKey.showCitiesAndStates.name] as bool;
    }
    return false;
  }

  @computed
  List<int> get subscriptionFreezeDurationOptions {
    if (config.containsKey(_FeatureToggleKey.subscriptionFreezeDurations.name)) {
      try {
        final raw = config[_FeatureToggleKey.subscriptionFreezeDurations.name];
        final decoded = jsonDecode(raw.toString()) as List;
        return decoded.cast<int>();
      } catch (e, stack) {
        logger.handle(e, stack);
      }
    }
    return [];
  }

  Map<String, String> get asUserProperties =>
      config.map((key, value) => MapEntry(key.toSnakeCase, value.toString()));
}
