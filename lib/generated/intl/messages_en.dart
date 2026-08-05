// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names, avoid_escaping_inner_quotes
// ignore_for_file:unnecessary_string_interpolations, unnecessary_string_escapes

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static String m0(date) => "Access available until ${date}";

  static String m1(store) =>
      "You already have an active subscription paid via ${store}. Manage it in ${store}.";

  static String m2(amount, period) => "${amount} /${period}";

  static String m3(amount, period) => "${amount}/month — Billed ${period}";

  static String m4(location) => "Connect to ${location}";

  static String m5(couponCode) => "${couponCode} copied to clipboard!";

  static String m6(email) => "We sent an email to ${email}";

  static String m7(email) => "You may already have a paid subscription with “${email}”";

  static String m8(errorCode) => "Failed to connect. Please try again [error: ${errorCode}]";

  static String m9(plan) => "Get ${plan}";

  static String m10(plan) => "Get ${plan} plan";

  static String m11(count) => "IP pool: ${count}";

  static String m12(location) =>
      "No alternative IPs are available in ${location}. Choose another country or city to get a different IP next time.";

  static String m13(location) =>
      "No alternative IPs are available in ${location}. Choose another country to get a different IP next time.";

  static String m14(count) =>
      "${Intl.plural(count, one: '${count} City', other: '${count} Cities')}";

  static String m15(count) => "${Intl.plural(count, one: '${count} IP', other: '${count} IPs')}";

  static String m16(count) =>
      "${Intl.plural(count, one: '${count} State', other: '${count} States')}";

  static String m17(location) => "${location} is not available";

  static String m18(location) => "Couldn’t update ${location}";

  static String m19(location) => "${location} updated";

  static String m20(date) => "Next Billing: ${date}";

  static String m21(count) =>
      "${Intl.plural(count, zero: '', one: 'Pause for ${count} month', other: 'Pause for ${count} months')}";

  static String m22(date) => "Paused until ${date}";

  static String m23(protocol, label) => "${protocol} (${label})";

  static String m24(location) => "Refresh ${location}";

  static String m25(date) => "Renews on ${date}";

  static String m26(count) =>
      "${Intl.plural(count, zero: 'Send again', one: 'Send again', other: 'Send again (${count})')}";

  static String m27(percent) => "Save ${percent}%";

  static String m28(percent, planId) => "Save ${percent}% with a ${planId} plan";

  static String m29(plan) => "Upgrade to ${plan}";

  static String m30(plan) => "Upgrade to ${plan} plan";

  static String m31(location) => "Switch to ${location}";

  static String m32(word) => "Type ${word}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "LoggingYouIn": MessageLookupByLibrary.simpleMessage("Logging you in..."),
    "acceptOfferBtn": MessageLookupByLibrary.simpleMessage("Accept offer"),
    "accessAvailableUntilLbl": MessageLookupByLibrary.simpleMessage("Access available until:"),
    "accessBlockedSitesReason": MessageLookupByLibrary.simpleMessage(
      "Unable to access blocked sites",
    ),
    "accessUntil": m0,
    "account": MessageLookupByLibrary.simpleMessage("Account"),
    "accountSuccessfullyDeleted": MessageLookupByLibrary.simpleMessage("Account deleted"),
    "activeSubsPaidVia": m1,
    "allLocations": MessageLookupByLibrary.simpleMessage("All locations"),
    "allowBtn": MessageLookupByLibrary.simpleMessage("Allow"),
    "allowNotificationsBtn": MessageLookupByLibrary.simpleMessage("Allow notifications"),
    "allowPushNotificationsBtn": MessageLookupByLibrary.simpleMessage("Allow notifications"),
    "and": MessageLookupByLibrary.simpleMessage(" and "),
    "appUpdateAvailableDesc": MessageLookupByLibrary.simpleMessage(
      "The new app version is here! Update now for the latest features and improvements.",
    ),
    "appUpdateAvailableSetting": MessageLookupByLibrary.simpleMessage("App Update Available!"),
    "appUpdateAvailableTitle": MessageLookupByLibrary.simpleMessage("App Update Available"),
    "appearanceSettingLbl": MessageLookupByLibrary.simpleMessage("Appearance"),
    "ar": MessageLookupByLibrary.simpleMessage("Arabic"),
    "austria": MessageLookupByLibrary.simpleMessage("Austria"),
    "authenticationFailed": MessageLookupByLibrary.simpleMessage(
      "Unable to sign in. Please try again.",
    ),
    "back": MessageLookupByLibrary.simpleMessage("Back"),
    "backToSettingsLbl": MessageLookupByLibrary.simpleMessage("Back to Settings"),
    "batterySaverLabel": MessageLookupByLibrary.simpleMessage("Battery saver"),
    "berlinLbl": MessageLookupByLibrary.simpleMessage("Berlin, Germany 🇩🇪"),
    "billedInTotal": m2,
    "billedPerMonth": m3,
    "blockerSettingLbl": MessageLookupByLibrary.simpleMessage("Blocker"),
    "buttonUpdateApp": MessageLookupByLibrary.simpleMessage("Update now"),
    "bypassRestrictionsReason": MessageLookupByLibrary.simpleMessage("Bypass restrictions"),
    "cancelBtn": MessageLookupByLibrary.simpleMessage("Cancel"),
    "cancelDisconnects": MessageLookupByLibrary.simpleMessage("Disconnects"),
    "cancelDowntimes": MessageLookupByLibrary.simpleMessage("Downtimes"),
    "cancelError7040": MessageLookupByLibrary.simpleMessage("Error 7040"),
    "cancelLatency": MessageLookupByLibrary.simpleMessage("Latency"),
    "cancelMissingFeatures": MessageLookupByLibrary.simpleMessage("Missing features"),
    "cancelSpeed": MessageLookupByLibrary.simpleMessage("Speed"),
    "cancelSubscriptionPromptDesc": MessageLookupByLibrary.simpleMessage(
      "Are you sure you want to cancel your subscription?",
    ),
    "cancelSubscriptionTitle": MessageLookupByLibrary.simpleMessage("Cancel subscription"),
    "cancelSubscriptionWarningDesc": MessageLookupByLibrary.simpleMessage(
      "Your subscription will be cancelled. You can continue using Mysterium VPN until your access ends.",
    ),
    "cancelSurveyFeedbackHint": MessageLookupByLibrary.simpleMessage(
      "Please enter more details...",
    ),
    "cancelSurveyTellUsMoreHint": MessageLookupByLibrary.simpleMessage("Tell us more (optional)"),
    "cancelSurveyTitle": MessageLookupByLibrary.simpleMessage("Reasons for cancelling"),
    "cancelTooExpensive": MessageLookupByLibrary.simpleMessage("Too expensive"),
    "cancelUnableToAccessBlockedSites": MessageLookupByLibrary.simpleMessage(
      "Unable to access blocked sites",
    ),
    "cancelUsabilityIssues": MessageLookupByLibrary.simpleMessage("Usability issues"),
    "cancelYourSubsMess": MessageLookupByLibrary.simpleMessage(
      "Cancel your subscription on the App Store subscriptions before deleting your account.",
    ),
    "cancellationDateLbl": MessageLookupByLibrary.simpleMessage("Cancellation date:"),
    "cancelled": MessageLookupByLibrary.simpleMessage("Cancelled"),
    "checkSubsStatusFailedDesc": MessageLookupByLibrary.simpleMessage(
      "We are not able to retrieve your plan information.",
    ),
    "checkSubsStatusFailedTitle": MessageLookupByLibrary.simpleMessage(
      "Plan information is not available",
    ),
    "checkSubsStatusTitle": MessageLookupByLibrary.simpleMessage("Getting plan information..."),
    "checkYourEmail": MessageLookupByLibrary.simpleMessage("Check your email"),
    "clearSearchBtn": MessageLookupByLibrary.simpleMessage("Clear search"),
    "closeBtn": MessageLookupByLibrary.simpleMessage("Close"),
    "communicationLbl": MessageLookupByLibrary.simpleMessage("Communications"),
    "communicationLblDesktop": MessageLookupByLibrary.simpleMessage("COMMUNICATIONS"),
    "completeBtn": MessageLookupByLibrary.simpleMessage("Complete"),
    "confirm": MessageLookupByLibrary.simpleMessage("Confirm"),
    "confirmCancellationTitle": MessageLookupByLibrary.simpleMessage("Confirm cancellation"),
    "connect": MessageLookupByLibrary.simpleMessage("Connect"),
    "connectBestServer": MessageLookupByLibrary.simpleMessage("Best server"),
    "connectToLocationBtn": m4,
    "connected": MessageLookupByLibrary.simpleMessage("Connected"),
    "connectedSince": MessageLookupByLibrary.simpleMessage("Connected since"),
    "connecting": MessageLookupByLibrary.simpleMessage("Connecting"),
    "connectingToPaymentProcesor": MessageLookupByLibrary.simpleMessage(
      "Connecting to the payment processor...",
    ),
    "connection": MessageLookupByLibrary.simpleMessage("Connection"),
    "connectionDetails": MessageLookupByLibrary.simpleMessage("Connection details"),
    "connectionSettingLbl": MessageLookupByLibrary.simpleMessage("Connection & Protection"),
    "connectionTimeout": MessageLookupByLibrary.simpleMessage(
      "Connection timed out. Please try again later. If the problem persists, contact support.",
    ),
    "consistentSpeedReason": MessageLookupByLibrary.simpleMessage("Consistent speed"),
    "consumeLink": MessageLookupByLibrary.simpleMessage(
      "It only works on the device that requested it - click the link in your email to continue.",
    ),
    "continueBtn": MessageLookupByLibrary.simpleMessage("Continue"),
    "continueCancellationOnWebDesc": MessageLookupByLibrary.simpleMessage(
      "You\'ll be redirected to the Mysterium VPN website to complete your cancellation.",
    ),
    "continueCancellationOnWebTitle": MessageLookupByLibrary.simpleMessage(
      "Continue cancellation on the web",
    ),
    "continueToCancelBtn": MessageLookupByLibrary.simpleMessage("Continue to cancel"),
    "continueToWebBtn": MessageLookupByLibrary.simpleMessage("Continue to website"),
    "continueWithApple": MessageLookupByLibrary.simpleMessage("Continue with Apple"),
    "continueWithEmail": MessageLookupByLibrary.simpleMessage("Continue with Email"),
    "continueWithGoogle": MessageLookupByLibrary.simpleMessage("Continue with Google"),
    "copyLink": MessageLookupByLibrary.simpleMessage(
      "Copy the link and paste it into your browser",
    ),
    "couponCodeCopied": m5,
    "dark": MessageLookupByLibrary.simpleMessage("Dark"),
    "dataCentreComparisonCardItem1": MessageLookupByLibrary.simpleMessage("Easily detectable"),
    "dataCentreComparisonCardItem2": MessageLookupByLibrary.simpleMessage(
      "Often blocked by websites",
    ),
    "dataCentreComparisonCardItem3": MessageLookupByLibrary.simpleMessage("Less private"),
    "dataCentreComparisonCardLbl": MessageLookupByLibrary.simpleMessage("DATA CENTRE IPS"),
    "dataCentreComparisonCardTitle": MessageLookupByLibrary.simpleMessage("Most VPNs"),
    "de": MessageLookupByLibrary.simpleMessage("German"),
    "deleteAccount": MessageLookupByLibrary.simpleMessage("Delete account"),
    "deleteAccountQuestion": MessageLookupByLibrary.simpleMessage("Delete Account?"),
    "deleteBtn": MessageLookupByLibrary.simpleMessage("Delete"),
    "deviceLimitReachedDesc": MessageLookupByLibrary.simpleMessage(
      "You have reached the maximum number of connected devices. To add a new device, remove an existing one from your account.",
    ),
    "deviceLimitReachedOpenDashboard": MessageLookupByLibrary.simpleMessage("Open Dashboard"),
    "deviceLimitReachedTitle": MessageLookupByLibrary.simpleMessage("Device Limit Reached"),
    "disconnect": MessageLookupByLibrary.simpleMessage("Disconnect"),
    "disconnected": MessageLookupByLibrary.simpleMessage("Disconnected"),
    "disconnecting": MessageLookupByLibrary.simpleMessage("Disconnecting"),
    "discountedPriceLabel": MessageLookupByLibrary.simpleMessage("Only"),
    "dns": MessageLookupByLibrary.simpleMessage("DNS protection"),
    "dnsDesc": MessageLookupByLibrary.simpleMessage("Prevents DNS leaks"),
    "doneBtn": MessageLookupByLibrary.simpleMessage("Done"),
    "duration": MessageLookupByLibrary.simpleMessage("Duration"),
    "email": MessageLookupByLibrary.simpleMessage("Email address"),
    "emailIsNotValid": MessageLookupByLibrary.simpleMessage("Email address is not valid"),
    "emailIsRequired": MessageLookupByLibrary.simpleMessage("Email address is required"),
    "emailNotificationsSetting": MessageLookupByLibrary.simpleMessage("Email Notifications"),
    "emailSentTo": m6,
    "en": MessageLookupByLibrary.simpleMessage("English"),
    "es": MessageLookupByLibrary.simpleMessage("Spanish"),
    "existingSubscriptionDesc": m7,
    "existingSubscriptionTitle": MessageLookupByLibrary.simpleMessage(
      "You can logout and try with your email or ignore this warning",
    ),
    "failedToConnectError": m8,
    "failedToSubmitFeedback": MessageLookupByLibrary.simpleMessage(
      "Failed to submit feedback. Please try again.",
    ),
    "failedToSubscribe": MessageLookupByLibrary.simpleMessage(
      "Something went wrong with your subscription. Please try again!",
    ),
    "failedToVerifySubs": MessageLookupByLibrary.simpleMessage(
      "We couldn\'t verify your last subscription purchase. Click the button below to retry verification.",
    ),
    "fastLabel": MessageLookupByLibrary.simpleMessage("Fast"),
    "featureToggleMinVersionNotSatisfied": MessageLookupByLibrary.simpleMessage(
      "Your app version is outdated. Please update the app to continue using it.",
    ),
    "formValidationError": MessageLookupByLibrary.simpleMessage(
      "Invalid form data. Please check the fields and try again.",
    ),
    "fr": MessageLookupByLibrary.simpleMessage("French"),
    "france": MessageLookupByLibrary.simpleMessage("France"),
    "frequentDisconnectsReason": MessageLookupByLibrary.simpleMessage("Frequent disconnects"),
    "fullPriceLabel": MessageLookupByLibrary.simpleMessage("Full price:"),
    "germany": MessageLookupByLibrary.simpleMessage("Germany"),
    "getAPlanBtn": MessageLookupByLibrary.simpleMessage("Get a plan"),
    "getNewIPAddress": MessageLookupByLibrary.simpleMessage("Get a new IP address on refresh"),
    "getSubscriptionModalDesc": MessageLookupByLibrary.simpleMessage(
      "Secure your connection and enjoy private browsing instantly",
    ),
    "getSubscriptionModalTitle": m9,
    "getSubscriptionPlanBtn": m10,
    "gettingIPAddress": MessageLookupByLibrary.simpleMessage("Getting IP address..."),
    "goBackButton": MessageLookupByLibrary.simpleMessage("Go Back"),
    "goToLoginBtn": MessageLookupByLibrary.simpleMessage("Go to log in"),
    "helpSupportLbl": MessageLookupByLibrary.simpleMessage("Help & Support"),
    "hi": MessageLookupByLibrary.simpleMessage("Hindi"),
    "hiddenLbl": MessageLookupByLibrary.simpleMessage("Hidden"),
    "highLatencyReason": MessageLookupByLibrary.simpleMessage("High latency"),
    "highSpeed": MessageLookupByLibrary.simpleMessage("Datacenter"),
    "homeLbl": MessageLookupByLibrary.simpleMessage("Home"),
    "id": MessageLookupByLibrary.simpleMessage("Indonesian"),
    "incorrectLocationReason": MessageLookupByLibrary.simpleMessage("Incorrect location"),
    "incorrectMagicLink": MessageLookupByLibrary.simpleMessage(
      "Incorrect magic link. Please try again.",
    ),
    "ipAddressLbl": MessageLookupByLibrary.simpleMessage("IP address"),
    "ipDetails": MessageLookupByLibrary.simpleMessage("IP details"),
    "ipPool": MessageLookupByLibrary.simpleMessage("IP pool"),
    "ipPoolLabel": m11,
    "ipRefreshExhaustedCity": m12,
    "ipRefreshExhaustedCountry": m13,
    "ipType": MessageLookupByLibrary.simpleMessage("IP type"),
    "ipTypeDataCenter": MessageLookupByLibrary.simpleMessage("Datacenter IPs"),
    "ipTypeDataCenterDisclaimer": MessageLookupByLibrary.simpleMessage(
      "Datacenter IPs optimised for speed and performance.",
    ),
    "ipTypeResidential": MessageLookupByLibrary.simpleMessage("Residential IPs"),
    "ipTypeResidentialDisclaimer": MessageLookupByLibrary.simpleMessage(
      "Provided by real households. Nearly undetectable but less stable.",
    ),
    "ipTypeResidentialTooltipBody": MessageLookupByLibrary.simpleMessage(
      "Residential IPs are provided by real household devices, so availability can change over time.\n\nIf a node goes offline, the app reconnects you to the nearest available residential IP.",
    ),
    "ipTypeResidentialTooltipTitle": MessageLookupByLibrary.simpleMessage("Why can my IP change?"),
    "it": MessageLookupByLibrary.simpleMessage("Italian"),
    "italy": MessageLookupByLibrary.simpleMessage("Italy"),
    "ja": MessageLookupByLibrary.simpleMessage("Japanese"),
    "keepSubscriptionBtn": MessageLookupByLibrary.simpleMessage("Keep subscription"),
    "killSwitch": MessageLookupByLibrary.simpleMessage("Kill switch"),
    "killSwitchDesc": MessageLookupByLibrary.simpleMessage(
      "Blocks internet traffic if the VPN connection drops",
    ),
    "languageSettingLbl": MessageLookupByLibrary.simpleMessage("Language"),
    "light": MessageLookupByLibrary.simpleMessage("Light"),
    "linkCopied": MessageLookupByLibrary.simpleMessage("Link copied to clipboard!"),
    "linkExpires": MessageLookupByLibrary.simpleMessage(
      "The link expires in 30 minutes and can be used only once.",
    ),
    "location": MessageLookupByLibrary.simpleMessage("Location"),
    "locationItemCityCount": m14,
    "locationItemNodeCount": m15,
    "locationItemStatesCount": m16,
    "locationLbl": MessageLookupByLibrary.simpleMessage("Location"),
    "locationUnavailableAction": MessageLookupByLibrary.simpleMessage("Connect to nearest IP"),
    "locationUnavailableSubtitle": MessageLookupByLibrary.simpleMessage(
      "Connect to the nearest IP - or choose it manually",
    ),
    "locationUnavailableTitle": m17,
    "locationsUpdateFailed": m18,
    "locationsUpdated": m19,
    "loginSessionExpired": MessageLookupByLibrary.simpleMessage(
      "Your session has expired. Please log in again.",
    ),
    "loginSignupLabel": MessageLookupByLibrary.simpleMessage("Log in or sign up"),
    "logout": MessageLookupByLibrary.simpleMessage("Log out"),
    "logoutConfirmationDesc": MessageLookupByLibrary.simpleMessage(
      "You’re about to log out. Are you sure?",
    ),
    "logoutConfirmationTitle": MessageLookupByLibrary.simpleMessage("Log out"),
    "logoutVPNConnectedDesc": MessageLookupByLibrary.simpleMessage(
      "VPN is on. You will be disconnected from the VPN server if you continue to log out.",
    ),
    "lowLatencyReason": MessageLookupByLibrary.simpleMessage("Low latency"),
    "madridLbl": MessageLookupByLibrary.simpleMessage("Madrid, Spain 🇪🇸"),
    "malwareLbl": MessageLookupByLibrary.simpleMessage("Malware"),
    "manageOnWebBtn": MessageLookupByLibrary.simpleMessage("Manage on the web"),
    "marketingConsentPopupDesc": MessageLookupByLibrary.simpleMessage(
      "Would you like to receive email updates, privacy tips, and special offers from Mysterium Network?",
    ),
    "marketingConsentPopupTitle": MessageLookupByLibrary.simpleMessage("Stay updated by email"),
    "month": MessageLookupByLibrary.simpleMessage("month"),
    "monthly": MessageLookupByLibrary.simpleMessage("monthly"),
    "myIp": MessageLookupByLibrary.simpleMessage("My IP"),
    "navLocations": MessageLookupByLibrary.simpleMessage("Locations"),
    "navMap": MessageLookupByLibrary.simpleMessage("Map"),
    "navProducts": MessageLookupByLibrary.simpleMessage("Products"),
    "nextBilling": m20,
    "nextBillingDateLbl": MessageLookupByLibrary.simpleMessage("Next billing date:"),
    "no": MessageLookupByLibrary.simpleMessage("No"),
    "noActiveSubsDesc": MessageLookupByLibrary.simpleMessage("You have no active subscription"),
    "noEmailApp": MessageLookupByLibrary.simpleMessage("There are no email apps on your device."),
    "noLocationsFound": MessageLookupByLibrary.simpleMessage("No locations found"),
    "noServersAvailable": MessageLookupByLibrary.simpleMessage("No servers are available"),
    "noServersAvailableSub": MessageLookupByLibrary.simpleMessage(
      "There is connectivity issue and no servers are available. Please try later.",
    ),
    "noSubscriptionAction": MessageLookupByLibrary.simpleMessage("Get plan"),
    "noSubscriptionTitle": MessageLookupByLibrary.simpleMessage("No active plan available"),
    "noneLbl": MessageLookupByLibrary.simpleMessage("None"),
    "notAvailableMsg": MessageLookupByLibrary.simpleMessage("Not available"),
    "notNowBtn": MessageLookupByLibrary.simpleMessage("Not now"),
    "notReadyToCancelTitle": MessageLookupByLibrary.simpleMessage("Not ready to cancel?"),
    "nsfwLbl": MessageLookupByLibrary.simpleMessage("NSFW & Malware"),
    "onboardingStep1Desc": MessageLookupByLibrary.simpleMessage(
      "Your IP and location are visible to websites, trackers and public Wi-Fi networks.",
    ),
    "onboardingStep1Title": MessageLookupByLibrary.simpleMessage("Your connection is exposed"),
    "onboardingStep2Desc": MessageLookupByLibrary.simpleMessage(
      "Mysterium VPN masks your IP, ISP and location so you can browse with real privacy.",
    ),
    "onboardingStep2Title": MessageLookupByLibrary.simpleMessage(
      "Hide your real identity in one tap",
    ),
    "onboardingStep3Desc": MessageLookupByLibrary.simpleMessage(
      "With residential IPs, your connection looks natural - not like typical VPN traffic.",
    ),
    "onboardingStep3Title": MessageLookupByLibrary.simpleMessage("Not all VPNs work the same"),
    "openEmailApp": MessageLookupByLibrary.simpleMessage("Open email app"),
    "openSystemSettingsBtn": MessageLookupByLibrary.simpleMessage("Open system settings"),
    "optional": MessageLookupByLibrary.simpleMessage("optional"),
    "or": MessageLookupByLibrary.simpleMessage("OR"),
    "orSelectCountryManually": MessageLookupByLibrary.simpleMessage(
      "We\'ll connect you to the best server - or you can manually select a country.",
    ),
    "otherReason": MessageLookupByLibrary.simpleMessage("Other..."),
    "pauseDurationRequiredError": MessageLookupByLibrary.simpleMessage(
      "Please select one of the pause durations.",
    ),
    "pauseForMonths": m21,
    "pauseSubscriptionBtn": MessageLookupByLibrary.simpleMessage("Pause subscription"),
    "pauseSubscriptionInfoDesc": MessageLookupByLibrary.simpleMessage(
      "You can pause your plan once per billing cycle.",
    ),
    "paused": MessageLookupByLibrary.simpleMessage("Paused"),
    "pausedUntil": m22,
    "pendingTransactionMessage": MessageLookupByLibrary.simpleMessage(
      "You already have an ongoing payment transaction. Please complete it before starting a new one.",
    ),
    "perMonth": MessageLookupByLibrary.simpleMessage("mo"),
    "pl": MessageLookupByLibrary.simpleMessage("Polish"),
    "planAlreadyPurchasedMsg": MessageLookupByLibrary.simpleMessage(
      "You\'re all set! You already have this plan active.",
    ),
    "plan_2_years": MessageLookupByLibrary.simpleMessage("2-Year Plan"),
    "plan_2_years_basic": MessageLookupByLibrary.simpleMessage("Basic 2-Year"),
    "plan_2_years_pro": MessageLookupByLibrary.simpleMessage("Pro 2-Year"),
    "plan_6_months": MessageLookupByLibrary.simpleMessage("6-Month Plan"),
    "plan_monthly": MessageLookupByLibrary.simpleMessage("Monthly Plan"),
    "plan_monthly_basic": MessageLookupByLibrary.simpleMessage("Basic monthly"),
    "plan_monthly_plus": MessageLookupByLibrary.simpleMessage("Plus monthly"),
    "plan_monthly_pro": MessageLookupByLibrary.simpleMessage("Pro monthly"),
    "plan_yearly": MessageLookupByLibrary.simpleMessage("Annual Plan"),
    "plan_yearly_basic": MessageLookupByLibrary.simpleMessage("Basic annual"),
    "plan_yearly_plus": MessageLookupByLibrary.simpleMessage("Plus annual"),
    "plan_yearly_pro": MessageLookupByLibrary.simpleMessage("Pro annual"),
    "poland": MessageLookupByLibrary.simpleMessage("Poland"),
    "preferences": MessageLookupByLibrary.simpleMessage("Preferences"),
    "pricingPlanSeePlansBtn": MessageLookupByLibrary.simpleMessage("See all plans"),
    "privacyPolicy": MessageLookupByLibrary.simpleMessage("Privacy Policy"),
    "processingPayment": MessageLookupByLibrary.simpleMessage(
      "We’re processing your payment. You’ll be all set shortly…",
    ),
    "productsActivePlanWebSyncAlert": MessageLookupByLibrary.simpleMessage(
      "You already have an active plan. Upgrade on the web — changes sync automatically.",
    ),
    "productsAllPlansLbl": MessageLookupByLibrary.simpleMessage("All plans:"),
    "productsBasicDescription": MessageLookupByLibrary.simpleMessage(
      "Essentials for everyday privacy",
    ),
    "productsDuration1Month": MessageLookupByLibrary.simpleMessage("1 month"),
    "productsDuration1Year": MessageLookupByLibrary.simpleMessage("1-Year"),
    "productsDuration2Year": MessageLookupByLibrary.simpleMessage("2-Year"),
    "productsExploreSubtitle": MessageLookupByLibrary.simpleMessage("Explore plans and features"),
    "productsManageSubtitle": MessageLookupByLibrary.simpleMessage("Manage and upgrade on the web"),
    "productsMaxPlanAlert": MessageLookupByLibrary.simpleMessage(
      "You\'re already on the highest plan available.",
    ),
    "productsNotAvailable": MessageLookupByLibrary.simpleMessage(
      "There are no available products at the moment. Please try again later.",
    ),
    "productsPlusDescription": MessageLookupByLibrary.simpleMessage("More devices, more locations"),
    "productsProDescription": MessageLookupByLibrary.simpleMessage(
      "Maximum protection for heavy users",
    ),
    "productsSubscribeWebAlert": MessageLookupByLibrary.simpleMessage(
      "Subscriptions are managed on the web. Your plan will sync with the app automatically.",
    ),
    "productsSubscribeWebSubtitle": MessageLookupByLibrary.simpleMessage("Subscribe on the web"),
    "productsTitle": MessageLookupByLibrary.simpleMessage("VPN products"),
    "protectedLbl": MessageLookupByLibrary.simpleMessage("PROTECTED"),
    "protocol": MessageLookupByLibrary.simpleMessage("Protocol"),
    "protocolLabel": m23,
    "protocolPickerSettingDesc": MessageLookupByLibrary.simpleMessage(
      "Switching the VPN protocol will disconnect you. You’ll need to reconnect afterwards.",
    ),
    "protocolPickerSettingTitle": MessageLookupByLibrary.simpleMessage("Switching VPN protocol"),
    "pt": MessageLookupByLibrary.simpleMessage("Portuguese"),
    "ptBR": MessageLookupByLibrary.simpleMessage("Brazilian Portuguese"),
    "pushNotificationsConsentPopupDesc": MessageLookupByLibrary.simpleMessage(
      "Get notified about new features, helpful tips, and exclusive offers - just useful updates.",
    ),
    "pushNotificationsConsentPopupTitle": MessageLookupByLibrary.simpleMessage(
      "Stay up to date with push notifications",
    ),
    "pushNotificationsSetting": MessageLookupByLibrary.simpleMessage("Push Notifications"),
    "pushNotificationsSettingDesc": MessageLookupByLibrary.simpleMessage(
      "Product updates, tips, and special offers",
    ),
    "qaToolboxLbl": MessageLookupByLibrary.simpleMessage("QA Toolbox"),
    "rateConnection": MessageLookupByLibrary.simpleMessage("How is your connection?"),
    "rateConnectionDislike": MessageLookupByLibrary.simpleMessage("What didn’t you like?"),
    "rateConnectionLike": MessageLookupByLibrary.simpleMessage("What did you like?"),
    "reactivateSubscriptionAnytimeDesc": MessageLookupByLibrary.simpleMessage(
      "You can reactivate your subscription anytime before your access ends.",
    ),
    "recentLocations": MessageLookupByLibrary.simpleMessage("Recent locations"),
    "redeemDiscountCode": MessageLookupByLibrary.simpleMessage("Redeem discount code"),
    "redirectToLoginPage": MessageLookupByLibrary.simpleMessage(
      "Your account has been successfully deleted. You\'ll be redirected to the log in screen.",
    ),
    "refresh": MessageLookupByLibrary.simpleMessage("Refresh"),
    "refreshIP": MessageLookupByLibrary.simpleMessage("Refresh IP"),
    "refreshIPAddress": MessageLookupByLibrary.simpleMessage("Refresh IP address"),
    "refreshLocationsTooltip": m24,
    "renewsOn": m25,
    "resetAppDesc": MessageLookupByLibrary.simpleMessage("Reset when something isn\'t working"),
    "resetAppDialogContent": MessageLookupByLibrary.simpleMessage(
      "If you proceed with resetting the app, you will be disconnected from the Mysterium VPN.",
    ),
    "resetAppDialogTitle": MessageLookupByLibrary.simpleMessage(
      "VPN connection is currently active",
    ),
    "resetAppFailed": MessageLookupByLibrary.simpleMessage(
      "Failed to reset the app. Please try again.",
    ),
    "resetAppSuccess": MessageLookupByLibrary.simpleMessage("App has been reset successfully."),
    "resetAppTitle": MessageLookupByLibrary.simpleMessage("Reset app"),
    "resetBtn": MessageLookupByLibrary.simpleMessage("Reset"),
    "residential": MessageLookupByLibrary.simpleMessage("Residential"),
    "residentialCentreComparisonCardItem1": MessageLookupByLibrary.simpleMessage(
      "Looks like a real user",
    ),
    "residentialCentreComparisonCardItem2": MessageLookupByLibrary.simpleMessage(
      "Harder to detect",
    ),
    "residentialCentreComparisonCardItem3": MessageLookupByLibrary.simpleMessage("Fewer blocks"),
    "residentialCentreComparisonCardLbl": MessageLookupByLibrary.simpleMessage("RESIDENTIAL IPS"),
    "residentialEducationBlock1Body": MessageLookupByLibrary.simpleMessage(
      "Residential IPs come from real household devices, making your traffic look like regular internet activity.",
    ),
    "residentialEducationBlock1Title": MessageLookupByLibrary.simpleMessage(
      "Real household devices",
    ),
    "residentialEducationBlock2Body": MessageLookupByLibrary.simpleMessage(
      "Because these IPs are provided by real devices, some nodes may go offline from time to time.",
    ),
    "residentialEducationBlock2Title": MessageLookupByLibrary.simpleMessage(
      "Availability can change",
    ),
    "residentialEducationBlock3Body": MessageLookupByLibrary.simpleMessage(
      "If your current IP becomes unavailable, the app reconnects you to the nearest available residential IP.",
    ),
    "residentialEducationBlock3Title": MessageLookupByLibrary.simpleMessage(
      "Automatic reconnection",
    ),
    "residentialEducationGotIt": MessageLookupByLibrary.simpleMessage("Got it"),
    "residentialEducationSubtitle": MessageLookupByLibrary.simpleMessage(
      "Residential IPs are different from datacenter IPs. Here’s what to expect.",
    ),
    "residentialEducationTitle": MessageLookupByLibrary.simpleMessage("How Residential IPs work"),
    "resumeBtn": MessageLookupByLibrary.simpleMessage("Resume"),
    "resumeSubscriptionPromptDesc": MessageLookupByLibrary.simpleMessage(
      "Your subscription will resume immediately.",
    ),
    "resumeSubscriptionTitle": MessageLookupByLibrary.simpleMessage("Resume Subscription?"),
    "retryBtn": MessageLookupByLibrary.simpleMessage("Retry"),
    "reviewLeaveReviewBtn": MessageLookupByLibrary.simpleMessage("Leave a review"),
    "reviewPositiveTitle": MessageLookupByLibrary.simpleMessage(
      "That’s great! Would you mind leaving us a review?",
    ),
    "reviewSatisfactionTitle": MessageLookupByLibrary.simpleMessage(
      "Would you recommend this app to others?",
    ),
    "searchForLocations": MessageLookupByLibrary.simpleMessage("Search for locations"),
    "seePlansBtn": MessageLookupByLibrary.simpleMessage("See plans"),
    "selectEmailApp": MessageLookupByLibrary.simpleMessage("Select Email App to Continue"),
    "semiAnnual": MessageLookupByLibrary.simpleMessage("semi-annually"),
    "sendAgain": m26,
    "serviceUnavailableError": MessageLookupByLibrary.simpleMessage(
      "We’re experiencing temporary network issues. Please try again later.",
    ),
    "settingManageBtn": MessageLookupByLibrary.simpleMessage("Manage"),
    "settings": MessageLookupByLibrary.simpleMessage("Settings"),
    "setupTunnerPermissionsDialogDesc": MessageLookupByLibrary.simpleMessage(
      "In order to use Mysterium VPN, we need your permission to install a VPN profile.",
    ),
    "setupTunnerPermissionsDialogDisclaimer": MessageLookupByLibrary.simpleMessage(
      "Your anonymity is secure. We don\'t see, collect or store any of your browsing activity.",
    ),
    "setupTunnerPermissionsDialogTitle": MessageLookupByLibrary.simpleMessage(
      "We need your permission",
    ),
    "signIn": MessageLookupByLibrary.simpleMessage("Sign in to Mysterium VPN"),
    "signInAbortedMsg": MessageLookupByLibrary.simpleMessage("Sign in aborted"),
    "signInBtn": MessageLookupByLibrary.simpleMessage("Sign in"),
    "signInDisclaimer": MessageLookupByLibrary.simpleMessage(
      "Mysterium VPN does not log your online activities, and no records are tied to you, your device, your IP address, or your email. By signing in, you agree with our",
    ),
    "sixMonths": MessageLookupByLibrary.simpleMessage("6 months"),
    "skipBtn": MessageLookupByLibrary.simpleMessage("Skip"),
    "somethingWentWrong": MessageLookupByLibrary.simpleMessage(
      "Something went wrong. Please try again!",
    ),
    "stableConnectionReason": MessageLookupByLibrary.simpleMessage("Stable connection"),
    "status": MessageLookupByLibrary.simpleMessage("Status"),
    "stayButton": MessageLookupByLibrary.simpleMessage("Stay"),
    "stayOnAppBtn": MessageLookupByLibrary.simpleMessage("Stay on the app"),
    "submitBtn": MessageLookupByLibrary.simpleMessage("Submit"),
    "subscribeOnWebBtn": MessageLookupByLibrary.simpleMessage("Subscribe on the web"),
    "subscriptionActive": MessageLookupByLibrary.simpleMessage(
      "Great news! Your subscription is now active.",
    ),
    "subscriptionAllPlansBackToPlans": MessageLookupByLibrary.simpleMessage("Back to plans"),
    "subscriptionAllPlansCompareAll": MessageLookupByLibrary.simpleMessage("Compare all features"),
    "subscriptionAllPlansCurrentPlan": MessageLookupByLibrary.simpleMessage("Current plan"),
    "subscriptionAllPlansPurchase": MessageLookupByLibrary.simpleMessage("Get plan"),
    "subscriptionAllPlansTabMonth": MessageLookupByLibrary.simpleMessage("Monthly"),
    "subscriptionAllPlansTabYear": MessageLookupByLibrary.simpleMessage("1-Year"),
    "subscriptionAllPlansTitle": MessageLookupByLibrary.simpleMessage("All plans"),
    "subscriptionAllPlansUpgrade": MessageLookupByLibrary.simpleMessage("Upgrade your plan"),
    "subscriptionCancelledTitle": MessageLookupByLibrary.simpleMessage("Subscription cancelled"),
    "subscriptionOnboardingBoostProtectionDescription": MessageLookupByLibrary.simpleMessage(
      "Explore advanced features like VPN protocols and malware blocking.",
    ),
    "subscriptionOnboardingBoostProtectionTitle": MessageLookupByLibrary.simpleMessage(
      "Boost your protection",
    ),
    "subscriptionOnboardingCancelTourLabel": MessageLookupByLibrary.simpleMessage("Skip for now"),
    "subscriptionOnboardingConnectDescription": MessageLookupByLibrary.simpleMessage(
      "We’ll connect you to the best server.",
    ),
    "subscriptionOnboardingConnectTitle": MessageLookupByLibrary.simpleMessage(
      "Connect to stay private",
    ),
    "subscriptionOnboardingManagePlanDescription": MessageLookupByLibrary.simpleMessage(
      "Purchase, upgrade or view available plans based on your account access.",
    ),
    "subscriptionOnboardingManagePlanTitle": MessageLookupByLibrary.simpleMessage(
      "Manage your plan",
    ),
    "subscriptionOnboardingMapDesktopDescription": MessageLookupByLibrary.simpleMessage(
      "Browse the map or explore locations from the sidebar.",
    ),
    "subscriptionOnboardingMapDesktopTitle": MessageLookupByLibrary.simpleMessage(
      "Explore locations your way",
    ),
    "subscriptionOnboardingMapMobileDescription": MessageLookupByLibrary.simpleMessage(
      "Browse the map to choose a country and connect instantly.",
    ),
    "subscriptionOnboardingMapMobileTitle": MessageLookupByLibrary.simpleMessage(
      "Connect from the map",
    ),
    "subscriptionOnboardingPromptDescription": MessageLookupByLibrary.simpleMessage(
      "Learn your way around the updated app and discover where key features now live.",
    ),
    "subscriptionOnboardingPromptTitle": MessageLookupByLibrary.simpleMessage("Take a quick tour"),
    "subscriptionOnboardingSearchDescription": MessageLookupByLibrary.simpleMessage(
      "Quickly find countries, cities and servers with search.",
    ),
    "subscriptionOnboardingSearchTitle": MessageLookupByLibrary.simpleMessage(
      "Search and connect faster",
    ),
    "subscriptionOnboardingSetupCompleteDescription": MessageLookupByLibrary.simpleMessage(
      "Choose a location to start browsing more privately.",
    ),
    "subscriptionOnboardingSetupCompleteTitle": MessageLookupByLibrary.simpleMessage(
      "Setup complete",
    ),
    "subscriptionOnboardingStartTourLabel": MessageLookupByLibrary.simpleMessage("Start tour"),
    "subscriptionOnboardingVPNLocationsDesktopDescription": MessageLookupByLibrary.simpleMessage(
      "Explore countries and cities in one place.",
    ),
    "subscriptionOnboardingVPNLocationsMobileDescription": MessageLookupByLibrary.simpleMessage(
      "Explore countries, cities, recent connections and specialty servers in one place.",
    ),
    "subscriptionOnboardingVPNLocationsTitle": MessageLookupByLibrary.simpleMessage(
      "Browse VPN locations",
    ),
    "subscriptionPlanBestValue": MessageLookupByLibrary.simpleMessage("BEST VALUE"),
    "subscriptionPlanCityLevel": MessageLookupByLibrary.simpleMessage("City-level choices"),
    "subscriptionPlanCityLevelDesc": MessageLookupByLibrary.simpleMessage(
      "Provides more precise location control than most VPNs, which typically limit you to selecting entire countries or states.",
    ),
    "subscriptionPlanDevicesSecured": MessageLookupByLibrary.simpleMessage(
      "Devices secured at once",
    ),
    "subscriptionPlanDoubleVPN": MessageLookupByLibrary.simpleMessage("Double VPN"),
    "subscriptionPlanDoubleVPNDesc": MessageLookupByLibrary.simpleMessage(
      "Extra layer of security. Routes your internet traffic through two different VPN servers, encrypting your data twice and masking your IP address behind a second server",
    ),
    "subscriptionPlanMalwareBlocker": MessageLookupByLibrary.simpleMessage("Malware blocker"),
    "subscriptionPlanMalwareBlockerDesc": MessageLookupByLibrary.simpleMessage(
      "Protects your device by stopping threats before they can reach it, running quietly in the background without interrupting you.",
    ),
    "subscriptionPlanMoneyBack": MessageLookupByLibrary.simpleMessage("7-day money-back guarantee"),
    "subscriptionPlanNameBasic": MessageLookupByLibrary.simpleMessage("Basic"),
    "subscriptionPlanNamePlus": MessageLookupByLibrary.simpleMessage("Plus"),
    "subscriptionPlanNamePro": MessageLookupByLibrary.simpleMessage("Pro"),
    "subscriptionPlanPF1Basic": MessageLookupByLibrary.simpleMessage("Secure 6 devices at a time"),
    "subscriptionPlanPF1Plus": MessageLookupByLibrary.simpleMessage("Secure 10 devices at a time"),
    "subscriptionPlanPF2Basic": MessageLookupByLibrary.simpleMessage("57 supported countries"),
    "subscriptionPlanPF2Plus": MessageLookupByLibrary.simpleMessage("100+ supported countries"),
    "subscriptionPlanPF3Basic": MessageLookupByLibrary.simpleMessage("10 servers"),
    "subscriptionPlanPF3Plus": MessageLookupByLibrary.simpleMessage("100 servers"),
    "subscriptionPlanPF4Basic": MessageLookupByLibrary.simpleMessage("VPN protocol"),
    "subscriptionPlanPF4Plus": MessageLookupByLibrary.simpleMessage("7,500+ residential IPs"),
    "subscriptionPlanPF5Plus": MessageLookupByLibrary.simpleMessage("VPN protocol"),
    "subscriptionPlanPF6Plus": MessageLookupByLibrary.simpleMessage("City-level choices"),
    "subscriptionPlanResidentialIPs": MessageLookupByLibrary.simpleMessage("Residential IPs"),
    "subscriptionPlanResidentialIPsDesc": MessageLookupByLibrary.simpleMessage(
      "Appear as a normal home user, letting you access streaming services and avoid VPN detection.",
    ),
    "subscriptionPlanSavePercent": m27,
    "subscriptionPlanSaveWith": m28,
    "subscriptionPlanServers": MessageLookupByLibrary.simpleMessage("Servers"),
    "subscriptionPlanSupportedCountries": MessageLookupByLibrary.simpleMessage(
      "Supported countries",
    ),
    "subscriptionPlanWireGuard": MessageLookupByLibrary.simpleMessage("VPN protocol"),
    "subscriptionPlanWireGuardDesc": MessageLookupByLibrary.simpleMessage(
      "WireGuard - fast protocol best for gaming and streaming\nOpenVPN - highly configurable protocol that works where other protocols fail (not available on Android)",
    ),
    "subscriptionProcessCanceled": MessageLookupByLibrary.simpleMessage(
      "You didn\'t complete the changes to your subscription.",
    ),
    "subscriptionResumed": MessageLookupByLibrary.simpleMessage(
      "Your subscription is active again.",
    ),
    "subscriptionUpgrade": MessageLookupByLibrary.simpleMessage("Upgrade"),
    "subscriptionUpgradeCTA": m29,
    "subscriptionUpgradeModalDescription": MessageLookupByLibrary.simpleMessage(
      "to access 7,500+ residential IPs",
    ),
    "subscriptionUpgradeModalTitle": m30,
    "subscriptionUpgradeSeeAllPlans": MessageLookupByLibrary.simpleMessage("See all plans"),
    "subscriptionVerificationFailed": MessageLookupByLibrary.simpleMessage("Retry Verification"),
    "subscripton": MessageLookupByLibrary.simpleMessage("Subscription"),
    "switchToLocationBtn": m31,
    "system": MessageLookupByLibrary.simpleMessage("Default"),
    "takeBackTheInternetLbl": MessageLookupByLibrary.simpleMessage("Take back the internet."),
    "termsAndConditions": MessageLookupByLibrary.simpleMessage("Terms and Conditions"),
    "title": MessageLookupByLibrary.simpleMessage("Hello Sir"),
    "toManyRequestsErrorMsg": MessageLookupByLibrary.simpleMessage(
      "Too many requests. Please try again later.",
    ),
    "tokenAlreadyUsed": MessageLookupByLibrary.simpleMessage(
      "Token already used. Please try again.\n",
    ),
    "tooManyConnectionsBannerCTADisconnect": MessageLookupByLibrary.simpleMessage("Disconnect"),
    "tooManyConnectionsBannerCTAReconnect": MessageLookupByLibrary.simpleMessage("Reconnect"),
    "tooManyConnectionsBannerDesc": MessageLookupByLibrary.simpleMessage(
      "You’ve reached the maximum limit of 6 connected devices on your account. To continue using VPN, click to reconnect.",
    ),
    "tooManyConnectionsBannerDescConnected": MessageLookupByLibrary.simpleMessage(
      "You’ve reached the maximum limit of 6 connected devices on your account. To continue using VPN, click disconnect and try again.",
    ),
    "tooManyConnectionsBannerTitle": MessageLookupByLibrary.simpleMessage(
      "You\'ve Been Disconnected",
    ),
    "topLocations": MessageLookupByLibrary.simpleMessage("Top locations"),
    "tr": MessageLookupByLibrary.simpleMessage("Turkish"),
    "tryAgainBtn": MessageLookupByLibrary.simpleMessage("Try again"),
    "tryAnotherLocation": MessageLookupByLibrary.simpleMessage(
      "Try searching for another location",
    ),
    "tunnelPermissionRequired": MessageLookupByLibrary.simpleMessage(
      "You need to grant permission to start VPN tunnel.",
    ),
    "tunnelSetupError": MessageLookupByLibrary.simpleMessage(
      "Error occurred while setting up tunnel",
    ),
    "typeDelete": m32,
    "typeFeedback": MessageLookupByLibrary.simpleMessage("Type your feedback here..."),
    "ukraine": MessageLookupByLibrary.simpleMessage("Ukraine"),
    "unableToConnectToPaymentProcesor": MessageLookupByLibrary.simpleMessage(
      "Unable to connect to the payment processor! Please try again.",
    ),
    "unauthenticatedBannerTitle": MessageLookupByLibrary.simpleMessage("You\'re not signed in"),
    "unauthenticatedSettingSubtitle": MessageLookupByLibrary.simpleMessage(
      "Sign in to access your account and unlock all features",
    ),
    "unauthenticatedSettingTitle": MessageLookupByLibrary.simpleMessage("You\'re not signed in"),
    "unprotectedLbl": MessageLookupByLibrary.simpleMessage("UNPROTECTED"),
    "unstableSpeedReason": MessageLookupByLibrary.simpleMessage("Unstable speed"),
    "updateBtn": MessageLookupByLibrary.simpleMessage("Update"),
    "userIntentBestSpeed": MessageLookupByLibrary.simpleMessage("Best speed"),
    "userIntentBestSpeedDesc": MessageLookupByLibrary.simpleMessage(
      "Connect to the fastest available server for optimal performance",
    ),
    "userIntentLabel": MessageLookupByLibrary.simpleMessage("Speciality server"),
    "userIntentLowLatency": MessageLookupByLibrary.simpleMessage("Low latency"),
    "userIntentLowLatencyDesc": MessageLookupByLibrary.simpleMessage(
      "Automatically connects you to the closest server for stable and reliable access",
    ),
    "userIntentMaxPrivacy": MessageLookupByLibrary.simpleMessage("Max privacy"),
    "userIntentMaxPrivacyDesc": MessageLookupByLibrary.simpleMessage(
      "Get a server with the best free speech and speed options based on country",
    ),
    "userIntentNearestLocation": MessageLookupByLibrary.simpleMessage("Nearest location"),
    "userIntentNearestLocationDesc": MessageLookupByLibrary.simpleMessage(
      "Connects you to the closest available VPN IP for the best speed and performance based on your current location",
    ),
    "userIntentP2P": MessageLookupByLibrary.simpleMessage("P2P"),
    "userIntentP2PDesc": MessageLookupByLibrary.simpleMessage(
      "Pick the best server for secure crypto transactions, file sharing, game hosting, and communications",
    ),
    "userIntentStreaming": MessageLookupByLibrary.simpleMessage("Streaming"),
    "userIntentStreamingDesc": MessageLookupByLibrary.simpleMessage(
      "Access your favorite shows and movies from region-specific platforms",
    ),
    "viewAllFeaturesBtn": MessageLookupByLibrary.simpleMessage("View all features"),
    "viewLessBtn": MessageLookupByLibrary.simpleMessage("View less"),
    "vodafoneLbl": MessageLookupByLibrary.simpleMessage("Vodafone Iberia"),
    "vpnDetails": MessageLookupByLibrary.simpleMessage("VPN details"),
    "vpnIp": MessageLookupByLibrary.simpleMessage("VPN IP"),
    "vpnProtocolSettingLbl": MessageLookupByLibrary.simpleMessage("VPN protocol"),
    "year": MessageLookupByLibrary.simpleMessage("year"),
    "yearly": MessageLookupByLibrary.simpleMessage("yearly"),
    "yes": MessageLookupByLibrary.simpleMessage("Yes"),
    "zh": MessageLookupByLibrary.simpleMessage("Chinese"),
  };
}
