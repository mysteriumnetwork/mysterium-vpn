// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'remote_config_store.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$RemoteConfigStore on RemoteConfigStoreBase, Store {
  Computed<bool>? _$isServiceAvailableComputed;

  @override
  bool get isServiceAvailable => (_$isServiceAvailableComputed ??= Computed<bool>(
    () => super.isServiceAvailable,
    name: 'RemoteConfigStoreBase.isServiceAvailable',
  )).value;
  Computed<String>? _$isServiceAvailableMessageComputed;

  @override
  String get isServiceAvailableMessage => (_$isServiceAvailableMessageComputed ??= Computed<String>(
    () => super.isServiceAvailableMessage,
    name: 'RemoteConfigStoreBase.isServiceAvailableMessage',
  )).value;
  Computed<bool>? _$hideDeleteAccountComputed;

  @override
  bool get hideDeleteAccount => (_$hideDeleteAccountComputed ??= Computed<bool>(
    () => super.hideDeleteAccount,
    name: 'RemoteConfigStoreBase.hideDeleteAccount',
  )).value;
  Computed<String>? _$minMacosBuildNumberComputed;

  @override
  String get minMacosBuildNumber => (_$minMacosBuildNumberComputed ??= Computed<String>(
    () => super.minMacosBuildNumber,
    name: 'RemoteConfigStoreBase.minMacosBuildNumber',
  )).value;
  Computed<String>? _$minWindowsStandAloneBuildNumberComputed;

  @override
  String get minWindowsStandAloneBuildNumber =>
      (_$minWindowsStandAloneBuildNumberComputed ??= Computed<String>(
        () => super.minWindowsStandAloneBuildNumber,
        name: 'RemoteConfigStoreBase.minWindowsStandAloneBuildNumber',
      )).value;
  Computed<String>? _$minWindowsBuildNumberComputed;

  @override
  String get minWindowsBuildNumber => (_$minWindowsBuildNumberComputed ??= Computed<String>(
    () => super.minWindowsBuildNumber,
    name: 'RemoteConfigStoreBase.minWindowsBuildNumber',
  )).value;
  Computed<String>? _$minAndroidBuildNumberComputed;

  @override
  String get minAndroidBuildNumber => (_$minAndroidBuildNumberComputed ??= Computed<String>(
    () => super.minAndroidBuildNumber,
    name: 'RemoteConfigStoreBase.minAndroidBuildNumber',
  )).value;
  Computed<String>? _$minIosBuildNumberComputed;

  @override
  String get minIosBuildNumber => (_$minIosBuildNumberComputed ??= Computed<String>(
    () => super.minIosBuildNumber,
    name: 'RemoteConfigStoreBase.minIosBuildNumber',
  )).value;
  Computed<bool>? _$hideMalwareBlockerComputed;

  @override
  bool get hideMalwareBlocker => (_$hideMalwareBlockerComputed ??= Computed<bool>(
    () => super.hideMalwareBlocker,
    name: 'RemoteConfigStoreBase.hideMalwareBlocker',
  )).value;
  Computed<bool>? _$hideNotSafeContentBlockerComputed;

  @override
  bool get hideNotSafeContentBlocker => (_$hideNotSafeContentBlockerComputed ??= Computed<bool>(
    () => super.hideNotSafeContentBlocker,
    name: 'RemoteConfigStoreBase.hideNotSafeContentBlocker',
  )).value;
  Computed<String>? _$malwareBlockerDnsAddressComputed;

  @override
  String get malwareBlockerDnsAddress => (_$malwareBlockerDnsAddressComputed ??= Computed<String>(
    () => super.malwareBlockerDnsAddress,
    name: 'RemoteConfigStoreBase.malwareBlockerDnsAddress',
  )).value;
  Computed<String>? _$notSafeContentBlockerDnsAddressComputed;

  @override
  String get notSafeContentBlockerDnsAddress =>
      (_$notSafeContentBlockerDnsAddressComputed ??= Computed<String>(
        () => super.notSafeContentBlockerDnsAddress,
        name: 'RemoteConfigStoreBase.notSafeContentBlockerDnsAddress',
      )).value;
  Computed<bool>? _$mqttExperimentComputed;

  @override
  bool get mqttExperiment => (_$mqttExperimentComputed ??= Computed<bool>(
    () => super.mqttExperiment,
    name: 'RemoteConfigStoreBase.mqttExperiment',
  )).value;
  Computed<Duration>? _$locationsRefreshIntervalComputed;

  @override
  Duration get locationsRefreshInterval =>
      (_$locationsRefreshIntervalComputed ??= Computed<Duration>(
        () => super.locationsRefreshInterval,
        name: 'RemoteConfigStoreBase.locationsRefreshInterval',
      )).value;
  Computed<String?>? _$sentryDsnComputed;

  @override
  String? get sentryDsn => (_$sentryDsnComputed ??= Computed<String?>(
    () => super.sentryDsn,
    name: 'RemoteConfigStoreBase.sentryDsn',
  )).value;
  Computed<bool>? _$hideResetAppSettingComputed;

  @override
  bool get hideResetAppSetting => (_$hideResetAppSettingComputed ??= Computed<bool>(
    () => super.hideResetAppSetting,
    name: 'RemoteConfigStoreBase.hideResetAppSetting',
  )).value;
  Computed<bool>? _$browseUnauthenticatedComputed;

  @override
  bool get browseUnauthenticated => (_$browseUnauthenticatedComputed ??= Computed<bool>(
    () => super.browseUnauthenticated,
    name: 'RemoteConfigStoreBase.browseUnauthenticated',
  )).value;
  Computed<bool>? _$shouldCheckUdpComputed;

  @override
  bool get shouldCheckUdp => (_$shouldCheckUdpComputed ??= Computed<bool>(
    () => super.shouldCheckUdp,
    name: 'RemoteConfigStoreBase.shouldCheckUdp',
  )).value;
  Computed<String>? _$latestStableAppVersionComputed;

  @override
  String get latestStableAppVersion => (_$latestStableAppVersionComputed ??= Computed<String>(
    () => super.latestStableAppVersion,
    name: 'RemoteConfigStoreBase.latestStableAppVersion',
  )).value;
  Computed<bool>? _$isRateConnectionAvailableComputed;

  @override
  bool get isRateConnectionAvailable => (_$isRateConnectionAvailableComputed ??= Computed<bool>(
    () => super.isRateConnectionAvailable,
    name: 'RemoteConfigStoreBase.isRateConnectionAvailable',
  )).value;
  Computed<Set<String>?>? _$cancelSubscriptionReasonKeysComputed;

  @override
  Set<String>? get cancelSubscriptionReasonKeys =>
      (_$cancelSubscriptionReasonKeysComputed ??= Computed<Set<String>?>(
        () => super.cancelSubscriptionReasonKeys,
        name: 'RemoteConfigStoreBase.cancelSubscriptionReasonKeys',
      )).value;
  Computed<bool>? _$useStoreVersionCheckerComputed;

  @override
  bool get useStoreVersionChecker => (_$useStoreVersionCheckerComputed ??= Computed<bool>(
    () => super.useStoreVersionChecker,
    name: 'RemoteConfigStoreBase.useStoreVersionChecker',
  )).value;
  Computed<bool>? _$enableQaHelpersComputed;

  @override
  bool get enableQaHelpers => (_$enableQaHelpersComputed ??= Computed<bool>(
    () => super.enableQaHelpers,
    name: 'RemoteConfigStoreBase.enableQaHelpers',
  )).value;
  Computed<bool>? _$showCitiesAndStatesComputed;

  @override
  bool get showCitiesAndStates => (_$showCitiesAndStatesComputed ??= Computed<bool>(
    () => super.showCitiesAndStates,
    name: 'RemoteConfigStoreBase.showCitiesAndStates',
  )).value;
  Computed<Set<String>>? _$countriesWithCitiesOnMapComputed;

  @override
  Set<String> get countriesWithCitiesOnMap =>
      (_$countriesWithCitiesOnMapComputed ??= Computed<Set<String>>(
        () => super.countriesWithCitiesOnMap,
        name: 'RemoteConfigStoreBase.countriesWithCitiesOnMap',
      )).value;
  Computed<bool>? _$showUserIntentsComputed;

  @override
  bool get showUserIntents => (_$showUserIntentsComputed ??= Computed<bool>(
    () => super.showUserIntents,
    name: 'RemoteConfigStoreBase.showUserIntents',
  )).value;
  Computed<Set<UserIntent>>? _$userIntentBlacklistComputed;

  @override
  Set<UserIntent> get userIntentBlacklist =>
      (_$userIntentBlacklistComputed ??= Computed<Set<UserIntent>>(
        () => super.userIntentBlacklist,
        name: 'RemoteConfigStoreBase.userIntentBlacklist',
      )).value;
  Computed<Duration>? _$userIntentsRefreshIntervalComputed;

  @override
  Duration get userIntentsRefreshInterval =>
      (_$userIntentsRefreshIntervalComputed ??= Computed<Duration>(
        () => super.userIntentsRefreshInterval,
        name: 'RemoteConfigStoreBase.userIntentsRefreshInterval',
      )).value;
  Computed<int>? _$recentLocationsLimitComputed;

  @override
  int get recentLocationsLimit => (_$recentLocationsLimitComputed ??= Computed<int>(
    () => super.recentLocationsLimit,
    name: 'RemoteConfigStoreBase.recentLocationsLimit',
  )).value;
  Computed<MapConfig>? _$mapConfigComputed;

  @override
  MapConfig get mapConfig => (_$mapConfigComputed ??= Computed<MapConfig>(
    () => super.mapConfig,
    name: 'RemoteConfigStoreBase.mapConfig',
  )).value;
  Computed<bool>? _$subscriptionUpgradeBannerEnabledComputed;

  @override
  bool get subscriptionUpgradeBannerEnabled =>
      (_$subscriptionUpgradeBannerEnabledComputed ??= Computed<bool>(
        () => super.subscriptionUpgradeBannerEnabled,
        name: 'RemoteConfigStoreBase.subscriptionUpgradeBannerEnabled',
      )).value;
  Computed<bool>? _$subscriptionUpgradeAutoDisplayEnabledComputed;

  @override
  bool get subscriptionUpgradeAutoDisplayEnabled =>
      (_$subscriptionUpgradeAutoDisplayEnabledComputed ??= Computed<bool>(
        () => super.subscriptionUpgradeAutoDisplayEnabled,
        name: 'RemoteConfigStoreBase.subscriptionUpgradeAutoDisplayEnabled',
      )).value;
  Computed<String?>? _$limitedTimeOfferIdComputed;

  @override
  String? get limitedTimeOfferId => (_$limitedTimeOfferIdComputed ??= Computed<String?>(
    () => super.limitedTimeOfferId,
    name: 'RemoteConfigStoreBase.limitedTimeOfferId',
  )).value;
  Computed<DateTime?>? _$limitedTimeOfferExpiryDateComputed;

  @override
  DateTime? get limitedTimeOfferExpiryDate =>
      (_$limitedTimeOfferExpiryDateComputed ??= Computed<DateTime?>(
        () => super.limitedTimeOfferExpiryDate,
        name: 'RemoteConfigStoreBase.limitedTimeOfferExpiryDate',
      )).value;
  Computed<String?>? _$limitedTimeOfferImageComputed;

  @override
  String? get limitedTimeOfferImage => (_$limitedTimeOfferImageComputed ??= Computed<String?>(
    () => super.limitedTimeOfferImage,
    name: 'RemoteConfigStoreBase.limitedTimeOfferImage',
  )).value;
  Computed<bool>? _$isProtocolPickerAvailableComputed;

  @override
  bool get isProtocolPickerAvailable => (_$isProtocolPickerAvailableComputed ??= Computed<bool>(
    () => super.isProtocolPickerAvailable,
    name: 'RemoteConfigStoreBase.isProtocolPickerAvailable',
  )).value;
  Computed<List<SubscriptionPlanFeatures>>? _$planFeaturesComputed;

  @override
  List<SubscriptionPlanFeatures> get planFeatures =>
      (_$planFeaturesComputed ??= Computed<List<SubscriptionPlanFeatures>>(
        () => super.planFeatures,
        name: 'RemoteConfigStoreBase.planFeatures',
      )).value;
  Computed<Set<String>>? _$plansBestValueComputed;

  @override
  Set<String> get plansBestValue => (_$plansBestValueComputed ??= Computed<Set<String>>(
    () => super.plansBestValue,
    name: 'RemoteConfigStoreBase.plansBestValue',
  )).value;
  Computed<String>? _$upgradeSubscriptionPageComputed;

  @override
  String get upgradeSubscriptionPage => (_$upgradeSubscriptionPageComputed ??= Computed<String>(
    () => super.upgradeSubscriptionPage,
    name: 'RemoteConfigStoreBase.upgradeSubscriptionPage',
  )).value;
  Computed<String>? _$manageSubscriptionPageComputed;

  @override
  String get manageSubscriptionPage => (_$manageSubscriptionPageComputed ??= Computed<String>(
    () => super.manageSubscriptionPage,
    name: 'RemoteConfigStoreBase.manageSubscriptionPage',
  )).value;
  Computed<PromotionalBanner?>? _$promotionalBannerComputed;

  @override
  PromotionalBanner? get promotionalBanner =>
      (_$promotionalBannerComputed ??= Computed<PromotionalBanner?>(
        () => super.promotionalBanner,
        name: 'RemoteConfigStoreBase.promotionalBanner',
      )).value;
  Computed<int>? _$pushNotifPermissionPromptCooldownComputed;

  @override
  int get pushNotifPermissionPromptCooldown =>
      (_$pushNotifPermissionPromptCooldownComputed ??= Computed<int>(
        () => super.pushNotifPermissionPromptCooldown,
        name: 'RemoteConfigStoreBase.pushNotifPermissionPromptCooldown',
      )).value;
  Computed<Set<String>>? _$gatewaysSupportingUpgradeComputed;

  @override
  Set<String> get gatewaysSupportingUpgrade =>
      (_$gatewaysSupportingUpgradeComputed ??= Computed<Set<String>>(
        () => super.gatewaysSupportingUpgrade,
        name: 'RemoteConfigStoreBase.gatewaysSupportingUpgrade',
      )).value;
  Computed<Uri>? _$checkoutWebRedirectUrlComputed;

  @override
  Uri get checkoutWebRedirectUrl => (_$checkoutWebRedirectUrlComputed ??= Computed<Uri>(
    () => super.checkoutWebRedirectUrl,
    name: 'RemoteConfigStoreBase.checkoutWebRedirectUrl',
  )).value;
  Computed<bool>? _$pricingMonthlyComputed;

  @override
  bool get pricingMonthly => (_$pricingMonthlyComputed ??= Computed<bool>(
    () => super.pricingMonthly,
    name: 'RemoteConfigStoreBase.pricingMonthly',
  )).value;
  Computed<Set<String>>? _$countriesWithStatesComputed;

  @override
  Set<String> get countriesWithStates => (_$countriesWithStatesComputed ??= Computed<Set<String>>(
    () => super.countriesWithStates,
    name: 'RemoteConfigStoreBase.countriesWithStates',
  )).value;
  Computed<bool>? _$hideReedemCodeComputed;

  @override
  bool get hideReedemCode => (_$hideReedemCodeComputed ??= Computed<bool>(
    () => super.hideReedemCode,
    name: 'RemoteConfigStoreBase.hideReedemCode',
  )).value;
  Computed<bool>? _$canShowNoSubsOnboardingFlowComputed;

  @override
  bool get canShowNoSubsOnboardingFlow => (_$canShowNoSubsOnboardingFlowComputed ??= Computed<bool>(
    () => super.canShowNoSubsOnboardingFlow,
    name: 'RemoteConfigStoreBase.canShowNoSubsOnboardingFlow',
  )).value;
  Computed<int>? _$residentialEducationConnectThresholdComputed;

  @override
  int get residentialEducationConnectThreshold =>
      (_$residentialEducationConnectThresholdComputed ??= Computed<int>(
        () => super.residentialEducationConnectThreshold,
        name: 'RemoteConfigStoreBase.residentialEducationConnectThreshold',
      )).value;
  Computed<Duration>? _$residentialReminderIntervalComputed;

  @override
  Duration get residentialReminderInterval =>
      (_$residentialReminderIntervalComputed ??= Computed<Duration>(
        () => super.residentialReminderInterval,
        name: 'RemoteConfigStoreBase.residentialReminderInterval',
      )).value;

  @override
  String toString() {
    return '''
isServiceAvailable: ${isServiceAvailable},
isServiceAvailableMessage: ${isServiceAvailableMessage},
hideDeleteAccount: ${hideDeleteAccount},
minMacosBuildNumber: ${minMacosBuildNumber},
minWindowsStandAloneBuildNumber: ${minWindowsStandAloneBuildNumber},
minWindowsBuildNumber: ${minWindowsBuildNumber},
minAndroidBuildNumber: ${minAndroidBuildNumber},
minIosBuildNumber: ${minIosBuildNumber},
hideMalwareBlocker: ${hideMalwareBlocker},
hideNotSafeContentBlocker: ${hideNotSafeContentBlocker},
malwareBlockerDnsAddress: ${malwareBlockerDnsAddress},
notSafeContentBlockerDnsAddress: ${notSafeContentBlockerDnsAddress},
mqttExperiment: ${mqttExperiment},
locationsRefreshInterval: ${locationsRefreshInterval},
sentryDsn: ${sentryDsn},
hideResetAppSetting: ${hideResetAppSetting},
browseUnauthenticated: ${browseUnauthenticated},
shouldCheckUdp: ${shouldCheckUdp},
latestStableAppVersion: ${latestStableAppVersion},
isRateConnectionAvailable: ${isRateConnectionAvailable},
cancelSubscriptionReasonKeys: ${cancelSubscriptionReasonKeys},
useStoreVersionChecker: ${useStoreVersionChecker},
enableQaHelpers: ${enableQaHelpers},
showCitiesAndStates: ${showCitiesAndStates},
countriesWithCitiesOnMap: ${countriesWithCitiesOnMap},
showUserIntents: ${showUserIntents},
userIntentBlacklist: ${userIntentBlacklist},
userIntentsRefreshInterval: ${userIntentsRefreshInterval},
recentLocationsLimit: ${recentLocationsLimit},
mapConfig: ${mapConfig},
subscriptionUpgradeBannerEnabled: ${subscriptionUpgradeBannerEnabled},
subscriptionUpgradeAutoDisplayEnabled: ${subscriptionUpgradeAutoDisplayEnabled},
limitedTimeOfferId: ${limitedTimeOfferId},
limitedTimeOfferExpiryDate: ${limitedTimeOfferExpiryDate},
limitedTimeOfferImage: ${limitedTimeOfferImage},
isProtocolPickerAvailable: ${isProtocolPickerAvailable},
planFeatures: ${planFeatures},
plansBestValue: ${plansBestValue},
upgradeSubscriptionPage: ${upgradeSubscriptionPage},
manageSubscriptionPage: ${manageSubscriptionPage},
promotionalBanner: ${promotionalBanner},
pushNotifPermissionPromptCooldown: ${pushNotifPermissionPromptCooldown},
gatewaysSupportingUpgrade: ${gatewaysSupportingUpgrade},
checkoutWebRedirectUrl: ${checkoutWebRedirectUrl},
pricingMonthly: ${pricingMonthly},
countriesWithStates: ${countriesWithStates},
hideReedemCode: ${hideReedemCode},
canShowNoSubsOnboardingFlow: ${canShowNoSubsOnboardingFlow},
residentialEducationConnectThreshold: ${residentialEducationConnectThreshold},
residentialReminderInterval: ${residentialReminderInterval}
    ''';
  }
}
