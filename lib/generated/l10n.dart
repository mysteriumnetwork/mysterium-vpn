// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:localizely_sdk/localizely_sdk.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false) ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    if (!Localizely.hasMetadata()) {
      Localizely.setMetadata(_metadata);
    }
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  static final Map<String, List<String>> _metadata = {
    'acceptOfferBtn': [],
    'accessAvailableUntilLbl': [],
    'accessBlockedSitesReason': [],
    'account': [],
    'accountSuccessfullyDeleted': [],
    'activeSubsPaidVia': ['store'],
    'allLocations': [],
    'allowBtn': [],
    'allowNotificationsBtn': [],
    'allowPushNotificationsBtn': [],
    'and': [],
    'appearanceSettingLbl': [],
    'appUpdateAvailableDesc': [],
    'appUpdateAvailableSetting': [],
    'appUpdateAvailableTitle': [],
    'ar': [],
    'austria': [],
    'authenticationFailed': [],
    'back': [],
    'backToSettingsLbl': [],
    'batterySaverLabel': [],
    'berlinLbl': [],
    'billedInTotal': ['amount', 'period'],
    'billedPerMonth': ['amount', 'period'],
    'blockerSettingLbl': [],
    'buttonUpdateApp': [],
    'bypassRestrictionsReason': [],
    'cancelBtn': [],
    'cancelDisconnects': [],
    'cancelDowntimes': [],
    'cancelError7040': [],
    'cancelLatency': [],
    'cancellationDateLbl': [],
    'cancelMissingFeatures': [],
    'cancelSpeed': [],
    'cancelSubscriptionPromptDesc': [],
    'cancelSubscriptionTitle': [],
    'cancelSubscriptionWarningDesc': [],
    'cancelSurveyFeedbackHint': [],
    'cancelSurveyTellUsMoreHint': [],
    'cancelSurveyTitle': [],
    'cancelTooExpensive': [],
    'cancelUnableToAccessBlockedSites': [],
    'cancelUsabilityIssues': [],
    'cancelYourSubsMess': [],
    'checkSubsStatusFailedDesc': [],
    'checkSubsStatusFailedTitle': [],
    'checkSubsStatusTitle': [],
    'checkYourEmail': [],
    'clearSearchBtn': [],
    'closeBtn': [],
    'communicationLbl': [],
    'communicationLblDesktop': [],
    'completeBtn': [],
    'confirm': [],
    'confirmCancellationTitle': [],
    'connect': [],
    'connectBestServer': [],
    'connected': [],
    'connecting': [],
    'connectingToPaymentProcesor': [],
    'connection': [],
    'connectionSettingLbl': [],
    'connectionTimeout': [],
    'connectToLocationBtn': ['location'],
    'consistentSpeedReason': [],
    'consumeLink': [],
    'continueBtn': [],
    'continueCancellationOnWebDesc': [],
    'continueCancellationOnWebTitle': [],
    'continueToCancelBtn': [],
    'continueToWebBtn': [],
    'continueWithApple': [],
    'continueWithEmail': [],
    'continueWithGoogle': [],
    'copyLink': [],
    'couponCodeCopied': ['couponCode'],
    'dark': [],
    'dataCentreComparisonCardItem1': [],
    'dataCentreComparisonCardItem2': [],
    'dataCentreComparisonCardItem3': [],
    'dataCentreComparisonCardLbl': [],
    'dataCentreComparisonCardTitle': [],
    'de': [],
    'deleteAccount': [],
    'deleteAccountQuestion': [],
    'deleteBtn': [],
    'deviceLimitReachedDesc': [],
    'deviceLimitReachedOpenDashboard': [],
    'deviceLimitReachedTitle': [],
    'disconnect': [],
    'disconnected': [],
    'disconnecting': [],
    'discountedPriceLabel': [],
    'dns': [],
    'dnsDesc': [],
    'doneBtn': [],
    'duration': [],
    'email': [],
    'emailIsNotValid': [],
    'emailIsRequired': [],
    'emailNotificationsSetting': [],
    'emailSentTo': ['email'],
    'en': [],
    'es': [],
    'existingSubscriptionDesc': ['email'],
    'existingSubscriptionTitle': [],
    'failedToConnectError': ['errorCode'],
    'failedToSubmitFeedback': [],
    'failedToSubscribe': [],
    'failedToVerifySubs': [],
    'fastLabel': [],
    'featureToggleMinVersionNotSatisfied': [],
    'formValidationError': [],
    'fr': [],
    'france': [],
    'frequentDisconnectsReason': [],
    'fullPriceLabel': [],
    'germany': [],
    'getNewIPAddress': [],
    'getSubscriptionModalDesc': [],
    'getSubscriptionModalTitle': ['plan'],
    'getSubscriptionPlanBtn': ['plan'],
    'gettingIPAddress': [],
    'goBackButton': [],
    'goToLoginBtn': [],
    'helpSupportLbl': [],
    'hi': [],
    'hiddenLbl': [],
    'highLatencyReason': [],
    'highSpeed': [],
    'homeLbl': [],
    'id': [],
    'incorrectLocationReason': [],
    'incorrectMagicLink': [],
    'ipAddressLbl': [],
    'ipPoolLabel': ['count'],
    'ipRefreshExhaustedCity': ['location'],
    'ipRefreshExhaustedCountry': ['location'],
    'ipTypeDataCenter': [],
    'ipTypeDataCenterDisclaimer': [],
    'ipTypeResidential': [],
    'ipTypeResidentialDisclaimer': [],
    'ipTypeResidentialTooltipBody': [],
    'ipTypeResidentialTooltipTitle': [],
    'it': [],
    'italy': [],
    'ja': [],
    'keepSubscriptionBtn': [],
    'killSwitch': [],
    'killSwitchDesc': [],
    'languageSettingLbl': [],
    'light': [],
    'linkCopied': [],
    'linkExpires': [],
    'location': [],
    'locationItemCityCount': ['count'],
    'locationItemNodeCount': ['count'],
    'locationItemStatesCount': ['count'],
    'locationLbl': [],
    'locationsUpdated': ['location'],
    'locationsUpdateFailed': ['location'],
    'locationUnavailableAction': [],
    'locationUnavailableSubtitle': [],
    'locationUnavailableTitle': ['location'],
    'LoggingYouIn': [],
    'loginSessionExpired': [],
    'loginSignupLabel': [],
    'logout': [],
    'logoutConfirmationDesc': [],
    'logoutConfirmationTitle': [],
    'logoutVPNConnectedDesc': [],
    'lowLatencyReason': [],
    'madridLbl': [],
    'malwareLbl': [],
    'manageOnWebBtn': [],
    'marketingConsentPopupDesc': [],
    'marketingConsentPopupTitle': [],
    'month': [],
    'monthly': [],
    'navLocations': [],
    'navMap': [],
    'navProducts': [],
    'nextBilling': ['date'],
    'nextBillingDateLbl': [],
    'no': [],
    'noActiveSubsDesc': [],
    'noEmailApp': [],
    'noLocationsFound': [],
    'noneLbl': [],
    'noServersAvailable': [],
    'noServersAvailableSub': [],
    'noSubscriptionAction': [],
    'noSubscriptionTitle': [],
    'notAvailableMsg': [],
    'notNowBtn': [],
    'notReadyToCancelTitle': [],
    'nsfwLbl': [],
    'onboardingStep1Desc': [],
    'onboardingStep1Title': [],
    'onboardingStep2Desc': [],
    'onboardingStep2Title': [],
    'onboardingStep3Desc': [],
    'onboardingStep3Title': [],
    'openEmailApp': [],
    'openSystemSettingsBtn': [],
    'optional': [],
    'or': [],
    'orSelectCountryManually': [],
    'otherReason': [],
    'pauseDurationRequiredError': [],
    'pauseForMonths': ['count'],
    'pauseSubscriptionBtn': [],
    'pauseSubscriptionInfoDesc': [],
    'pendingTransactionMessage': [],
    'perMonth': [],
    'pl': [],
    'plan_2_years': [],
    'plan_2_years_basic': [],
    'plan_2_years_pro': [],
    'plan_6_months': [],
    'planAlreadyPurchasedMsg': [],
    'plan_monthly': [],
    'plan_monthly_basic': [],
    'plan_monthly_plus': [],
    'plan_monthly_pro': [],
    'plan_yearly': [],
    'plan_yearly_basic': [],
    'plan_yearly_plus': [],
    'plan_yearly_pro': [],
    'poland': [],
    'preferences': [],
    'pricingPlanSeePlansBtn': [],
    'privacyPolicy': [],
    'processingPayment': [],
    'productsActivePlanWebSyncAlert': [],
    'productsAllPlansLbl': [],
    'productsBasicDescription': [],
    'productsDuration1Month': [],
    'productsDuration1Year': [],
    'productsDuration2Year': [],
    'productsExploreSubtitle': [],
    'productsManageSubtitle': [],
    'productsMaxPlanAlert': [],
    'productsNotAvailable': [],
    'productsPlusDescription': [],
    'productsProDescription': [],
    'productsSubscribeWebAlert': [],
    'productsSubscribeWebSubtitle': [],
    'productsTitle': [],
    'protectedLbl': [],
    'protocol': [],
    'protocolLabel': ['protocol', 'label'],
    'protocolPickerSettingDesc': [],
    'protocolPickerSettingTitle': [],
    'pt': [],
    'ptBR': [],
    'pushNotificationsConsentPopupDesc': [],
    'pushNotificationsConsentPopupTitle': [],
    'pushNotificationsSetting': [],
    'pushNotificationsSettingDesc': [],
    'qaToolboxLbl': [],
    'rateConnection': [],
    'rateConnectionDislike': [],
    'rateConnectionLike': [],
    'reactivateSubscriptionAnytimeDesc': [],
    'recentLocations': [],
    'redeemDiscountCode': [],
    'redirectToLoginPage': [],
    'refresh': [],
    'refreshIP': [],
    'refreshIPAddress': [],
    'refreshLocationsTooltip': ['location'],
    'resetAppDesc': [],
    'resetAppDialogContent': [],
    'resetAppDialogTitle': [],
    'resetAppFailed': [],
    'resetAppSuccess': [],
    'resetAppTitle': [],
    'resetBtn': [],
    'residential': [],
    'residentialCentreComparisonCardItem1': [],
    'residentialCentreComparisonCardItem2': [],
    'residentialCentreComparisonCardItem3': [],
    'residentialCentreComparisonCardLbl': [],
    'residentialEducationBlock1Body': [],
    'residentialEducationBlock1Title': [],
    'residentialEducationBlock2Body': [],
    'residentialEducationBlock2Title': [],
    'residentialEducationBlock3Body': [],
    'residentialEducationBlock3Title': [],
    'residentialEducationGotIt': [],
    'residentialEducationSubtitle': [],
    'residentialEducationTitle': [],
    'retryBtn': [],
    'reviewLeaveReviewBtn': [],
    'reviewPositiveTitle': [],
    'reviewSatisfactionTitle': [],
    'searchForLocations': [],
    'seePlansBtn': [],
    'selectEmailApp': [],
    'semiAnnual': [],
    'sendAgain': ['count'],
    'serviceUnavailableError': [],
    'settingManageBtn': [],
    'settings': [],
    'setupTunnerPermissionsDialogDesc': [],
    'setupTunnerPermissionsDialogDisclaimer': [],
    'setupTunnerPermissionsDialogTitle': [],
    'signIn': [],
    'signInAbortedMsg': [],
    'signInBtn': [],
    'signInDisclaimer': [],
    'sixMonths': [],
    'skipBtn': [],
    'somethingWentWrong': [],
    'stableConnectionReason': [],
    'status': [],
    'stayButton': [],
    'stayOnAppBtn': [],
    'submitBtn': [],
    'subscribeOnWebBtn': [],
    'subscriptionActive': [],
    'subscriptionAllPlansBackToPlans': [],
    'subscriptionAllPlansCompareAll': [],
    'subscriptionAllPlansCurrentPlan': [],
    'subscriptionAllPlansPurchase': [],
    'subscriptionAllPlansTabMonth': [],
    'subscriptionAllPlansTabYear': [],
    'subscriptionAllPlansTitle': [],
    'subscriptionAllPlansUpgrade': [],
    'subscriptionCancelledTitle': [],
    'subscriptionOnboardingBoostProtectionDescription': [],
    'subscriptionOnboardingBoostProtectionTitle': [],
    'subscriptionOnboardingCancelTourLabel': [],
    'subscriptionOnboardingConnectDescription': [],
    'subscriptionOnboardingConnectTitle': [],
    'subscriptionOnboardingManagePlanDescription': [],
    'subscriptionOnboardingManagePlanTitle': [],
    'subscriptionOnboardingMapDesktopDescription': [],
    'subscriptionOnboardingMapDesktopTitle': [],
    'subscriptionOnboardingMapMobileDescription': [],
    'subscriptionOnboardingMapMobileTitle': [],
    'subscriptionOnboardingPromptDescription': [],
    'subscriptionOnboardingPromptTitle': [],
    'subscriptionOnboardingSearchDescription': [],
    'subscriptionOnboardingSearchTitle': [],
    'subscriptionOnboardingSetupCompleteDescription': [],
    'subscriptionOnboardingSetupCompleteTitle': [],
    'subscriptionOnboardingStartTourLabel': [],
    'subscriptionOnboardingVPNLocationsDesktopDescription': [],
    'subscriptionOnboardingVPNLocationsMobileDescription': [],
    'subscriptionOnboardingVPNLocationsTitle': [],
    'subscriptionPlanBestValue': [],
    'subscriptionPlanCityLevel': [],
    'subscriptionPlanCityLevelDesc': [],
    'subscriptionPlanDevicesSecured': [],
    'subscriptionPlanDoubleVPN': [],
    'subscriptionPlanDoubleVPNDesc': [],
    'subscriptionPlanMalwareBlocker': [],
    'subscriptionPlanMalwareBlockerDesc': [],
    'subscriptionPlanMoneyBack': [],
    'subscriptionPlanNameBasic': [],
    'subscriptionPlanNamePlus': [],
    'subscriptionPlanNamePro': [],
    'subscriptionPlanPF1Basic': [],
    'subscriptionPlanPF1Plus': [],
    'subscriptionPlanPF2Basic': [],
    'subscriptionPlanPF2Plus': [],
    'subscriptionPlanPF3Basic': [],
    'subscriptionPlanPF3Plus': [],
    'subscriptionPlanPF4Basic': [],
    'subscriptionPlanPF4Plus': [],
    'subscriptionPlanPF5Plus': [],
    'subscriptionPlanPF6Plus': [],
    'subscriptionPlanResidentialIPs': [],
    'subscriptionPlanResidentialIPsDesc': [],
    'subscriptionPlanSavePercent': ['percent'],
    'subscriptionPlanSaveWith': ['percent', 'planId'],
    'subscriptionPlanServers': [],
    'subscriptionPlanSupportedCountries': [],
    'subscriptionPlanWireGuard': [],
    'subscriptionPlanWireGuardDesc': [],
    'subscriptionProcessCanceled': [],
    'subscriptionUpgrade': [],
    'subscriptionUpgradeCTA': ['plan'],
    'subscriptionUpgradeModalDescription': [],
    'subscriptionUpgradeModalTitle': ['plan'],
    'subscriptionUpgradeSeeAllPlans': [],
    'subscriptionVerificationFailed': [],
    'subscripton': [],
    'switchToLocationBtn': ['location'],
    'system': [],
    'takeBackTheInternetLbl': [],
    'termsAndConditions': [],
    'title': [],
    'tokenAlreadyUsed': [],
    'toManyRequestsErrorMsg': [],
    'tooManyConnectionsBannerCTADisconnect': [],
    'tooManyConnectionsBannerCTAReconnect': [],
    'tooManyConnectionsBannerDesc': [],
    'tooManyConnectionsBannerDescConnected': [],
    'tooManyConnectionsBannerTitle': [],
    'topLocations': [],
    'tr': [],
    'tryAgainBtn': [],
    'tryAnotherLocation': [],
    'tunnelPermissionRequired': [],
    'tunnelSetupError': [],
    'typeDelete': ['word'],
    'typeFeedback': [],
    'ukraine': [],
    'unableToConnectToPaymentProcesor': [],
    'unauthenticatedBannerTitle': [],
    'unauthenticatedSettingSubtitle': [],
    'unauthenticatedSettingTitle': [],
    'unprotectedLbl': [],
    'unstableSpeedReason': [],
    'updateBtn': [],
    'userIntentBestSpeed': [],
    'userIntentBestSpeedDesc': [],
    'userIntentLabel': [],
    'userIntentLowLatency': [],
    'userIntentLowLatencyDesc': [],
    'userIntentMaxPrivacy': [],
    'userIntentMaxPrivacyDesc': [],
    'userIntentNearestLocation': [],
    'userIntentNearestLocationDesc': [],
    'userIntentP2P': [],
    'userIntentP2PDesc': [],
    'userIntentStreaming': [],
    'userIntentStreamingDesc': [],
    'viewAllFeaturesBtn': [],
    'viewLessBtn': [],
    'vodafoneLbl': [],
    'vpnProtocolSettingLbl': [],
    'year': [],
    'yearly': [],
    'yes': [],
    'zh': [],
  };

  /// `Accept offer`
  String get acceptOfferBtn {
    return Intl.message('Accept offer', name: 'acceptOfferBtn', desc: '', args: []);
  }

  /// `Access available until:`
  String get accessAvailableUntilLbl {
    return Intl.message(
      'Access available until:',
      name: 'accessAvailableUntilLbl',
      desc: '',
      args: [],
    );
  }

  /// `Unable to access blocked sites`
  String get accessBlockedSitesReason {
    return Intl.message(
      'Unable to access blocked sites',
      name: 'accessBlockedSitesReason',
      desc: '',
      args: [],
    );
  }

  /// `Account`
  String get account {
    return Intl.message('Account', name: 'account', desc: '', args: []);
  }

  /// `Account deleted`
  String get accountSuccessfullyDeleted {
    return Intl.message('Account deleted', name: 'accountSuccessfullyDeleted', desc: '', args: []);
  }

  /// `You already have an active subscription paid via {store}. Manage it in {store}.`
  String activeSubsPaidVia(Object store) {
    return Intl.message(
      'You already have an active subscription paid via $store. Manage it in $store.',
      name: 'activeSubsPaidVia',
      desc: '',
      args: [store],
    );
  }

  /// `All locations`
  String get allLocations {
    return Intl.message('All locations', name: 'allLocations', desc: '', args: []);
  }

  /// `Allow`
  String get allowBtn {
    return Intl.message('Allow', name: 'allowBtn', desc: '', args: []);
  }

  /// `Allow notifications`
  String get allowNotificationsBtn {
    return Intl.message('Allow notifications', name: 'allowNotificationsBtn', desc: '', args: []);
  }

  /// `Allow notifications`
  String get allowPushNotificationsBtn {
    return Intl.message(
      'Allow notifications',
      name: 'allowPushNotificationsBtn',
      desc: '',
      args: [],
    );
  }

  /// ` and `
  String get and {
    return Intl.message(' and ', name: 'and', desc: '', args: []);
  }

  /// `Appearance`
  String get appearanceSettingLbl {
    return Intl.message('Appearance', name: 'appearanceSettingLbl', desc: '', args: []);
  }

  /// `The new app version is here! Update now for the latest features and improvements.`
  String get appUpdateAvailableDesc {
    return Intl.message(
      'The new app version is here! Update now for the latest features and improvements.',
      name: 'appUpdateAvailableDesc',
      desc: '',
      args: [],
    );
  }

  /// `App Update Available!`
  String get appUpdateAvailableSetting {
    return Intl.message(
      'App Update Available!',
      name: 'appUpdateAvailableSetting',
      desc: '',
      args: [],
    );
  }

  /// `App Update Available`
  String get appUpdateAvailableTitle {
    return Intl.message(
      'App Update Available',
      name: 'appUpdateAvailableTitle',
      desc: '',
      args: [],
    );
  }

  /// `Arabic`
  String get ar {
    return Intl.message('Arabic', name: 'ar', desc: '', args: []);
  }

  /// `Austria`
  String get austria {
    return Intl.message('Austria', name: 'austria', desc: '', args: []);
  }

  /// `Unable to sign in. Please try again.`
  String get authenticationFailed {
    return Intl.message(
      'Unable to sign in. Please try again.',
      name: 'authenticationFailed',
      desc: '',
      args: [],
    );
  }

  /// `Back`
  String get back {
    return Intl.message('Back', name: 'back', desc: '', args: []);
  }

  /// `Back to Settings`
  String get backToSettingsLbl {
    return Intl.message('Back to Settings', name: 'backToSettingsLbl', desc: '', args: []);
  }

  /// `Battery saver`
  String get batterySaverLabel {
    return Intl.message('Battery saver', name: 'batterySaverLabel', desc: '', args: []);
  }

  /// `Berlin, Germany 🇩🇪`
  String get berlinLbl {
    return Intl.message('Berlin, Germany 🇩🇪', name: 'berlinLbl', desc: '', args: []);
  }

  /// `{amount} /{period}`
  String billedInTotal(Object amount, Object period) {
    return Intl.message(
      '$amount /$period',
      name: 'billedInTotal',
      desc: '',
      args: [amount, period],
    );
  }

  /// `{amount}/month — Billed {period}`
  String billedPerMonth(Object amount, Object period) {
    return Intl.message(
      '$amount/month — Billed $period',
      name: 'billedPerMonth',
      desc: '',
      args: [amount, period],
    );
  }

  /// `Blocker`
  String get blockerSettingLbl {
    return Intl.message('Blocker', name: 'blockerSettingLbl', desc: '', args: []);
  }

  /// `Update now`
  String get buttonUpdateApp {
    return Intl.message('Update now', name: 'buttonUpdateApp', desc: '', args: []);
  }

  /// `Bypass restrictions`
  String get bypassRestrictionsReason {
    return Intl.message(
      'Bypass restrictions',
      name: 'bypassRestrictionsReason',
      desc: '',
      args: [],
    );
  }

  /// `Cancel`
  String get cancelBtn {
    return Intl.message('Cancel', name: 'cancelBtn', desc: '', args: []);
  }

  /// `Disconnects`
  String get cancelDisconnects {
    return Intl.message('Disconnects', name: 'cancelDisconnects', desc: '', args: []);
  }

  /// `Downtimes`
  String get cancelDowntimes {
    return Intl.message('Downtimes', name: 'cancelDowntimes', desc: '', args: []);
  }

  /// `Error 7040`
  String get cancelError7040 {
    return Intl.message('Error 7040', name: 'cancelError7040', desc: '', args: []);
  }

  /// `Latency`
  String get cancelLatency {
    return Intl.message('Latency', name: 'cancelLatency', desc: '', args: []);
  }

  /// `Cancellation date:`
  String get cancellationDateLbl {
    return Intl.message('Cancellation date:', name: 'cancellationDateLbl', desc: '', args: []);
  }

  /// `Missing features`
  String get cancelMissingFeatures {
    return Intl.message('Missing features', name: 'cancelMissingFeatures', desc: '', args: []);
  }

  /// `Speed`
  String get cancelSpeed {
    return Intl.message('Speed', name: 'cancelSpeed', desc: '', args: []);
  }

  /// `Are you sure you want to cancel your subscription?`
  String get cancelSubscriptionPromptDesc {
    return Intl.message(
      'Are you sure you want to cancel your subscription?',
      name: 'cancelSubscriptionPromptDesc',
      desc: '',
      args: [],
    );
  }

  /// `Cancel subscription`
  String get cancelSubscriptionTitle {
    return Intl.message('Cancel subscription', name: 'cancelSubscriptionTitle', desc: '', args: []);
  }

  /// `Your subscription will be cancelled. You can continue using Mysterium VPN until your access ends.`
  String get cancelSubscriptionWarningDesc {
    return Intl.message(
      'Your subscription will be cancelled. You can continue using Mysterium VPN until your access ends.',
      name: 'cancelSubscriptionWarningDesc',
      desc: '',
      args: [],
    );
  }

  /// `Please enter more details...`
  String get cancelSurveyFeedbackHint {
    return Intl.message(
      'Please enter more details...',
      name: 'cancelSurveyFeedbackHint',
      desc: '',
      args: [],
    );
  }

  /// `Tell us more (optional)`
  String get cancelSurveyTellUsMoreHint {
    return Intl.message(
      'Tell us more (optional)',
      name: 'cancelSurveyTellUsMoreHint',
      desc: '',
      args: [],
    );
  }

  /// `Reasons for cancelling`
  String get cancelSurveyTitle {
    return Intl.message('Reasons for cancelling', name: 'cancelSurveyTitle', desc: '', args: []);
  }

  /// `Too expensive`
  String get cancelTooExpensive {
    return Intl.message('Too expensive', name: 'cancelTooExpensive', desc: '', args: []);
  }

  /// `Unable to access blocked sites`
  String get cancelUnableToAccessBlockedSites {
    return Intl.message(
      'Unable to access blocked sites',
      name: 'cancelUnableToAccessBlockedSites',
      desc: '',
      args: [],
    );
  }

  /// `Usability issues`
  String get cancelUsabilityIssues {
    return Intl.message('Usability issues', name: 'cancelUsabilityIssues', desc: '', args: []);
  }

  /// `Cancel your subscription on the App Store subscriptions before deleting your account.`
  String get cancelYourSubsMess {
    return Intl.message(
      'Cancel your subscription on the App Store subscriptions before deleting your account.',
      name: 'cancelYourSubsMess',
      desc: '',
      args: [],
    );
  }

  /// `We are not able to retrieve your plan information.`
  String get checkSubsStatusFailedDesc {
    return Intl.message(
      'We are not able to retrieve your plan information.',
      name: 'checkSubsStatusFailedDesc',
      desc: '',
      args: [],
    );
  }

  /// `Plan information is not available`
  String get checkSubsStatusFailedTitle {
    return Intl.message(
      'Plan information is not available',
      name: 'checkSubsStatusFailedTitle',
      desc: '',
      args: [],
    );
  }

  /// `Getting plan information...`
  String get checkSubsStatusTitle {
    return Intl.message(
      'Getting plan information...',
      name: 'checkSubsStatusTitle',
      desc: '',
      args: [],
    );
  }

  /// `Check your email`
  String get checkYourEmail {
    return Intl.message('Check your email', name: 'checkYourEmail', desc: '', args: []);
  }

  /// `Clear search`
  String get clearSearchBtn {
    return Intl.message('Clear search', name: 'clearSearchBtn', desc: '', args: []);
  }

  /// `Close`
  String get closeBtn {
    return Intl.message('Close', name: 'closeBtn', desc: '', args: []);
  }

  /// `Communications`
  String get communicationLbl {
    return Intl.message('Communications', name: 'communicationLbl', desc: '', args: []);
  }

  /// `COMMUNICATIONS`
  String get communicationLblDesktop {
    return Intl.message('COMMUNICATIONS', name: 'communicationLblDesktop', desc: '', args: []);
  }

  /// `Complete`
  String get completeBtn {
    return Intl.message('Complete', name: 'completeBtn', desc: '', args: []);
  }

  /// `Confirm`
  String get confirm {
    return Intl.message('Confirm', name: 'confirm', desc: '', args: []);
  }

  /// `Confirm cancellation`
  String get confirmCancellationTitle {
    return Intl.message(
      'Confirm cancellation',
      name: 'confirmCancellationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Connect`
  String get connect {
    return Intl.message('Connect', name: 'connect', desc: '', args: []);
  }

  /// `Best server`
  String get connectBestServer {
    return Intl.message('Best server', name: 'connectBestServer', desc: '', args: []);
  }

  /// `Connected`
  String get connected {
    return Intl.message('Connected', name: 'connected', desc: '', args: []);
  }

  /// `Connecting`
  String get connecting {
    return Intl.message('Connecting', name: 'connecting', desc: '', args: []);
  }

  /// `Connecting to the payment processor...`
  String get connectingToPaymentProcesor {
    return Intl.message(
      'Connecting to the payment processor...',
      name: 'connectingToPaymentProcesor',
      desc: '',
      args: [],
    );
  }

  /// `Connection`
  String get connection {
    return Intl.message('Connection', name: 'connection', desc: '', args: []);
  }

  /// `Connection & Protection`
  String get connectionSettingLbl {
    return Intl.message(
      'Connection & Protection',
      name: 'connectionSettingLbl',
      desc: '',
      args: [],
    );
  }

  /// `Connection timed out. Please try again later. If the problem persists, contact support.`
  String get connectionTimeout {
    return Intl.message(
      'Connection timed out. Please try again later. If the problem persists, contact support.',
      name: 'connectionTimeout',
      desc: '',
      args: [],
    );
  }

  /// `Connect to {location}`
  String connectToLocationBtn(Object location) {
    return Intl.message(
      'Connect to $location',
      name: 'connectToLocationBtn',
      desc: '',
      args: [location],
    );
  }

  /// `Consistent speed`
  String get consistentSpeedReason {
    return Intl.message('Consistent speed', name: 'consistentSpeedReason', desc: '', args: []);
  }

  /// `It only works on the device that requested it - click the link in your email to continue.`
  String get consumeLink {
    return Intl.message(
      'It only works on the device that requested it - click the link in your email to continue.',
      name: 'consumeLink',
      desc: '',
      args: [],
    );
  }

  /// `Continue`
  String get continueBtn {
    return Intl.message('Continue', name: 'continueBtn', desc: '', args: []);
  }

  /// `You'll be redirected to the Mysterium VPN website to complete your cancellation.`
  String get continueCancellationOnWebDesc {
    return Intl.message(
      'You\'ll be redirected to the Mysterium VPN website to complete your cancellation.',
      name: 'continueCancellationOnWebDesc',
      desc: '',
      args: [],
    );
  }

  /// `Continue cancellation on the web`
  String get continueCancellationOnWebTitle {
    return Intl.message(
      'Continue cancellation on the web',
      name: 'continueCancellationOnWebTitle',
      desc: '',
      args: [],
    );
  }

  /// `Continue to cancel`
  String get continueToCancelBtn {
    return Intl.message('Continue to cancel', name: 'continueToCancelBtn', desc: '', args: []);
  }

  /// `Continue to website`
  String get continueToWebBtn {
    return Intl.message('Continue to website', name: 'continueToWebBtn', desc: '', args: []);
  }

  /// `Continue with Apple`
  String get continueWithApple {
    return Intl.message('Continue with Apple', name: 'continueWithApple', desc: '', args: []);
  }

  /// `Continue with Email`
  String get continueWithEmail {
    return Intl.message('Continue with Email', name: 'continueWithEmail', desc: '', args: []);
  }

  /// `Continue with Google`
  String get continueWithGoogle {
    return Intl.message('Continue with Google', name: 'continueWithGoogle', desc: '', args: []);
  }

  /// `Copy the link and paste it into your browser`
  String get copyLink {
    return Intl.message(
      'Copy the link and paste it into your browser',
      name: 'copyLink',
      desc: '',
      args: [],
    );
  }

  /// `{couponCode} copied to clipboard!`
  String couponCodeCopied(Object couponCode) {
    return Intl.message(
      '$couponCode copied to clipboard!',
      name: 'couponCodeCopied',
      desc: '',
      args: [couponCode],
    );
  }

  /// `Dark`
  String get dark {
    return Intl.message('Dark', name: 'dark', desc: '', args: []);
  }

  /// `Easily detectable`
  String get dataCentreComparisonCardItem1 {
    return Intl.message(
      'Easily detectable',
      name: 'dataCentreComparisonCardItem1',
      desc: '',
      args: [],
    );
  }

  /// `Often blocked by websites`
  String get dataCentreComparisonCardItem2 {
    return Intl.message(
      'Often blocked by websites',
      name: 'dataCentreComparisonCardItem2',
      desc: '',
      args: [],
    );
  }

  /// `Less private`
  String get dataCentreComparisonCardItem3 {
    return Intl.message('Less private', name: 'dataCentreComparisonCardItem3', desc: '', args: []);
  }

  /// `DATA CENTRE IPS`
  String get dataCentreComparisonCardLbl {
    return Intl.message('DATA CENTRE IPS', name: 'dataCentreComparisonCardLbl', desc: '', args: []);
  }

  /// `Most VPNs`
  String get dataCentreComparisonCardTitle {
    return Intl.message('Most VPNs', name: 'dataCentreComparisonCardTitle', desc: '', args: []);
  }

  /// `German`
  String get de {
    return Intl.message('German', name: 'de', desc: '', args: []);
  }

  /// `Delete account`
  String get deleteAccount {
    return Intl.message('Delete account', name: 'deleteAccount', desc: '', args: []);
  }

  /// `Delete Account?`
  String get deleteAccountQuestion {
    return Intl.message('Delete Account?', name: 'deleteAccountQuestion', desc: '', args: []);
  }

  /// `Delete`
  String get deleteBtn {
    return Intl.message('Delete', name: 'deleteBtn', desc: '', args: []);
  }

  /// `You have reached the maximum number of connected devices. To add a new device, remove an existing one from your account.`
  String get deviceLimitReachedDesc {
    return Intl.message(
      'You have reached the maximum number of connected devices. To add a new device, remove an existing one from your account.',
      name: 'deviceLimitReachedDesc',
      desc: '',
      args: [],
    );
  }

  /// `Open Dashboard`
  String get deviceLimitReachedOpenDashboard {
    return Intl.message(
      'Open Dashboard',
      name: 'deviceLimitReachedOpenDashboard',
      desc: '',
      args: [],
    );
  }

  /// `Device Limit Reached`
  String get deviceLimitReachedTitle {
    return Intl.message(
      'Device Limit Reached',
      name: 'deviceLimitReachedTitle',
      desc: '',
      args: [],
    );
  }

  /// `Disconnect`
  String get disconnect {
    return Intl.message('Disconnect', name: 'disconnect', desc: '', args: []);
  }

  /// `Disconnected`
  String get disconnected {
    return Intl.message('Disconnected', name: 'disconnected', desc: '', args: []);
  }

  /// `Disconnecting`
  String get disconnecting {
    return Intl.message('Disconnecting', name: 'disconnecting', desc: '', args: []);
  }

  /// `Only`
  String get discountedPriceLabel {
    return Intl.message('Only', name: 'discountedPriceLabel', desc: '', args: []);
  }

  /// `DNS protection`
  String get dns {
    return Intl.message('DNS protection', name: 'dns', desc: '', args: []);
  }

  /// `Prevents DNS leaks`
  String get dnsDesc {
    return Intl.message('Prevents DNS leaks', name: 'dnsDesc', desc: '', args: []);
  }

  /// `Done`
  String get doneBtn {
    return Intl.message('Done', name: 'doneBtn', desc: '', args: []);
  }

  /// `Duration`
  String get duration {
    return Intl.message('Duration', name: 'duration', desc: '', args: []);
  }

  /// `Email address`
  String get email {
    return Intl.message('Email address', name: 'email', desc: '', args: []);
  }

  /// `Email address is not valid`
  String get emailIsNotValid {
    return Intl.message('Email address is not valid', name: 'emailIsNotValid', desc: '', args: []);
  }

  /// `Email address is required`
  String get emailIsRequired {
    return Intl.message('Email address is required', name: 'emailIsRequired', desc: '', args: []);
  }

  /// `Email Notifications`
  String get emailNotificationsSetting {
    return Intl.message(
      'Email Notifications',
      name: 'emailNotificationsSetting',
      desc: '',
      args: [],
    );
  }

  /// `We sent an email to {email}`
  String emailSentTo(Object email) {
    return Intl.message('We sent an email to $email', name: 'emailSentTo', desc: '', args: [email]);
  }

  /// `English`
  String get en {
    return Intl.message('English', name: 'en', desc: '', args: []);
  }

  /// `Spanish`
  String get es {
    return Intl.message('Spanish', name: 'es', desc: '', args: []);
  }

  /// `You may already have a paid subscription with “{email}”`
  String existingSubscriptionDesc(Object email) {
    return Intl.message(
      'You may already have a paid subscription with “$email”',
      name: 'existingSubscriptionDesc',
      desc: '',
      args: [email],
    );
  }

  /// `You can logout and try with your email or ignore this warning`
  String get existingSubscriptionTitle {
    return Intl.message(
      'You can logout and try with your email or ignore this warning',
      name: 'existingSubscriptionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Failed to connect. Please try again [error: {errorCode}]`
  String failedToConnectError(Object errorCode) {
    return Intl.message(
      'Failed to connect. Please try again [error: $errorCode]',
      name: 'failedToConnectError',
      desc: '',
      args: [errorCode],
    );
  }

  /// `Failed to submit feedback. Please try again.`
  String get failedToSubmitFeedback {
    return Intl.message(
      'Failed to submit feedback. Please try again.',
      name: 'failedToSubmitFeedback',
      desc: '',
      args: [],
    );
  }

  /// `Something went wrong with your subscription. Please try again!`
  String get failedToSubscribe {
    return Intl.message(
      'Something went wrong with your subscription. Please try again!',
      name: 'failedToSubscribe',
      desc: '',
      args: [],
    );
  }

  /// `We couldn't verify your last subscription purchase. Click the button below to retry verification.`
  String get failedToVerifySubs {
    return Intl.message(
      'We couldn\'t verify your last subscription purchase. Click the button below to retry verification.',
      name: 'failedToVerifySubs',
      desc: '',
      args: [],
    );
  }

  /// `Fast`
  String get fastLabel {
    return Intl.message('Fast', name: 'fastLabel', desc: '', args: []);
  }

  /// `Your app version is outdated. Please update the app to continue using it.`
  String get featureToggleMinVersionNotSatisfied {
    return Intl.message(
      'Your app version is outdated. Please update the app to continue using it.',
      name: 'featureToggleMinVersionNotSatisfied',
      desc: '',
      args: [],
    );
  }

  /// `Invalid form data. Please check the fields and try again.`
  String get formValidationError {
    return Intl.message(
      'Invalid form data. Please check the fields and try again.',
      name: 'formValidationError',
      desc: '',
      args: [],
    );
  }

  /// `French`
  String get fr {
    return Intl.message('French', name: 'fr', desc: '', args: []);
  }

  /// `France`
  String get france {
    return Intl.message('France', name: 'france', desc: '', args: []);
  }

  /// `Frequent disconnects`
  String get frequentDisconnectsReason {
    return Intl.message(
      'Frequent disconnects',
      name: 'frequentDisconnectsReason',
      desc: '',
      args: [],
    );
  }

  /// `Full price:`
  String get fullPriceLabel {
    return Intl.message('Full price:', name: 'fullPriceLabel', desc: '', args: []);
  }

  /// `Germany`
  String get germany {
    return Intl.message('Germany', name: 'germany', desc: '', args: []);
  }

  /// `Get a new IP address on refresh`
  String get getNewIPAddress {
    return Intl.message(
      'Get a new IP address on refresh',
      name: 'getNewIPAddress',
      desc: '',
      args: [],
    );
  }

  /// `Secure your connection and enjoy private browsing instantly`
  String get getSubscriptionModalDesc {
    return Intl.message(
      'Secure your connection and enjoy private browsing instantly',
      name: 'getSubscriptionModalDesc',
      desc: '',
      args: [],
    );
  }

  /// `Get {plan}`
  String getSubscriptionModalTitle(Object plan) {
    return Intl.message('Get $plan', name: 'getSubscriptionModalTitle', desc: '', args: [plan]);
  }

  /// `Get {plan} plan`
  String getSubscriptionPlanBtn(Object plan) {
    return Intl.message('Get $plan plan', name: 'getSubscriptionPlanBtn', desc: '', args: [plan]);
  }

  /// `Getting IP address...`
  String get gettingIPAddress {
    return Intl.message('Getting IP address...', name: 'gettingIPAddress', desc: '', args: []);
  }

  /// `Go Back`
  String get goBackButton {
    return Intl.message('Go Back', name: 'goBackButton', desc: '', args: []);
  }

  /// `Go to log in`
  String get goToLoginBtn {
    return Intl.message('Go to log in', name: 'goToLoginBtn', desc: '', args: []);
  }

  /// `Help & Support`
  String get helpSupportLbl {
    return Intl.message('Help & Support', name: 'helpSupportLbl', desc: '', args: []);
  }

  /// `Hindi`
  String get hi {
    return Intl.message('Hindi', name: 'hi', desc: '', args: []);
  }

  /// `Hidden`
  String get hiddenLbl {
    return Intl.message('Hidden', name: 'hiddenLbl', desc: '', args: []);
  }

  /// `High latency`
  String get highLatencyReason {
    return Intl.message('High latency', name: 'highLatencyReason', desc: '', args: []);
  }

  /// `Datacenter`
  String get highSpeed {
    return Intl.message('Datacenter', name: 'highSpeed', desc: '', args: []);
  }

  /// `Home`
  String get homeLbl {
    return Intl.message('Home', name: 'homeLbl', desc: '', args: []);
  }

  /// `Indonesian`
  String get id {
    return Intl.message('Indonesian', name: 'id', desc: '', args: []);
  }

  /// `Incorrect location`
  String get incorrectLocationReason {
    return Intl.message('Incorrect location', name: 'incorrectLocationReason', desc: '', args: []);
  }

  /// `Incorrect magic link. Please try again.`
  String get incorrectMagicLink {
    return Intl.message(
      'Incorrect magic link. Please try again.',
      name: 'incorrectMagicLink',
      desc: '',
      args: [],
    );
  }

  /// `IP address`
  String get ipAddressLbl {
    return Intl.message('IP address', name: 'ipAddressLbl', desc: '', args: []);
  }

  /// `IP pool: {count}`
  String ipPoolLabel(Object count) {
    return Intl.message('IP pool: $count', name: 'ipPoolLabel', desc: '', args: [count]);
  }

  /// `No alternative IPs are available in {location}. Choose another country or city to get a different IP next time.`
  String ipRefreshExhaustedCity(Object location) {
    return Intl.message(
      'No alternative IPs are available in $location. Choose another country or city to get a different IP next time.',
      name: 'ipRefreshExhaustedCity',
      desc: '',
      args: [location],
    );
  }

  /// `No alternative IPs are available in {location}. Choose another country to get a different IP next time.`
  String ipRefreshExhaustedCountry(Object location) {
    return Intl.message(
      'No alternative IPs are available in $location. Choose another country to get a different IP next time.',
      name: 'ipRefreshExhaustedCountry',
      desc: '',
      args: [location],
    );
  }

  /// `Datacenter IPs`
  String get ipTypeDataCenter {
    return Intl.message('Datacenter IPs', name: 'ipTypeDataCenter', desc: '', args: []);
  }

  /// `Datacenter IPs optimised for speed and performance.`
  String get ipTypeDataCenterDisclaimer {
    return Intl.message(
      'Datacenter IPs optimised for speed and performance.',
      name: 'ipTypeDataCenterDisclaimer',
      desc: '',
      args: [],
    );
  }

  /// `Residential IPs`
  String get ipTypeResidential {
    return Intl.message('Residential IPs', name: 'ipTypeResidential', desc: '', args: []);
  }

  /// `Provided by real households. Nearly undetectable but less stable.`
  String get ipTypeResidentialDisclaimer {
    return Intl.message(
      'Provided by real households. Nearly undetectable but less stable.',
      name: 'ipTypeResidentialDisclaimer',
      desc: '',
      args: [],
    );
  }

  /// `Residential IPs are provided by real household devices, so availability can change over time.\n\nIf a node goes offline, the app reconnects you to the nearest available residential IP.`
  String get ipTypeResidentialTooltipBody {
    return Intl.message(
      'Residential IPs are provided by real household devices, so availability can change over time.\n\nIf a node goes offline, the app reconnects you to the nearest available residential IP.',
      name: 'ipTypeResidentialTooltipBody',
      desc: '',
      args: [],
    );
  }

  /// `Why can my IP change?`
  String get ipTypeResidentialTooltipTitle {
    return Intl.message(
      'Why can my IP change?',
      name: 'ipTypeResidentialTooltipTitle',
      desc: '',
      args: [],
    );
  }

  /// `Italian`
  String get it {
    return Intl.message('Italian', name: 'it', desc: '', args: []);
  }

  /// `Italy`
  String get italy {
    return Intl.message('Italy', name: 'italy', desc: '', args: []);
  }

  /// `Japanese`
  String get ja {
    return Intl.message('Japanese', name: 'ja', desc: '', args: []);
  }

  /// `Keep subscription`
  String get keepSubscriptionBtn {
    return Intl.message('Keep subscription', name: 'keepSubscriptionBtn', desc: '', args: []);
  }

  /// `Kill switch`
  String get killSwitch {
    return Intl.message('Kill switch', name: 'killSwitch', desc: '', args: []);
  }

  /// `Blocks internet traffic if the VPN connection drops`
  String get killSwitchDesc {
    return Intl.message(
      'Blocks internet traffic if the VPN connection drops',
      name: 'killSwitchDesc',
      desc: '',
      args: [],
    );
  }

  /// `Language`
  String get languageSettingLbl {
    return Intl.message('Language', name: 'languageSettingLbl', desc: '', args: []);
  }

  /// `Light`
  String get light {
    return Intl.message('Light', name: 'light', desc: '', args: []);
  }

  /// `Link copied to clipboard!`
  String get linkCopied {
    return Intl.message('Link copied to clipboard!', name: 'linkCopied', desc: '', args: []);
  }

  /// `The link expires in 30 minutes and can be used only once.`
  String get linkExpires {
    return Intl.message(
      'The link expires in 30 minutes and can be used only once.',
      name: 'linkExpires',
      desc: '',
      args: [],
    );
  }

  /// `Location`
  String get location {
    return Intl.message('Location', name: 'location', desc: '', args: []);
  }

  /// `{count, plural, one{{count} City} other{{count} Cities}}`
  String locationItemCityCount(num count) {
    return Intl.plural(
      count,
      one: '$count City',
      other: '$count Cities',
      name: 'locationItemCityCount',
      desc: '',
      args: [count],
    );
  }

  /// `{count, plural, one{{count} IP} other{{count} IPs}}`
  String locationItemNodeCount(num count) {
    return Intl.plural(
      count,
      one: '$count IP',
      other: '$count IPs',
      name: 'locationItemNodeCount',
      desc: '',
      args: [count],
    );
  }

  /// `{count, plural, one{{count} State} other{{count} States}}`
  String locationItemStatesCount(num count) {
    return Intl.plural(
      count,
      one: '$count State',
      other: '$count States',
      name: 'locationItemStatesCount',
      desc: '',
      args: [count],
    );
  }

  /// `Location`
  String get locationLbl {
    return Intl.message('Location', name: 'locationLbl', desc: '', args: []);
  }

  /// `{location} updated`
  String locationsUpdated(Object location) {
    return Intl.message('$location updated', name: 'locationsUpdated', desc: '', args: [location]);
  }

  /// `Couldn’t update {location}`
  String locationsUpdateFailed(Object location) {
    return Intl.message(
      'Couldn’t update $location',
      name: 'locationsUpdateFailed',
      desc: '',
      args: [location],
    );
  }

  /// `Connect to nearest IP`
  String get locationUnavailableAction {
    return Intl.message(
      'Connect to nearest IP',
      name: 'locationUnavailableAction',
      desc: '',
      args: [],
    );
  }

  /// `Connect to the nearest IP - or choose it manually`
  String get locationUnavailableSubtitle {
    return Intl.message(
      'Connect to the nearest IP - or choose it manually',
      name: 'locationUnavailableSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `{location} is not available`
  String locationUnavailableTitle(Object location) {
    return Intl.message(
      '$location is not available',
      name: 'locationUnavailableTitle',
      desc: '',
      args: [location],
    );
  }

  /// `Logging you in...`
  String get LoggingYouIn {
    return Intl.message('Logging you in...', name: 'LoggingYouIn', desc: '', args: []);
  }

  /// `Your session has expired. Please log in again.`
  String get loginSessionExpired {
    return Intl.message(
      'Your session has expired. Please log in again.',
      name: 'loginSessionExpired',
      desc: '',
      args: [],
    );
  }

  /// `Log in or sign up`
  String get loginSignupLabel {
    return Intl.message('Log in or sign up', name: 'loginSignupLabel', desc: '', args: []);
  }

  /// `Log out`
  String get logout {
    return Intl.message('Log out', name: 'logout', desc: '', args: []);
  }

  /// `You’re about to log out. Are you sure?`
  String get logoutConfirmationDesc {
    return Intl.message(
      'You’re about to log out. Are you sure?',
      name: 'logoutConfirmationDesc',
      desc: '',
      args: [],
    );
  }

  /// `Log out`
  String get logoutConfirmationTitle {
    return Intl.message('Log out', name: 'logoutConfirmationTitle', desc: '', args: []);
  }

  /// `VPN is on. You will be disconnected from the VPN server if you continue to log out.`
  String get logoutVPNConnectedDesc {
    return Intl.message(
      'VPN is on. You will be disconnected from the VPN server if you continue to log out.',
      name: 'logoutVPNConnectedDesc',
      desc: '',
      args: [],
    );
  }

  /// `Low latency`
  String get lowLatencyReason {
    return Intl.message('Low latency', name: 'lowLatencyReason', desc: '', args: []);
  }

  /// `Madrid, Spain 🇪🇸`
  String get madridLbl {
    return Intl.message('Madrid, Spain 🇪🇸', name: 'madridLbl', desc: '', args: []);
  }

  /// `Malware`
  String get malwareLbl {
    return Intl.message('Malware', name: 'malwareLbl', desc: '', args: []);
  }

  /// `Manage on the web`
  String get manageOnWebBtn {
    return Intl.message('Manage on the web', name: 'manageOnWebBtn', desc: '', args: []);
  }

  /// `Would you like to receive email updates, privacy tips, and special offers from Mysterium Network?`
  String get marketingConsentPopupDesc {
    return Intl.message(
      'Would you like to receive email updates, privacy tips, and special offers from Mysterium Network?',
      name: 'marketingConsentPopupDesc',
      desc: '',
      args: [],
    );
  }

  /// `Stay updated by email`
  String get marketingConsentPopupTitle {
    return Intl.message(
      'Stay updated by email',
      name: 'marketingConsentPopupTitle',
      desc: '',
      args: [],
    );
  }

  /// `month`
  String get month {
    return Intl.message('month', name: 'month', desc: '', args: []);
  }

  /// `monthly`
  String get monthly {
    return Intl.message('monthly', name: 'monthly', desc: '', args: []);
  }

  /// `Locations`
  String get navLocations {
    return Intl.message('Locations', name: 'navLocations', desc: '', args: []);
  }

  /// `Map`
  String get navMap {
    return Intl.message('Map', name: 'navMap', desc: '', args: []);
  }

  /// `Products`
  String get navProducts {
    return Intl.message('Products', name: 'navProducts', desc: '', args: []);
  }

  /// `Next Billing: {date}`
  String nextBilling(Object date) {
    return Intl.message('Next Billing: $date', name: 'nextBilling', desc: '', args: [date]);
  }

  /// `Next billing date:`
  String get nextBillingDateLbl {
    return Intl.message('Next billing date:', name: 'nextBillingDateLbl', desc: '', args: []);
  }

  /// `No`
  String get no {
    return Intl.message('No', name: 'no', desc: '', args: []);
  }

  /// `You have no active subscription`
  String get noActiveSubsDesc {
    return Intl.message(
      'You have no active subscription',
      name: 'noActiveSubsDesc',
      desc: '',
      args: [],
    );
  }

  /// `There are no email apps on your device.`
  String get noEmailApp {
    return Intl.message(
      'There are no email apps on your device.',
      name: 'noEmailApp',
      desc: '',
      args: [],
    );
  }

  /// `No locations found`
  String get noLocationsFound {
    return Intl.message('No locations found', name: 'noLocationsFound', desc: '', args: []);
  }

  /// `None`
  String get noneLbl {
    return Intl.message('None', name: 'noneLbl', desc: '', args: []);
  }

  /// `No servers are available`
  String get noServersAvailable {
    return Intl.message('No servers are available', name: 'noServersAvailable', desc: '', args: []);
  }

  /// `There is connectivity issue and no servers are available. Please try later.`
  String get noServersAvailableSub {
    return Intl.message(
      'There is connectivity issue and no servers are available. Please try later.',
      name: 'noServersAvailableSub',
      desc: '',
      args: [],
    );
  }

  /// `Get plan`
  String get noSubscriptionAction {
    return Intl.message('Get plan', name: 'noSubscriptionAction', desc: '', args: []);
  }

  /// `No active plan available`
  String get noSubscriptionTitle {
    return Intl.message(
      'No active plan available',
      name: 'noSubscriptionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Not available`
  String get notAvailableMsg {
    return Intl.message('Not available', name: 'notAvailableMsg', desc: '', args: []);
  }

  /// `Not now`
  String get notNowBtn {
    return Intl.message('Not now', name: 'notNowBtn', desc: '', args: []);
  }

  /// `Not ready to cancel?`
  String get notReadyToCancelTitle {
    return Intl.message('Not ready to cancel?', name: 'notReadyToCancelTitle', desc: '', args: []);
  }

  /// `NSFW & Malware`
  String get nsfwLbl {
    return Intl.message('NSFW & Malware', name: 'nsfwLbl', desc: '', args: []);
  }

  /// `Your IP and location are visible to websites, trackers and public Wi-Fi networks.`
  String get onboardingStep1Desc {
    return Intl.message(
      'Your IP and location are visible to websites, trackers and public Wi-Fi networks.',
      name: 'onboardingStep1Desc',
      desc: '',
      args: [],
    );
  }

  /// `Your connection is exposed`
  String get onboardingStep1Title {
    return Intl.message(
      'Your connection is exposed',
      name: 'onboardingStep1Title',
      desc: '',
      args: [],
    );
  }

  /// `Mysterium VPN masks your IP, ISP and location so you can browse with real privacy.`
  String get onboardingStep2Desc {
    return Intl.message(
      'Mysterium VPN masks your IP, ISP and location so you can browse with real privacy.',
      name: 'onboardingStep2Desc',
      desc: '',
      args: [],
    );
  }

  /// `Hide your real identity in one tap`
  String get onboardingStep2Title {
    return Intl.message(
      'Hide your real identity in one tap',
      name: 'onboardingStep2Title',
      desc: '',
      args: [],
    );
  }

  /// `With residential IPs, your connection looks natural - not like typical VPN traffic.`
  String get onboardingStep3Desc {
    return Intl.message(
      'With residential IPs, your connection looks natural - not like typical VPN traffic.',
      name: 'onboardingStep3Desc',
      desc: '',
      args: [],
    );
  }

  /// `Not all VPNs work the same`
  String get onboardingStep3Title {
    return Intl.message(
      'Not all VPNs work the same',
      name: 'onboardingStep3Title',
      desc: '',
      args: [],
    );
  }

  /// `Open email app`
  String get openEmailApp {
    return Intl.message('Open email app', name: 'openEmailApp', desc: '', args: []);
  }

  /// `Open system settings`
  String get openSystemSettingsBtn {
    return Intl.message('Open system settings', name: 'openSystemSettingsBtn', desc: '', args: []);
  }

  /// `optional`
  String get optional {
    return Intl.message('optional', name: 'optional', desc: '', args: []);
  }

  /// `OR`
  String get or {
    return Intl.message('OR', name: 'or', desc: '', args: []);
  }

  /// `We'll connect you to the best server - or you can manually select a country.`
  String get orSelectCountryManually {
    return Intl.message(
      'We\'ll connect you to the best server - or you can manually select a country.',
      name: 'orSelectCountryManually',
      desc: '',
      args: [],
    );
  }

  /// `Other...`
  String get otherReason {
    return Intl.message('Other...', name: 'otherReason', desc: '', args: []);
  }

  /// `Please select one of the pause durations.`
  String get pauseDurationRequiredError {
    return Intl.message(
      'Please select one of the pause durations.',
      name: 'pauseDurationRequiredError',
      desc: '',
      args: [],
    );
  }

  /// `{count, plural, zero{} one{Pause for {count} month} other{Pause for {count} months}}`
  String pauseForMonths(num count) {
    return Intl.plural(
      count,
      zero: '',
      one: 'Pause for $count month',
      other: 'Pause for $count months',
      name: 'pauseForMonths',
      desc: '',
      args: [count],
    );
  }

  /// `Pause subscription`
  String get pauseSubscriptionBtn {
    return Intl.message('Pause subscription', name: 'pauseSubscriptionBtn', desc: '', args: []);
  }

  /// `You can pause your plan once per billing cycle.`
  String get pauseSubscriptionInfoDesc {
    return Intl.message(
      'You can pause your plan once per billing cycle.',
      name: 'pauseSubscriptionInfoDesc',
      desc: '',
      args: [],
    );
  }

  /// `You already have an ongoing payment transaction. Please complete it before starting a new one.`
  String get pendingTransactionMessage {
    return Intl.message(
      'You already have an ongoing payment transaction. Please complete it before starting a new one.',
      name: 'pendingTransactionMessage',
      desc: '',
      args: [],
    );
  }

  /// `mo`
  String get perMonth {
    return Intl.message('mo', name: 'perMonth', desc: '', args: []);
  }

  /// `Polish`
  String get pl {
    return Intl.message('Polish', name: 'pl', desc: '', args: []);
  }

  /// `2-Year Plan`
  String get plan_2_years {
    return Intl.message('2-Year Plan', name: 'plan_2_years', desc: '', args: []);
  }

  /// `Basic 2-Year`
  String get plan_2_years_basic {
    return Intl.message('Basic 2-Year', name: 'plan_2_years_basic', desc: '', args: []);
  }

  /// `Pro 2-Year`
  String get plan_2_years_pro {
    return Intl.message('Pro 2-Year', name: 'plan_2_years_pro', desc: '', args: []);
  }

  /// `6-Month Plan`
  String get plan_6_months {
    return Intl.message('6-Month Plan', name: 'plan_6_months', desc: '', args: []);
  }

  /// `You're all set! You already have this plan active.`
  String get planAlreadyPurchasedMsg {
    return Intl.message(
      'You\'re all set! You already have this plan active.',
      name: 'planAlreadyPurchasedMsg',
      desc: '',
      args: [],
    );
  }

  /// `Monthly Plan`
  String get plan_monthly {
    return Intl.message('Monthly Plan', name: 'plan_monthly', desc: '', args: []);
  }

  /// `Basic monthly`
  String get plan_monthly_basic {
    return Intl.message('Basic monthly', name: 'plan_monthly_basic', desc: '', args: []);
  }

  /// `Plus monthly`
  String get plan_monthly_plus {
    return Intl.message('Plus monthly', name: 'plan_monthly_plus', desc: '', args: []);
  }

  /// `Pro monthly`
  String get plan_monthly_pro {
    return Intl.message('Pro monthly', name: 'plan_monthly_pro', desc: '', args: []);
  }

  /// `Annual Plan`
  String get plan_yearly {
    return Intl.message('Annual Plan', name: 'plan_yearly', desc: '', args: []);
  }

  /// `Basic annual`
  String get plan_yearly_basic {
    return Intl.message('Basic annual', name: 'plan_yearly_basic', desc: '', args: []);
  }

  /// `Plus annual`
  String get plan_yearly_plus {
    return Intl.message('Plus annual', name: 'plan_yearly_plus', desc: '', args: []);
  }

  /// `Pro annual`
  String get plan_yearly_pro {
    return Intl.message('Pro annual', name: 'plan_yearly_pro', desc: '', args: []);
  }

  /// `Poland`
  String get poland {
    return Intl.message('Poland', name: 'poland', desc: '', args: []);
  }

  /// `Preferences`
  String get preferences {
    return Intl.message('Preferences', name: 'preferences', desc: '', args: []);
  }

  /// `See all plans`
  String get pricingPlanSeePlansBtn {
    return Intl.message('See all plans', name: 'pricingPlanSeePlansBtn', desc: '', args: []);
  }

  /// `Privacy Policy`
  String get privacyPolicy {
    return Intl.message('Privacy Policy', name: 'privacyPolicy', desc: '', args: []);
  }

  /// `We’re processing your payment. You’ll be all set shortly…`
  String get processingPayment {
    return Intl.message(
      'We’re processing your payment. You’ll be all set shortly…',
      name: 'processingPayment',
      desc: '',
      args: [],
    );
  }

  /// `You already have an active plan. Upgrade on the web — changes sync automatically.`
  String get productsActivePlanWebSyncAlert {
    return Intl.message(
      'You already have an active plan. Upgrade on the web — changes sync automatically.',
      name: 'productsActivePlanWebSyncAlert',
      desc: '',
      args: [],
    );
  }

  /// `All plans:`
  String get productsAllPlansLbl {
    return Intl.message('All plans:', name: 'productsAllPlansLbl', desc: '', args: []);
  }

  /// `Essentials for everyday privacy`
  String get productsBasicDescription {
    return Intl.message(
      'Essentials for everyday privacy',
      name: 'productsBasicDescription',
      desc: '',
      args: [],
    );
  }

  /// `1 month`
  String get productsDuration1Month {
    return Intl.message('1 month', name: 'productsDuration1Month', desc: '', args: []);
  }

  /// `1-Year`
  String get productsDuration1Year {
    return Intl.message('1-Year', name: 'productsDuration1Year', desc: '', args: []);
  }

  /// `2-Year`
  String get productsDuration2Year {
    return Intl.message('2-Year', name: 'productsDuration2Year', desc: '', args: []);
  }

  /// `Explore plans and features`
  String get productsExploreSubtitle {
    return Intl.message(
      'Explore plans and features',
      name: 'productsExploreSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `Manage and upgrade on the web`
  String get productsManageSubtitle {
    return Intl.message(
      'Manage and upgrade on the web',
      name: 'productsManageSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `You're already on the highest plan available.`
  String get productsMaxPlanAlert {
    return Intl.message(
      'You\'re already on the highest plan available.',
      name: 'productsMaxPlanAlert',
      desc: '',
      args: [],
    );
  }

  /// `There are no available products at the moment. Please try again later.`
  String get productsNotAvailable {
    return Intl.message(
      'There are no available products at the moment. Please try again later.',
      name: 'productsNotAvailable',
      desc: '',
      args: [],
    );
  }

  /// `More devices, more locations`
  String get productsPlusDescription {
    return Intl.message(
      'More devices, more locations',
      name: 'productsPlusDescription',
      desc: '',
      args: [],
    );
  }

  /// `Maximum protection for heavy users`
  String get productsProDescription {
    return Intl.message(
      'Maximum protection for heavy users',
      name: 'productsProDescription',
      desc: '',
      args: [],
    );
  }

  /// `Subscriptions are managed on the web. Your plan will sync with the app automatically.`
  String get productsSubscribeWebAlert {
    return Intl.message(
      'Subscriptions are managed on the web. Your plan will sync with the app automatically.',
      name: 'productsSubscribeWebAlert',
      desc: '',
      args: [],
    );
  }

  /// `Subscribe on the web`
  String get productsSubscribeWebSubtitle {
    return Intl.message(
      'Subscribe on the web',
      name: 'productsSubscribeWebSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `VPN products`
  String get productsTitle {
    return Intl.message('VPN products', name: 'productsTitle', desc: '', args: []);
  }

  /// `PROTECTED`
  String get protectedLbl {
    return Intl.message('PROTECTED', name: 'protectedLbl', desc: '', args: []);
  }

  /// `Protocol`
  String get protocol {
    return Intl.message('Protocol', name: 'protocol', desc: '', args: []);
  }

  /// `{protocol} ({label})`
  String protocolLabel(Object protocol, Object label) {
    return Intl.message(
      '$protocol ($label)',
      name: 'protocolLabel',
      desc: '',
      args: [protocol, label],
    );
  }

  /// `Switching the VPN protocol will disconnect you. You’ll need to reconnect afterwards.`
  String get protocolPickerSettingDesc {
    return Intl.message(
      'Switching the VPN protocol will disconnect you. You’ll need to reconnect afterwards.',
      name: 'protocolPickerSettingDesc',
      desc: '',
      args: [],
    );
  }

  /// `Switching VPN protocol`
  String get protocolPickerSettingTitle {
    return Intl.message(
      'Switching VPN protocol',
      name: 'protocolPickerSettingTitle',
      desc: '',
      args: [],
    );
  }

  /// `Portuguese`
  String get pt {
    return Intl.message('Portuguese', name: 'pt', desc: '', args: []);
  }

  /// `Brazilian Portuguese`
  String get ptBR {
    return Intl.message('Brazilian Portuguese', name: 'ptBR', desc: '', args: []);
  }

  /// `Get notified about new features, helpful tips, and exclusive offers - just useful updates.`
  String get pushNotificationsConsentPopupDesc {
    return Intl.message(
      'Get notified about new features, helpful tips, and exclusive offers - just useful updates.',
      name: 'pushNotificationsConsentPopupDesc',
      desc: '',
      args: [],
    );
  }

  /// `Stay up to date with push notifications`
  String get pushNotificationsConsentPopupTitle {
    return Intl.message(
      'Stay up to date with push notifications',
      name: 'pushNotificationsConsentPopupTitle',
      desc: '',
      args: [],
    );
  }

  /// `Push Notifications`
  String get pushNotificationsSetting {
    return Intl.message('Push Notifications', name: 'pushNotificationsSetting', desc: '', args: []);
  }

  /// `Product updates, tips, and special offers`
  String get pushNotificationsSettingDesc {
    return Intl.message(
      'Product updates, tips, and special offers',
      name: 'pushNotificationsSettingDesc',
      desc: '',
      args: [],
    );
  }

  /// `QA Toolbox`
  String get qaToolboxLbl {
    return Intl.message('QA Toolbox', name: 'qaToolboxLbl', desc: '', args: []);
  }

  /// `How is your connection?`
  String get rateConnection {
    return Intl.message('How is your connection?', name: 'rateConnection', desc: '', args: []);
  }

  /// `What didn’t you like?`
  String get rateConnectionDislike {
    return Intl.message('What didn’t you like?', name: 'rateConnectionDislike', desc: '', args: []);
  }

  /// `What did you like?`
  String get rateConnectionLike {
    return Intl.message('What did you like?', name: 'rateConnectionLike', desc: '', args: []);
  }

  /// `You can reactivate your subscription anytime before your access ends.`
  String get reactivateSubscriptionAnytimeDesc {
    return Intl.message(
      'You can reactivate your subscription anytime before your access ends.',
      name: 'reactivateSubscriptionAnytimeDesc',
      desc: '',
      args: [],
    );
  }

  /// `Recent locations`
  String get recentLocations {
    return Intl.message('Recent locations', name: 'recentLocations', desc: '', args: []);
  }

  /// `Redeem discount code`
  String get redeemDiscountCode {
    return Intl.message('Redeem discount code', name: 'redeemDiscountCode', desc: '', args: []);
  }

  /// `Your account has been successfully deleted. You'll be redirected to the log in screen.`
  String get redirectToLoginPage {
    return Intl.message(
      'Your account has been successfully deleted. You\'ll be redirected to the log in screen.',
      name: 'redirectToLoginPage',
      desc: '',
      args: [],
    );
  }

  /// `Refresh`
  String get refresh {
    return Intl.message('Refresh', name: 'refresh', desc: '', args: []);
  }

  /// `Refresh IP`
  String get refreshIP {
    return Intl.message('Refresh IP', name: 'refreshIP', desc: '', args: []);
  }

  /// `Refresh IP address`
  String get refreshIPAddress {
    return Intl.message('Refresh IP address', name: 'refreshIPAddress', desc: '', args: []);
  }

  /// `Refresh {location}`
  String refreshLocationsTooltip(Object location) {
    return Intl.message(
      'Refresh $location',
      name: 'refreshLocationsTooltip',
      desc: '',
      args: [location],
    );
  }

  /// `Reset when something isn't working`
  String get resetAppDesc {
    return Intl.message(
      'Reset when something isn\'t working',
      name: 'resetAppDesc',
      desc: '',
      args: [],
    );
  }

  /// `If you proceed with resetting the app, you will be disconnected from the Mysterium VPN.`
  String get resetAppDialogContent {
    return Intl.message(
      'If you proceed with resetting the app, you will be disconnected from the Mysterium VPN.',
      name: 'resetAppDialogContent',
      desc: '',
      args: [],
    );
  }

  /// `VPN connection is currently active`
  String get resetAppDialogTitle {
    return Intl.message(
      'VPN connection is currently active',
      name: 'resetAppDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `Failed to reset the app. Please try again.`
  String get resetAppFailed {
    return Intl.message(
      'Failed to reset the app. Please try again.',
      name: 'resetAppFailed',
      desc: '',
      args: [],
    );
  }

  /// `App has been reset successfully.`
  String get resetAppSuccess {
    return Intl.message(
      'App has been reset successfully.',
      name: 'resetAppSuccess',
      desc: '',
      args: [],
    );
  }

  /// `Reset app`
  String get resetAppTitle {
    return Intl.message('Reset app', name: 'resetAppTitle', desc: '', args: []);
  }

  /// `Reset`
  String get resetBtn {
    return Intl.message('Reset', name: 'resetBtn', desc: '', args: []);
  }

  /// `Residential`
  String get residential {
    return Intl.message('Residential', name: 'residential', desc: '', args: []);
  }

  /// `Looks like a real user`
  String get residentialCentreComparisonCardItem1 {
    return Intl.message(
      'Looks like a real user',
      name: 'residentialCentreComparisonCardItem1',
      desc: '',
      args: [],
    );
  }

  /// `Harder to detect`
  String get residentialCentreComparisonCardItem2 {
    return Intl.message(
      'Harder to detect',
      name: 'residentialCentreComparisonCardItem2',
      desc: '',
      args: [],
    );
  }

  /// `Fewer blocks`
  String get residentialCentreComparisonCardItem3 {
    return Intl.message(
      'Fewer blocks',
      name: 'residentialCentreComparisonCardItem3',
      desc: '',
      args: [],
    );
  }

  /// `RESIDENTIAL IPS`
  String get residentialCentreComparisonCardLbl {
    return Intl.message(
      'RESIDENTIAL IPS',
      name: 'residentialCentreComparisonCardLbl',
      desc: '',
      args: [],
    );
  }

  /// `Residential IPs come from real household devices, making your traffic look like regular internet activity.`
  String get residentialEducationBlock1Body {
    return Intl.message(
      'Residential IPs come from real household devices, making your traffic look like regular internet activity.',
      name: 'residentialEducationBlock1Body',
      desc: '',
      args: [],
    );
  }

  /// `Real household devices`
  String get residentialEducationBlock1Title {
    return Intl.message(
      'Real household devices',
      name: 'residentialEducationBlock1Title',
      desc: '',
      args: [],
    );
  }

  /// `Because these IPs are provided by real devices, some nodes may go offline from time to time.`
  String get residentialEducationBlock2Body {
    return Intl.message(
      'Because these IPs are provided by real devices, some nodes may go offline from time to time.',
      name: 'residentialEducationBlock2Body',
      desc: '',
      args: [],
    );
  }

  /// `Availability can change`
  String get residentialEducationBlock2Title {
    return Intl.message(
      'Availability can change',
      name: 'residentialEducationBlock2Title',
      desc: '',
      args: [],
    );
  }

  /// `If your current IP becomes unavailable, the app reconnects you to the nearest available residential IP.`
  String get residentialEducationBlock3Body {
    return Intl.message(
      'If your current IP becomes unavailable, the app reconnects you to the nearest available residential IP.',
      name: 'residentialEducationBlock3Body',
      desc: '',
      args: [],
    );
  }

  /// `Automatic reconnection`
  String get residentialEducationBlock3Title {
    return Intl.message(
      'Automatic reconnection',
      name: 'residentialEducationBlock3Title',
      desc: '',
      args: [],
    );
  }

  /// `Got it`
  String get residentialEducationGotIt {
    return Intl.message('Got it', name: 'residentialEducationGotIt', desc: '', args: []);
  }

  /// `Residential IPs are different from datacenter IPs. Here’s what to expect.`
  String get residentialEducationSubtitle {
    return Intl.message(
      'Residential IPs are different from datacenter IPs. Here’s what to expect.',
      name: 'residentialEducationSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `How Residential IPs work`
  String get residentialEducationTitle {
    return Intl.message(
      'How Residential IPs work',
      name: 'residentialEducationTitle',
      desc: '',
      args: [],
    );
  }

  /// `Retry`
  String get retryBtn {
    return Intl.message('Retry', name: 'retryBtn', desc: '', args: []);
  }

  /// `Leave a review`
  String get reviewLeaveReviewBtn {
    return Intl.message('Leave a review', name: 'reviewLeaveReviewBtn', desc: '', args: []);
  }

  /// `That’s great! Would you mind leaving us a review?`
  String get reviewPositiveTitle {
    return Intl.message(
      'That’s great! Would you mind leaving us a review?',
      name: 'reviewPositiveTitle',
      desc: '',
      args: [],
    );
  }

  /// `Would you recommend this app to others?`
  String get reviewSatisfactionTitle {
    return Intl.message(
      'Would you recommend this app to others?',
      name: 'reviewSatisfactionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Search for locations`
  String get searchForLocations {
    return Intl.message('Search for locations', name: 'searchForLocations', desc: '', args: []);
  }

  /// `See plans`
  String get seePlansBtn {
    return Intl.message('See plans', name: 'seePlansBtn', desc: '', args: []);
  }

  /// `Select Email App to Continue`
  String get selectEmailApp {
    return Intl.message('Select Email App to Continue', name: 'selectEmailApp', desc: '', args: []);
  }

  /// `semi-annually`
  String get semiAnnual {
    return Intl.message('semi-annually', name: 'semiAnnual', desc: '', args: []);
  }

  /// `{count, plural, zero{Send again} one{Send again} other{Send again ({count})}}`
  String sendAgain(num count) {
    return Intl.plural(
      count,
      zero: 'Send again',
      one: 'Send again',
      other: 'Send again ($count)',
      name: 'sendAgain',
      desc: '',
      args: [count],
    );
  }

  /// `We’re experiencing temporary network issues. Please try again later.`
  String get serviceUnavailableError {
    return Intl.message(
      'We’re experiencing temporary network issues. Please try again later.',
      name: 'serviceUnavailableError',
      desc: '',
      args: [],
    );
  }

  /// `Manage`
  String get settingManageBtn {
    return Intl.message('Manage', name: 'settingManageBtn', desc: '', args: []);
  }

  /// `Settings`
  String get settings {
    return Intl.message('Settings', name: 'settings', desc: '', args: []);
  }

  /// `In order to use Mysterium VPN, we need your permission to install a VPN profile.`
  String get setupTunnerPermissionsDialogDesc {
    return Intl.message(
      'In order to use Mysterium VPN, we need your permission to install a VPN profile.',
      name: 'setupTunnerPermissionsDialogDesc',
      desc: '',
      args: [],
    );
  }

  /// `Your anonymity is secure. We don't see, collect or store any of your browsing activity.`
  String get setupTunnerPermissionsDialogDisclaimer {
    return Intl.message(
      'Your anonymity is secure. We don\'t see, collect or store any of your browsing activity.',
      name: 'setupTunnerPermissionsDialogDisclaimer',
      desc: '',
      args: [],
    );
  }

  /// `We need your permission`
  String get setupTunnerPermissionsDialogTitle {
    return Intl.message(
      'We need your permission',
      name: 'setupTunnerPermissionsDialogTitle',
      desc: '',
      args: [],
    );
  }

  /// `Sign in to Mysterium VPN`
  String get signIn {
    return Intl.message('Sign in to Mysterium VPN', name: 'signIn', desc: '', args: []);
  }

  /// `Sign in aborted`
  String get signInAbortedMsg {
    return Intl.message('Sign in aborted', name: 'signInAbortedMsg', desc: '', args: []);
  }

  /// `Sign in`
  String get signInBtn {
    return Intl.message('Sign in', name: 'signInBtn', desc: '', args: []);
  }

  /// `Mysterium VPN does not log your online activities, and no records are tied to you, your device, your IP address, or your email. By signing in, you agree with our`
  String get signInDisclaimer {
    return Intl.message(
      'Mysterium VPN does not log your online activities, and no records are tied to you, your device, your IP address, or your email. By signing in, you agree with our',
      name: 'signInDisclaimer',
      desc: '',
      args: [],
    );
  }

  /// `6 months`
  String get sixMonths {
    return Intl.message('6 months', name: 'sixMonths', desc: '', args: []);
  }

  /// `Skip`
  String get skipBtn {
    return Intl.message('Skip', name: 'skipBtn', desc: '', args: []);
  }

  /// `Something went wrong. Please try again!`
  String get somethingWentWrong {
    return Intl.message(
      'Something went wrong. Please try again!',
      name: 'somethingWentWrong',
      desc: '',
      args: [],
    );
  }

  /// `Stable connection`
  String get stableConnectionReason {
    return Intl.message('Stable connection', name: 'stableConnectionReason', desc: '', args: []);
  }

  /// `Status`
  String get status {
    return Intl.message('Status', name: 'status', desc: '', args: []);
  }

  /// `Stay`
  String get stayButton {
    return Intl.message('Stay', name: 'stayButton', desc: '', args: []);
  }

  /// `Stay on the app`
  String get stayOnAppBtn {
    return Intl.message('Stay on the app', name: 'stayOnAppBtn', desc: '', args: []);
  }

  /// `Submit`
  String get submitBtn {
    return Intl.message('Submit', name: 'submitBtn', desc: '', args: []);
  }

  /// `Subscribe on the web`
  String get subscribeOnWebBtn {
    return Intl.message('Subscribe on the web', name: 'subscribeOnWebBtn', desc: '', args: []);
  }

  /// `Great news! Your subscription is now active.`
  String get subscriptionActive {
    return Intl.message(
      'Great news! Your subscription is now active.',
      name: 'subscriptionActive',
      desc: '',
      args: [],
    );
  }

  /// `Back to plans`
  String get subscriptionAllPlansBackToPlans {
    return Intl.message(
      'Back to plans',
      name: 'subscriptionAllPlansBackToPlans',
      desc: '',
      args: [],
    );
  }

  /// `Compare all features`
  String get subscriptionAllPlansCompareAll {
    return Intl.message(
      'Compare all features',
      name: 'subscriptionAllPlansCompareAll',
      desc: '',
      args: [],
    );
  }

  /// `Current plan`
  String get subscriptionAllPlansCurrentPlan {
    return Intl.message(
      'Current plan',
      name: 'subscriptionAllPlansCurrentPlan',
      desc: '',
      args: [],
    );
  }

  /// `Get plan`
  String get subscriptionAllPlansPurchase {
    return Intl.message('Get plan', name: 'subscriptionAllPlansPurchase', desc: '', args: []);
  }

  /// `Monthly`
  String get subscriptionAllPlansTabMonth {
    return Intl.message('Monthly', name: 'subscriptionAllPlansTabMonth', desc: '', args: []);
  }

  /// `1-Year`
  String get subscriptionAllPlansTabYear {
    return Intl.message('1-Year', name: 'subscriptionAllPlansTabYear', desc: '', args: []);
  }

  /// `All plans`
  String get subscriptionAllPlansTitle {
    return Intl.message('All plans', name: 'subscriptionAllPlansTitle', desc: '', args: []);
  }

  /// `Upgrade your plan`
  String get subscriptionAllPlansUpgrade {
    return Intl.message(
      'Upgrade your plan',
      name: 'subscriptionAllPlansUpgrade',
      desc: '',
      args: [],
    );
  }

  /// `Subscription cancelled`
  String get subscriptionCancelledTitle {
    return Intl.message(
      'Subscription cancelled',
      name: 'subscriptionCancelledTitle',
      desc: '',
      args: [],
    );
  }

  /// `Explore advanced features like VPN protocols and malware blocking.`
  String get subscriptionOnboardingBoostProtectionDescription {
    return Intl.message(
      'Explore advanced features like VPN protocols and malware blocking.',
      name: 'subscriptionOnboardingBoostProtectionDescription',
      desc: '',
      args: [],
    );
  }

  /// `Boost your protection`
  String get subscriptionOnboardingBoostProtectionTitle {
    return Intl.message(
      'Boost your protection',
      name: 'subscriptionOnboardingBoostProtectionTitle',
      desc: '',
      args: [],
    );
  }

  /// `Skip for now`
  String get subscriptionOnboardingCancelTourLabel {
    return Intl.message(
      'Skip for now',
      name: 'subscriptionOnboardingCancelTourLabel',
      desc: '',
      args: [],
    );
  }

  /// `We’ll connect you to the best server.`
  String get subscriptionOnboardingConnectDescription {
    return Intl.message(
      'We’ll connect you to the best server.',
      name: 'subscriptionOnboardingConnectDescription',
      desc: '',
      args: [],
    );
  }

  /// `Connect to stay private`
  String get subscriptionOnboardingConnectTitle {
    return Intl.message(
      'Connect to stay private',
      name: 'subscriptionOnboardingConnectTitle',
      desc: '',
      args: [],
    );
  }

  /// `Purchase, upgrade or view available plans based on your account access.`
  String get subscriptionOnboardingManagePlanDescription {
    return Intl.message(
      'Purchase, upgrade or view available plans based on your account access.',
      name: 'subscriptionOnboardingManagePlanDescription',
      desc: '',
      args: [],
    );
  }

  /// `Manage your plan`
  String get subscriptionOnboardingManagePlanTitle {
    return Intl.message(
      'Manage your plan',
      name: 'subscriptionOnboardingManagePlanTitle',
      desc: '',
      args: [],
    );
  }

  /// `Browse the map or explore locations from the sidebar.`
  String get subscriptionOnboardingMapDesktopDescription {
    return Intl.message(
      'Browse the map or explore locations from the sidebar.',
      name: 'subscriptionOnboardingMapDesktopDescription',
      desc: '',
      args: [],
    );
  }

  /// `Explore locations your way`
  String get subscriptionOnboardingMapDesktopTitle {
    return Intl.message(
      'Explore locations your way',
      name: 'subscriptionOnboardingMapDesktopTitle',
      desc: '',
      args: [],
    );
  }

  /// `Browse the map to choose a country and connect instantly.`
  String get subscriptionOnboardingMapMobileDescription {
    return Intl.message(
      'Browse the map to choose a country and connect instantly.',
      name: 'subscriptionOnboardingMapMobileDescription',
      desc: '',
      args: [],
    );
  }

  /// `Connect from the map`
  String get subscriptionOnboardingMapMobileTitle {
    return Intl.message(
      'Connect from the map',
      name: 'subscriptionOnboardingMapMobileTitle',
      desc: '',
      args: [],
    );
  }

  /// `Learn your way around the updated app and discover where key features now live.`
  String get subscriptionOnboardingPromptDescription {
    return Intl.message(
      'Learn your way around the updated app and discover where key features now live.',
      name: 'subscriptionOnboardingPromptDescription',
      desc: '',
      args: [],
    );
  }

  /// `Take a quick tour`
  String get subscriptionOnboardingPromptTitle {
    return Intl.message(
      'Take a quick tour',
      name: 'subscriptionOnboardingPromptTitle',
      desc: '',
      args: [],
    );
  }

  /// `Quickly find countries, cities and servers with search.`
  String get subscriptionOnboardingSearchDescription {
    return Intl.message(
      'Quickly find countries, cities and servers with search.',
      name: 'subscriptionOnboardingSearchDescription',
      desc: '',
      args: [],
    );
  }

  /// `Search and connect faster`
  String get subscriptionOnboardingSearchTitle {
    return Intl.message(
      'Search and connect faster',
      name: 'subscriptionOnboardingSearchTitle',
      desc: '',
      args: [],
    );
  }

  /// `Choose a location to start browsing more privately.`
  String get subscriptionOnboardingSetupCompleteDescription {
    return Intl.message(
      'Choose a location to start browsing more privately.',
      name: 'subscriptionOnboardingSetupCompleteDescription',
      desc: '',
      args: [],
    );
  }

  /// `Setup complete`
  String get subscriptionOnboardingSetupCompleteTitle {
    return Intl.message(
      'Setup complete',
      name: 'subscriptionOnboardingSetupCompleteTitle',
      desc: '',
      args: [],
    );
  }

  /// `Start tour`
  String get subscriptionOnboardingStartTourLabel {
    return Intl.message(
      'Start tour',
      name: 'subscriptionOnboardingStartTourLabel',
      desc: '',
      args: [],
    );
  }

  /// `Explore countries and cities in one place.`
  String get subscriptionOnboardingVPNLocationsDesktopDescription {
    return Intl.message(
      'Explore countries and cities in one place.',
      name: 'subscriptionOnboardingVPNLocationsDesktopDescription',
      desc: '',
      args: [],
    );
  }

  /// `Explore countries, cities, recent connections and specialty servers in one place.`
  String get subscriptionOnboardingVPNLocationsMobileDescription {
    return Intl.message(
      'Explore countries, cities, recent connections and specialty servers in one place.',
      name: 'subscriptionOnboardingVPNLocationsMobileDescription',
      desc: '',
      args: [],
    );
  }

  /// `Browse VPN locations`
  String get subscriptionOnboardingVPNLocationsTitle {
    return Intl.message(
      'Browse VPN locations',
      name: 'subscriptionOnboardingVPNLocationsTitle',
      desc: '',
      args: [],
    );
  }

  /// `BEST VALUE`
  String get subscriptionPlanBestValue {
    return Intl.message('BEST VALUE', name: 'subscriptionPlanBestValue', desc: '', args: []);
  }

  /// `City-level choices`
  String get subscriptionPlanCityLevel {
    return Intl.message(
      'City-level choices',
      name: 'subscriptionPlanCityLevel',
      desc: '',
      args: [],
    );
  }

  /// `Provides more precise location control than most VPNs, which typically limit you to selecting entire countries or states.`
  String get subscriptionPlanCityLevelDesc {
    return Intl.message(
      'Provides more precise location control than most VPNs, which typically limit you to selecting entire countries or states.',
      name: 'subscriptionPlanCityLevelDesc',
      desc: '',
      args: [],
    );
  }

  /// `Devices secured at once`
  String get subscriptionPlanDevicesSecured {
    return Intl.message(
      'Devices secured at once',
      name: 'subscriptionPlanDevicesSecured',
      desc: '',
      args: [],
    );
  }

  /// `Double VPN`
  String get subscriptionPlanDoubleVPN {
    return Intl.message('Double VPN', name: 'subscriptionPlanDoubleVPN', desc: '', args: []);
  }

  /// `Extra layer of security. Routes your internet traffic through two different VPN servers, encrypting your data twice and masking your IP address behind a second server`
  String get subscriptionPlanDoubleVPNDesc {
    return Intl.message(
      'Extra layer of security. Routes your internet traffic through two different VPN servers, encrypting your data twice and masking your IP address behind a second server',
      name: 'subscriptionPlanDoubleVPNDesc',
      desc: '',
      args: [],
    );
  }

  /// `Malware blocker`
  String get subscriptionPlanMalwareBlocker {
    return Intl.message(
      'Malware blocker',
      name: 'subscriptionPlanMalwareBlocker',
      desc: '',
      args: [],
    );
  }

  /// `Protects your device by stopping threats before they can reach it, running quietly in the background without interrupting you.`
  String get subscriptionPlanMalwareBlockerDesc {
    return Intl.message(
      'Protects your device by stopping threats before they can reach it, running quietly in the background without interrupting you.',
      name: 'subscriptionPlanMalwareBlockerDesc',
      desc: '',
      args: [],
    );
  }

  /// `7-day money-back guarantee`
  String get subscriptionPlanMoneyBack {
    return Intl.message(
      '7-day money-back guarantee',
      name: 'subscriptionPlanMoneyBack',
      desc: '',
      args: [],
    );
  }

  /// `Basic`
  String get subscriptionPlanNameBasic {
    return Intl.message('Basic', name: 'subscriptionPlanNameBasic', desc: '', args: []);
  }

  /// `Plus`
  String get subscriptionPlanNamePlus {
    return Intl.message('Plus', name: 'subscriptionPlanNamePlus', desc: '', args: []);
  }

  /// `Pro`
  String get subscriptionPlanNamePro {
    return Intl.message('Pro', name: 'subscriptionPlanNamePro', desc: '', args: []);
  }

  /// `Secure 6 devices at a time`
  String get subscriptionPlanPF1Basic {
    return Intl.message(
      'Secure 6 devices at a time',
      name: 'subscriptionPlanPF1Basic',
      desc: '',
      args: [],
    );
  }

  /// `Secure 10 devices at a time`
  String get subscriptionPlanPF1Plus {
    return Intl.message(
      'Secure 10 devices at a time',
      name: 'subscriptionPlanPF1Plus',
      desc: '',
      args: [],
    );
  }

  /// `57 supported countries`
  String get subscriptionPlanPF2Basic {
    return Intl.message(
      '57 supported countries',
      name: 'subscriptionPlanPF2Basic',
      desc: '',
      args: [],
    );
  }

  /// `100+ supported countries`
  String get subscriptionPlanPF2Plus {
    return Intl.message(
      '100+ supported countries',
      name: 'subscriptionPlanPF2Plus',
      desc: '',
      args: [],
    );
  }

  /// `10 servers`
  String get subscriptionPlanPF3Basic {
    return Intl.message('10 servers', name: 'subscriptionPlanPF3Basic', desc: '', args: []);
  }

  /// `100 servers`
  String get subscriptionPlanPF3Plus {
    return Intl.message('100 servers', name: 'subscriptionPlanPF3Plus', desc: '', args: []);
  }

  /// `VPN protocol`
  String get subscriptionPlanPF4Basic {
    return Intl.message('VPN protocol', name: 'subscriptionPlanPF4Basic', desc: '', args: []);
  }

  /// `7,500+ residential IPs`
  String get subscriptionPlanPF4Plus {
    return Intl.message(
      '7,500+ residential IPs',
      name: 'subscriptionPlanPF4Plus',
      desc: '',
      args: [],
    );
  }

  /// `VPN protocol`
  String get subscriptionPlanPF5Plus {
    return Intl.message('VPN protocol', name: 'subscriptionPlanPF5Plus', desc: '', args: []);
  }

  /// `City-level choices`
  String get subscriptionPlanPF6Plus {
    return Intl.message('City-level choices', name: 'subscriptionPlanPF6Plus', desc: '', args: []);
  }

  /// `Residential IPs`
  String get subscriptionPlanResidentialIPs {
    return Intl.message(
      'Residential IPs',
      name: 'subscriptionPlanResidentialIPs',
      desc: '',
      args: [],
    );
  }

  /// `Appear as a normal home user, letting you access streaming services and avoid VPN detection.`
  String get subscriptionPlanResidentialIPsDesc {
    return Intl.message(
      'Appear as a normal home user, letting you access streaming services and avoid VPN detection.',
      name: 'subscriptionPlanResidentialIPsDesc',
      desc: '',
      args: [],
    );
  }

  /// `Save {percent}%`
  String subscriptionPlanSavePercent(Object percent) {
    return Intl.message(
      'Save $percent%',
      name: 'subscriptionPlanSavePercent',
      desc: '',
      args: [percent],
    );
  }

  /// `Save {percent}% with a {planId} plan`
  String subscriptionPlanSaveWith(Object percent, Object planId) {
    return Intl.message(
      'Save $percent% with a $planId plan',
      name: 'subscriptionPlanSaveWith',
      desc: '',
      args: [percent, planId],
    );
  }

  /// `Servers`
  String get subscriptionPlanServers {
    return Intl.message('Servers', name: 'subscriptionPlanServers', desc: '', args: []);
  }

  /// `Supported countries`
  String get subscriptionPlanSupportedCountries {
    return Intl.message(
      'Supported countries',
      name: 'subscriptionPlanSupportedCountries',
      desc: '',
      args: [],
    );
  }

  /// `VPN protocol`
  String get subscriptionPlanWireGuard {
    return Intl.message('VPN protocol', name: 'subscriptionPlanWireGuard', desc: '', args: []);
  }

  /// `WireGuard - fast protocol best for gaming and streaming\nOpenVPN - highly configurable protocol that works where other protocols fail (not available on Android)`
  String get subscriptionPlanWireGuardDesc {
    return Intl.message(
      'WireGuard - fast protocol best for gaming and streaming\nOpenVPN - highly configurable protocol that works where other protocols fail (not available on Android)',
      name: 'subscriptionPlanWireGuardDesc',
      desc: '',
      args: [],
    );
  }

  /// `You didn't complete the changes to your subscription.`
  String get subscriptionProcessCanceled {
    return Intl.message(
      'You didn\'t complete the changes to your subscription.',
      name: 'subscriptionProcessCanceled',
      desc: '',
      args: [],
    );
  }

  /// `Upgrade`
  String get subscriptionUpgrade {
    return Intl.message('Upgrade', name: 'subscriptionUpgrade', desc: '', args: []);
  }

  /// `Upgrade to {plan}`
  String subscriptionUpgradeCTA(Object plan) {
    return Intl.message('Upgrade to $plan', name: 'subscriptionUpgradeCTA', desc: '', args: [plan]);
  }

  /// `to access 7,500+ residential IPs`
  String get subscriptionUpgradeModalDescription {
    return Intl.message(
      'to access 7,500+ residential IPs',
      name: 'subscriptionUpgradeModalDescription',
      desc: '',
      args: [],
    );
  }

  /// `Upgrade to {plan} plan`
  String subscriptionUpgradeModalTitle(Object plan) {
    return Intl.message(
      'Upgrade to $plan plan',
      name: 'subscriptionUpgradeModalTitle',
      desc: '',
      args: [plan],
    );
  }

  /// `See all plans`
  String get subscriptionUpgradeSeeAllPlans {
    return Intl.message(
      'See all plans',
      name: 'subscriptionUpgradeSeeAllPlans',
      desc: '',
      args: [],
    );
  }

  /// `Retry Verification`
  String get subscriptionVerificationFailed {
    return Intl.message(
      'Retry Verification',
      name: 'subscriptionVerificationFailed',
      desc: '',
      args: [],
    );
  }

  /// `Subscription`
  String get subscripton {
    return Intl.message('Subscription', name: 'subscripton', desc: '', args: []);
  }

  /// `Switch to {location}`
  String switchToLocationBtn(Object location) {
    return Intl.message(
      'Switch to $location',
      name: 'switchToLocationBtn',
      desc: '',
      args: [location],
    );
  }

  /// `Default`
  String get system {
    return Intl.message('Default', name: 'system', desc: '', args: []);
  }

  /// `Take back the internet.`
  String get takeBackTheInternetLbl {
    return Intl.message(
      'Take back the internet.',
      name: 'takeBackTheInternetLbl',
      desc: '',
      args: [],
    );
  }

  /// `Terms and Conditions`
  String get termsAndConditions {
    return Intl.message('Terms and Conditions', name: 'termsAndConditions', desc: '', args: []);
  }

  /// `Hello Sir`
  String get title {
    return Intl.message('Hello Sir', name: 'title', desc: '', args: []);
  }

  /// `Token already used. Please try again.\n`
  String get tokenAlreadyUsed {
    return Intl.message(
      'Token already used. Please try again.\n',
      name: 'tokenAlreadyUsed',
      desc: '',
      args: [],
    );
  }

  /// `Too many requests. Please try again later.`
  String get toManyRequestsErrorMsg {
    return Intl.message(
      'Too many requests. Please try again later.',
      name: 'toManyRequestsErrorMsg',
      desc: '',
      args: [],
    );
  }

  /// `Disconnect`
  String get tooManyConnectionsBannerCTADisconnect {
    return Intl.message(
      'Disconnect',
      name: 'tooManyConnectionsBannerCTADisconnect',
      desc: '',
      args: [],
    );
  }

  /// `Reconnect`
  String get tooManyConnectionsBannerCTAReconnect {
    return Intl.message(
      'Reconnect',
      name: 'tooManyConnectionsBannerCTAReconnect',
      desc: '',
      args: [],
    );
  }

  /// `You’ve reached the maximum limit of 6 connected devices on your account. To continue using VPN, click to reconnect.`
  String get tooManyConnectionsBannerDesc {
    return Intl.message(
      'You’ve reached the maximum limit of 6 connected devices on your account. To continue using VPN, click to reconnect.',
      name: 'tooManyConnectionsBannerDesc',
      desc: '',
      args: [],
    );
  }

  /// `You’ve reached the maximum limit of 6 connected devices on your account. To continue using VPN, click disconnect and try again.`
  String get tooManyConnectionsBannerDescConnected {
    return Intl.message(
      'You’ve reached the maximum limit of 6 connected devices on your account. To continue using VPN, click disconnect and try again.',
      name: 'tooManyConnectionsBannerDescConnected',
      desc: '',
      args: [],
    );
  }

  /// `You've Been Disconnected`
  String get tooManyConnectionsBannerTitle {
    return Intl.message(
      'You\'ve Been Disconnected',
      name: 'tooManyConnectionsBannerTitle',
      desc: '',
      args: [],
    );
  }

  /// `Top locations`
  String get topLocations {
    return Intl.message('Top locations', name: 'topLocations', desc: '', args: []);
  }

  /// `Turkish`
  String get tr {
    return Intl.message('Turkish', name: 'tr', desc: '', args: []);
  }

  /// `Try again`
  String get tryAgainBtn {
    return Intl.message('Try again', name: 'tryAgainBtn', desc: '', args: []);
  }

  /// `Try searching for another location`
  String get tryAnotherLocation {
    return Intl.message(
      'Try searching for another location',
      name: 'tryAnotherLocation',
      desc: '',
      args: [],
    );
  }

  /// `You need to grant permission to start VPN tunnel.`
  String get tunnelPermissionRequired {
    return Intl.message(
      'You need to grant permission to start VPN tunnel.',
      name: 'tunnelPermissionRequired',
      desc: '',
      args: [],
    );
  }

  /// `Error occurred while setting up tunnel`
  String get tunnelSetupError {
    return Intl.message(
      'Error occurred while setting up tunnel',
      name: 'tunnelSetupError',
      desc: '',
      args: [],
    );
  }

  /// `Type {word}`
  String typeDelete(Object word) {
    return Intl.message('Type $word', name: 'typeDelete', desc: '', args: [word]);
  }

  /// `Type your feedback here...`
  String get typeFeedback {
    return Intl.message('Type your feedback here...', name: 'typeFeedback', desc: '', args: []);
  }

  /// `Ukraine`
  String get ukraine {
    return Intl.message('Ukraine', name: 'ukraine', desc: '', args: []);
  }

  /// `Unable to connect to the payment processor! Please try again.`
  String get unableToConnectToPaymentProcesor {
    return Intl.message(
      'Unable to connect to the payment processor! Please try again.',
      name: 'unableToConnectToPaymentProcesor',
      desc: '',
      args: [],
    );
  }

  /// `You're not signed in`
  String get unauthenticatedBannerTitle {
    return Intl.message(
      'You\'re not signed in',
      name: 'unauthenticatedBannerTitle',
      desc: '',
      args: [],
    );
  }

  /// `Sign in to access your account and unlock all features`
  String get unauthenticatedSettingSubtitle {
    return Intl.message(
      'Sign in to access your account and unlock all features',
      name: 'unauthenticatedSettingSubtitle',
      desc: '',
      args: [],
    );
  }

  /// `You're not signed in`
  String get unauthenticatedSettingTitle {
    return Intl.message(
      'You\'re not signed in',
      name: 'unauthenticatedSettingTitle',
      desc: '',
      args: [],
    );
  }

  /// `UNPROTECTED`
  String get unprotectedLbl {
    return Intl.message('UNPROTECTED', name: 'unprotectedLbl', desc: '', args: []);
  }

  /// `Unstable speed`
  String get unstableSpeedReason {
    return Intl.message('Unstable speed', name: 'unstableSpeedReason', desc: '', args: []);
  }

  /// `Update`
  String get updateBtn {
    return Intl.message('Update', name: 'updateBtn', desc: '', args: []);
  }

  /// `Best speed`
  String get userIntentBestSpeed {
    return Intl.message('Best speed', name: 'userIntentBestSpeed', desc: '', args: []);
  }

  /// `Connect to the fastest available server for optimal performance`
  String get userIntentBestSpeedDesc {
    return Intl.message(
      'Connect to the fastest available server for optimal performance',
      name: 'userIntentBestSpeedDesc',
      desc: '',
      args: [],
    );
  }

  /// `Speciality server`
  String get userIntentLabel {
    return Intl.message('Speciality server', name: 'userIntentLabel', desc: '', args: []);
  }

  /// `Low latency`
  String get userIntentLowLatency {
    return Intl.message('Low latency', name: 'userIntentLowLatency', desc: '', args: []);
  }

  /// `Automatically connects you to the closest server for stable and reliable access`
  String get userIntentLowLatencyDesc {
    return Intl.message(
      'Automatically connects you to the closest server for stable and reliable access',
      name: 'userIntentLowLatencyDesc',
      desc: '',
      args: [],
    );
  }

  /// `Max privacy`
  String get userIntentMaxPrivacy {
    return Intl.message('Max privacy', name: 'userIntentMaxPrivacy', desc: '', args: []);
  }

  /// `Get a server with the best free speech and speed options based on country`
  String get userIntentMaxPrivacyDesc {
    return Intl.message(
      'Get a server with the best free speech and speed options based on country',
      name: 'userIntentMaxPrivacyDesc',
      desc: '',
      args: [],
    );
  }

  /// `Nearest location`
  String get userIntentNearestLocation {
    return Intl.message('Nearest location', name: 'userIntentNearestLocation', desc: '', args: []);
  }

  /// `Connects you to the closest available VPN IP for the best speed and performance based on your current location`
  String get userIntentNearestLocationDesc {
    return Intl.message(
      'Connects you to the closest available VPN IP for the best speed and performance based on your current location',
      name: 'userIntentNearestLocationDesc',
      desc: '',
      args: [],
    );
  }

  /// `P2P`
  String get userIntentP2P {
    return Intl.message('P2P', name: 'userIntentP2P', desc: '', args: []);
  }

  /// `Pick the best server for secure crypto transactions, file sharing, game hosting, and communications`
  String get userIntentP2PDesc {
    return Intl.message(
      'Pick the best server for secure crypto transactions, file sharing, game hosting, and communications',
      name: 'userIntentP2PDesc',
      desc: '',
      args: [],
    );
  }

  /// `Streaming`
  String get userIntentStreaming {
    return Intl.message('Streaming', name: 'userIntentStreaming', desc: '', args: []);
  }

  /// `Access your favorite shows and movies from region-specific platforms`
  String get userIntentStreamingDesc {
    return Intl.message(
      'Access your favorite shows and movies from region-specific platforms',
      name: 'userIntentStreamingDesc',
      desc: '',
      args: [],
    );
  }

  /// `View all features`
  String get viewAllFeaturesBtn {
    return Intl.message('View all features', name: 'viewAllFeaturesBtn', desc: '', args: []);
  }

  /// `View less`
  String get viewLessBtn {
    return Intl.message('View less', name: 'viewLessBtn', desc: '', args: []);
  }

  /// `Vodafone Iberia`
  String get vodafoneLbl {
    return Intl.message('Vodafone Iberia', name: 'vodafoneLbl', desc: '', args: []);
  }

  /// `VPN protocol`
  String get vpnProtocolSettingLbl {
    return Intl.message('VPN protocol', name: 'vpnProtocolSettingLbl', desc: '', args: []);
  }

  /// `year`
  String get year {
    return Intl.message('year', name: 'year', desc: '', args: []);
  }

  /// `yearly`
  String get yearly {
    return Intl.message('yearly', name: 'yearly', desc: '', args: []);
  }

  /// `Yes`
  String get yes {
    return Intl.message('Yes', name: 'yes', desc: '', args: []);
  }

  /// `Chinese`
  String get zh {
    return Intl.message('Chinese', name: 'zh', desc: '', args: []);
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'ar'),
      Locale.fromSubtags(languageCode: 'de'),
      Locale.fromSubtags(languageCode: 'es'),
      Locale.fromSubtags(languageCode: 'fr'),
      Locale.fromSubtags(languageCode: 'hi'),
      Locale.fromSubtags(languageCode: 'id'),
      Locale.fromSubtags(languageCode: 'it'),
      Locale.fromSubtags(languageCode: 'ja'),
      Locale.fromSubtags(languageCode: 'pl'),
      Locale.fromSubtags(languageCode: 'pt'),
      Locale.fromSubtags(languageCode: 'pt', countryCode: 'BR'),
      Locale.fromSubtags(languageCode: 'tr'),
      Locale.fromSubtags(languageCode: 'zh'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}
