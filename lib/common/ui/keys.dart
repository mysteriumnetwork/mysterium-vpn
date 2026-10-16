import 'package:flutter/widgets.dart';

typedef K = Keys;

class Keys {
  static const backButton = Key('backButton');

  // login
  static const loginPage = Key('loginPage');
  static const loginEmailField = Key('loginEmailField');
  static const loginButton = Key('loginButton');

  // home
  static const homePage = Key('homePage');
  static const unauthenticatedBanner = Key('unauthenticatedBanner');
  static const subscriptionBanner = Key('subscriptionBanner');
  static const subscriptionBannerCTA = Key('subscriptionBannerCTA');

  // subscription
  static const subscriptionPage = Key('subscriptionPage');

  // home products tab content
  static const productsView = Key('productsView');

  // marketing consent
  static const marketingConsentDialog = Key('marketingConsentDialog');
  static const marketingConsentAcceptButton = Key('marketingConsentAcceptButton');
  static const marketingConsentDeclineButton = Key('marketingConsentDeclineButton');

  // non-subscriber onboarding dialog
  static const onboardingDialog = Key('onboardingDialog');
  static const onboardingCloseButton = Key('onboardingCloseButton');

  // push notifications permission prompt
  static const pushNotificationsDialog = Key('pushNotificationsDialog');
  static const pushNotificationsDeclineButton = Key('pushNotificationsDeclineButton');

  // subscription onboarding tour prompt
  static const subscriptionOnboardingDialog = Key('subscriptionOnboardingDialog');
  static const subscriptionOnboardingCancelButton = Key('subscriptionOnboardingCancelButton');

  // home bottom navigation tabs
  static const mapTab = Key('mapTab');
  static const locationsTab = Key('locationsTab');
  static const productsTab = Key('productsTab');
  static const settingsTab = Key('settingsTab');

  // settings — category cards
  static const settingsAccountCategory = Key('settingsAccountCategory');
  static const settingsConnectionCategory = Key('settingsConnectionCategory');
  static const settingsPreferencesCategory = Key('settingsPreferencesCategory');

  // settings — pickers (cards + bottom sheets). Options are keyed per item as
  // `<name>Option_<value>` (e.g. #themeOption_dark) via the picker's itemKeyOf.
  static const themePickerCard = Key('themePickerCard');
  static const themePickerSheet = Key('themePickerSheet');
  static const languagePickerCard = Key('languagePickerCard');
  static const languagePickerSheet = Key('languagePickerSheet');
  static const protocolPickerCard = Key('protocolPickerCard');
  static const protocolPickerSheet = Key('protocolPickerSheet');
  static const blockerPickerCard = Key('blockerPickerCard');
  static const blockerPickerSheet = Key('blockerPickerSheet');

  // account / logout
  static const logoutButton = Key('logoutButton');
  static const logoutConfirmButton = Key('logoutConfirmButton');

  // connection
  static const connectButton = Key('connectButton');
  static const connectionStatusBar = Key('connectionStatusBar');

  // locations
  static const locationSearch = Key('locationSearch');

  // news center
  static const newsCenterBell = Key('newsCenterBell');
  static const newsCenterPage = Key('newsCenterPage');
}

/// Key for a location list row, addressable from Patrol as e.g.
/// `#location_DE`. Built from the country code so device tests can target a
/// specific location.
Key locationItemKey(String countryCode) => Key('location_$countryCode');
