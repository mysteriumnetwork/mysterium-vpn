// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a hi locale. All the
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
  String get localeName => 'hi';

  static String m0(date) => "${date} तक पहुंच उपलब्ध";

  static String m1(store) =>
      "आपके पास पहले से ${store} के ज़रिए भुगतान की गई सक्रिय सदस्यता है। इसे ${store} में प्रबंधित करें।";

  static String m2(amount, period) => "${amount} /${period}";

  static String m3(amount, period) => "${amount}/माह — ${period} बिल किया गया";

  static String m4(location) => "${location} से कनेक्ट करें";

  static String m5(couponCode) => "${couponCode} क्लिपबोर्ड पर कॉपी हुआ!";

  static String m6(email) => "हमने ${email} पर एक ईमेल भेजा है";

  static String m7(email) => "शायद आपके पास पहले से “${email}” के साथ एक सशुल्क सदस्यता है";

  static String m8(errorCode) =>
      "कनेक्ट नहीं हो सका। कृपया फिर से प्रयास करें [error: ${errorCode}]";

  static String m9(plan) => "${plan} लें";

  static String m10(plan) => "${plan} प्लान लें";

  static String m11(count) => "IP पूल: ${count}";

  static String m12(location) =>
      "${location} में कोई वैकल्पिक IP उपलब्ध नहीं है। अगली बार अलग IP पाने के लिए कोई दूसरा देश या शहर चुनें।";

  static String m13(location) =>
      "${location} में कोई वैकल्पिक IP उपलब्ध नहीं है। अगली बार अलग IP पाने के लिए कोई दूसरा देश चुनें।";

  static String m14(count) =>
      "${Intl.plural(count, one: '${count} City', other: '${count} Cities')}";

  static String m15(count) => "${Intl.plural(count, one: '${count} IP', other: '${count} IPs')}";

  static String m16(count) =>
      "${Intl.plural(count, one: '${count} State', other: '${count} States')}";

  static String m17(location) => "${location} उपलब्ध नहीं है";

  static String m18(location) => "${location} अपडेट नहीं हो सका";

  static String m19(location) => "${location} अपडेट हुआ";

  static String m20(date) => "अगला बिलिंग: ${date}";

  static String m21(count) =>
      "${Intl.plural(count, zero: '', one: '${count} महीने के लिए रोकें', other: '${count} महीनों के लिए रोकें')}";

  static String m22(date) => "${date} तक रोका गया";

  static String m23(protocol, label) => "${protocol} (${label})";

  static String m24(location) => "${location} रिफ्रेश करें";

  static String m25(date) => "${date} को नवीनीकृत होगा";

  static String m26(count) =>
      "${Intl.plural(count, one: 'फिर से भेजें', other: 'फिर से भेजें (${count})')}";

  static String m27(percent) => "${percent}% की बचत";

  static String m28(percent, planId) => "${planId} प्लान के साथ ${percent}% की बचत";

  static String m29(plan) => "${plan} में अपग्रेड करें";

  static String m30(plan) => "${plan} प्लान में अपग्रेड करें";

  static String m31(location) => "${location} पर स्विच करें";

  static String m32(word) => "${word} टाइप करें";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "LoggingYouIn": MessageLookupByLibrary.simpleMessage("आपको लॉग इन किया जा रहा है…"),
    "acceptOfferBtn": MessageLookupByLibrary.simpleMessage("ऑफ़र स्वीकार करें"),
    "accessAvailableUntilLbl": MessageLookupByLibrary.simpleMessage("पहुँच उपलब्ध है:"),
    "accessBlockedSitesReason": MessageLookupByLibrary.simpleMessage(
      "ब्लॉक की गई साइटों तक पहुँच नहीं",
    ),
    "accessUntil": m0,
    "account": MessageLookupByLibrary.simpleMessage("खाता"),
    "accountSuccessfullyDeleted": MessageLookupByLibrary.simpleMessage("खाता हटाया गया"),
    "activeSubsPaidVia": m1,
    "allLocations": MessageLookupByLibrary.simpleMessage("सभी लोकेशन"),
    "allowBtn": MessageLookupByLibrary.simpleMessage("अनुमति दें"),
    "allowNotificationsBtn": MessageLookupByLibrary.simpleMessage("नोटिफिकेशन की अनुमति दें"),
    "allowPushNotificationsBtn": MessageLookupByLibrary.simpleMessage("नोटिफिकेशन की अनुमति दें"),
    "and": MessageLookupByLibrary.simpleMessage(" और "),
    "appUpdateAvailableDesc": MessageLookupByLibrary.simpleMessage(
      "ऐप का नया वर्शन आ गया है! नए फ़ीचर और सुधारों के लिए अभी अपडेट करें।",
    ),
    "appUpdateAvailableSetting": MessageLookupByLibrary.simpleMessage("ऐप अपडेट उपलब्ध है!"),
    "appUpdateAvailableTitle": MessageLookupByLibrary.simpleMessage("ऐप अपडेट उपलब्ध"),
    "appearanceSettingLbl": MessageLookupByLibrary.simpleMessage("दिखावट"),
    "ar": MessageLookupByLibrary.simpleMessage("अरबी"),
    "austria": MessageLookupByLibrary.simpleMessage("ऑस्ट्रिया"),
    "authenticationFailed": MessageLookupByLibrary.simpleMessage(
      "साइन इन नहीं हो सका। कृपया फिर से प्रयास करें।",
    ),
    "back": MessageLookupByLibrary.simpleMessage("वापस"),
    "backToSettingsLbl": MessageLookupByLibrary.simpleMessage("सेटिंग्स पर वापस"),
    "batterySaverLabel": MessageLookupByLibrary.simpleMessage("बैटरी सेवर"),
    "berlinLbl": MessageLookupByLibrary.simpleMessage("बर्लिन, जर्मनी 🇩🇪"),
    "billedInTotal": m2,
    "billedPerMonth": m3,
    "blockerSettingLbl": MessageLookupByLibrary.simpleMessage("ब्लॉकर"),
    "buttonUpdateApp": MessageLookupByLibrary.simpleMessage("अभी अपडेट करें"),
    "bypassRestrictionsReason": MessageLookupByLibrary.simpleMessage("प्रतिबंध बायपास करना"),
    "cancelBtn": MessageLookupByLibrary.simpleMessage("रद्द करें"),
    "cancelDisconnects": MessageLookupByLibrary.simpleMessage("कनेक्शन टूटना"),
    "cancelDowntimes": MessageLookupByLibrary.simpleMessage("डाउनटाइम"),
    "cancelError7040": MessageLookupByLibrary.simpleMessage("त्रुटि 7040"),
    "cancelLatency": MessageLookupByLibrary.simpleMessage("विलंबता"),
    "cancelMissingFeatures": MessageLookupByLibrary.simpleMessage("सुविधाएँ अनुपलब्ध"),
    "cancelSpeed": MessageLookupByLibrary.simpleMessage("गति"),
    "cancelSubscriptionPromptDesc": MessageLookupByLibrary.simpleMessage(
      "क्या आप वाकई अपनी सदस्यता रद्द करना चाहते हैं?",
    ),
    "cancelSubscriptionTitle": MessageLookupByLibrary.simpleMessage("सदस्यता रद्द करें"),
    "cancelSubscriptionWarningDesc": MessageLookupByLibrary.simpleMessage(
      "आपकी सदस्यता रद्द कर दी जाएगी। पहुँच समाप्त होने तक आप Mysterium VPN का उपयोग जारी रख सकते हैं।",
    ),
    "cancelSurveyFeedbackHint": MessageLookupByLibrary.simpleMessage("कृपया और विवरण दर्ज करें…"),
    "cancelSurveyTellUsMoreHint": MessageLookupByLibrary.simpleMessage("और बताएँ (वैकल्पिक)"),
    "cancelSurveyTitle": MessageLookupByLibrary.simpleMessage("रद्द करने के कारण"),
    "cancelTooExpensive": MessageLookupByLibrary.simpleMessage("बहुत महंगा"),
    "cancelUnableToAccessBlockedSites": MessageLookupByLibrary.simpleMessage(
      "अवरुद्ध साइटों तक पहुँच नहीं",
    ),
    "cancelUsabilityIssues": MessageLookupByLibrary.simpleMessage("उपयोगिता संबंधी समस्याएँ"),
    "cancelYourSubsMess": MessageLookupByLibrary.simpleMessage(
      "खाता हटाने से पहले App Store सदस्यता में अपनी सदस्यता रद्द करें।",
    ),
    "cancellationDateLbl": MessageLookupByLibrary.simpleMessage("रद्द करने की तिथि:"),
    "cancelled": MessageLookupByLibrary.simpleMessage("रद्द"),
    "checkSubsStatusFailedDesc": MessageLookupByLibrary.simpleMessage(
      "हम आपकी प्लान जानकारी प्राप्त नहीं कर पा रहे हैं।",
    ),
    "checkSubsStatusFailedTitle": MessageLookupByLibrary.simpleMessage(
      "प्लान जानकारी उपलब्ध नहीं है",
    ),
    "checkSubsStatusTitle": MessageLookupByLibrary.simpleMessage(
      "प्लान जानकारी प्राप्त हो रही है…",
    ),
    "checkYourEmail": MessageLookupByLibrary.simpleMessage("अपना ईमेल देखें"),
    "clearSearchBtn": MessageLookupByLibrary.simpleMessage("सर्च साफ़ करें"),
    "closeBtn": MessageLookupByLibrary.simpleMessage("बंद करें"),
    "communicationLbl": MessageLookupByLibrary.simpleMessage("संचार"),
    "communicationLblDesktop": MessageLookupByLibrary.simpleMessage("संचार"),
    "completeBtn": MessageLookupByLibrary.simpleMessage("पूरा करें"),
    "confirm": MessageLookupByLibrary.simpleMessage("पुष्टि करें"),
    "confirmCancellationTitle": MessageLookupByLibrary.simpleMessage("रद्दीकरण की पुष्टि करें"),
    "connect": MessageLookupByLibrary.simpleMessage("कनेक्ट करें"),
    "connectBestServer": MessageLookupByLibrary.simpleMessage("बेहतरीन सर्वर"),
    "connectToLocationBtn": m4,
    "connected": MessageLookupByLibrary.simpleMessage("कनेक्टेड"),
    "connectedSince": MessageLookupByLibrary.simpleMessage("कनेक्शन अवधि"),
    "connecting": MessageLookupByLibrary.simpleMessage("कनेक्ट हो रहा है…"),
    "connectingToPaymentProcesor": MessageLookupByLibrary.simpleMessage(
      "पेमेंट प्रोसेसर से कनेक्ट हो रहा है…",
    ),
    "connection": MessageLookupByLibrary.simpleMessage("कनेक्शन"),
    "connectionDetails": MessageLookupByLibrary.simpleMessage("कनेक्शन विवरण"),
    "connectionSettingLbl": MessageLookupByLibrary.simpleMessage("कनेक्शन और सुरक्षा"),
    "connectionTimeout": MessageLookupByLibrary.simpleMessage(
      "कनेक्शन का समय समाप्त हो गया। कृपया बाद में फिर से प्रयास करें। यदि समस्या बनी रहे तो सहायता टीम से संपर्क करें",
    ),
    "consistentSpeedReason": MessageLookupByLibrary.simpleMessage("स्थिर गति"),
    "consumeLink": MessageLookupByLibrary.simpleMessage(
      "यह केवल उसी डिवाइस पर काम करता है जिसने इसे अनुरोध किया था - जारी रखने के लिए अपने ईमेल में दिए लिंक पर क्लिक करें।",
    ),
    "continueBtn": MessageLookupByLibrary.simpleMessage("जारी रखें"),
    "continueCancellationOnWebDesc": MessageLookupByLibrary.simpleMessage(
      "रद्दीकरण पूरा करने के लिए आपको Mysterium VPN वेबसाइट पर भेजा जाएगा।",
    ),
    "continueCancellationOnWebTitle": MessageLookupByLibrary.simpleMessage(
      "वेब पर रद्दीकरण जारी रखें",
    ),
    "continueToCancelBtn": MessageLookupByLibrary.simpleMessage("रद्द करना जारी रखें"),
    "continueToWebBtn": MessageLookupByLibrary.simpleMessage("वेबसाइट पर जाएँ"),
    "continueWithApple": MessageLookupByLibrary.simpleMessage("Apple के साथ जारी रखें"),
    "continueWithEmail": MessageLookupByLibrary.simpleMessage("ईमेल के साथ जारी रखें"),
    "continueWithGoogle": MessageLookupByLibrary.simpleMessage("Google के साथ जारी रखें"),
    "copyLink": MessageLookupByLibrary.simpleMessage(
      "लिंक कॉपी करें और उसे अपने ब्राउज़र में पेस्ट करें",
    ),
    "couponCodeCopied": m5,
    "dark": MessageLookupByLibrary.simpleMessage("डार्क"),
    "dataCentreComparisonCardItem1": MessageLookupByLibrary.simpleMessage(
      "आसानी से पता लगने योग्य",
    ),
    "dataCentreComparisonCardItem2": MessageLookupByLibrary.simpleMessage(
      "अक्सर वेबसाइटों द्वारा ब्लॉक",
    ),
    "dataCentreComparisonCardItem3": MessageLookupByLibrary.simpleMessage("कम निजी"),
    "dataCentreComparisonCardLbl": MessageLookupByLibrary.simpleMessage("डेटा सेंटर IPs"),
    "dataCentreComparisonCardTitle": MessageLookupByLibrary.simpleMessage("अधिकांश VPN"),
    "de": MessageLookupByLibrary.simpleMessage("जर्मन"),
    "deleteAccount": MessageLookupByLibrary.simpleMessage("खाता हटाएँ"),
    "deleteAccountQuestion": MessageLookupByLibrary.simpleMessage("खाता हटाएँ?"),
    "deleteBtn": MessageLookupByLibrary.simpleMessage("हटाएँ"),
    "deviceLimitReachedDesc": MessageLookupByLibrary.simpleMessage(
      "आप कनेक्टेड डिवाइस की अधिकतम संख्या तक पहुँच गए हैं। नया डिवाइस जोड़ने के लिए, अपने खाते से कोई मौजूदा डिवाइस हटाएँ।",
    ),
    "deviceLimitReachedOpenDashboard": MessageLookupByLibrary.simpleMessage("डैशबोर्ड खोलें"),
    "deviceLimitReachedTitle": MessageLookupByLibrary.simpleMessage("डिवाइस की सीमा पूरी हुई"),
    "disconnect": MessageLookupByLibrary.simpleMessage("डिस्कनेक्ट करें"),
    "disconnected": MessageLookupByLibrary.simpleMessage("डिस्कनेक्टेड"),
    "disconnecting": MessageLookupByLibrary.simpleMessage("डिस्कनेक्ट हो रहा है…"),
    "discountedPriceLabel": MessageLookupByLibrary.simpleMessage("केवल"),
    "dns": MessageLookupByLibrary.simpleMessage("DNS सुरक्षा"),
    "dnsDesc": MessageLookupByLibrary.simpleMessage("DNS लीक रोकता है"),
    "doneBtn": MessageLookupByLibrary.simpleMessage("हो गया"),
    "duration": MessageLookupByLibrary.simpleMessage("अवधि"),
    "email": MessageLookupByLibrary.simpleMessage("ईमेल पता"),
    "emailIsNotValid": MessageLookupByLibrary.simpleMessage("ईमेल पता मान्य नहीं है"),
    "emailIsRequired": MessageLookupByLibrary.simpleMessage("ईमेल पता आवश्यक है"),
    "emailNotificationsSetting": MessageLookupByLibrary.simpleMessage("ईमेल नोटिफिकेशन"),
    "emailSentTo": m6,
    "en": MessageLookupByLibrary.simpleMessage("अंग्रेज़ी"),
    "es": MessageLookupByLibrary.simpleMessage("स्पैनिश"),
    "existingSubscriptionDesc": m7,
    "existingSubscriptionTitle": MessageLookupByLibrary.simpleMessage(
      "आप लॉगआउट करके अपने ईमेल से प्रयास कर सकते हैं या इस चेतावनी को अनदेखा कर सकते हैं",
    ),
    "failedToConnectError": m8,
    "failedToSubmitFeedback": MessageLookupByLibrary.simpleMessage(
      "फ़ीडबैक सबमिट नहीं हो सका। कृपया फिर से प्रयास करें।",
    ),
    "failedToSubscribe": MessageLookupByLibrary.simpleMessage(
      "आपकी सदस्यता में कुछ गड़बड़ हो गई। कृपया फिर से प्रयास करें!",
    ),
    "failedToVerifySubs": MessageLookupByLibrary.simpleMessage(
      "हम आपकी पिछली सदस्यता खरीद की पुष्टि नहीं कर सके। दोबारा कोशिश करने के लिए नीचे बटन दबाएँ।",
    ),
    "fastLabel": MessageLookupByLibrary.simpleMessage("तेज़"),
    "featureToggleMinVersionNotSatisfied": MessageLookupByLibrary.simpleMessage(
      "आपके ऐप का वर्शन पुराना है। इसे इस्तेमाल जारी रखने के लिए कृपया ऐप अपडेट करें।",
    ),
    "formValidationError": MessageLookupByLibrary.simpleMessage(
      "अमान्य फ़ॉर्म डेटा। कृपया फ़ील्ड जाँचें और फिर से प्रयास करें।",
    ),
    "fr": MessageLookupByLibrary.simpleMessage("फ़्रेंच"),
    "france": MessageLookupByLibrary.simpleMessage("फ़्रांस"),
    "frequentDisconnectsReason": MessageLookupByLibrary.simpleMessage("बार-बार डिस्कनेक्ट"),
    "fullPriceLabel": MessageLookupByLibrary.simpleMessage("पूरी कीमत:"),
    "germany": MessageLookupByLibrary.simpleMessage("जर्मनी"),
    "getNewIPAddress": MessageLookupByLibrary.simpleMessage("रिफ्रेश पर नया IP पता पाएँ"),
    "getSubscriptionModalDesc": MessageLookupByLibrary.simpleMessage(
      "अपना कनेक्शन सुरक्षित करें और तुरंत निजी ब्राउज़िंग का आनंद लें",
    ),
    "getSubscriptionModalTitle": m9,
    "getSubscriptionPlanBtn": m10,
    "gettingIPAddress": MessageLookupByLibrary.simpleMessage("IP पता प्राप्त हो रहा है…"),
    "goBackButton": MessageLookupByLibrary.simpleMessage("वापस जाएँ"),
    "goToLoginBtn": MessageLookupByLibrary.simpleMessage("लॉग इन पर जाएँ"),
    "helpSupportLbl": MessageLookupByLibrary.simpleMessage("मदद और सहायता"),
    "hi": MessageLookupByLibrary.simpleMessage("हिन्दी"),
    "hiddenLbl": MessageLookupByLibrary.simpleMessage("छिपा हुआ"),
    "highLatencyReason": MessageLookupByLibrary.simpleMessage("उच्च लेटेंसी"),
    "highSpeed": MessageLookupByLibrary.simpleMessage("डेटासेंटर"),
    "homeLbl": MessageLookupByLibrary.simpleMessage("होम"),
    "id": MessageLookupByLibrary.simpleMessage("इंडोनेशियाई"),
    "incorrectLocationReason": MessageLookupByLibrary.simpleMessage("गलत लोकेशन"),
    "incorrectMagicLink": MessageLookupByLibrary.simpleMessage(
      "गलत मैजिक लिंक। कृपया फिर से प्रयास करें।",
    ),
    "ipAddressLbl": MessageLookupByLibrary.simpleMessage("IP पता"),
    "ipDetails": MessageLookupByLibrary.simpleMessage("IP विवरण"),
    "ipPool": MessageLookupByLibrary.simpleMessage("IP पूल"),
    "ipPoolLabel": m11,
    "ipRefreshExhaustedCity": m12,
    "ipRefreshExhaustedCountry": m13,
    "ipType": MessageLookupByLibrary.simpleMessage("IP प्रकार"),
    "ipTypeDataCenter": MessageLookupByLibrary.simpleMessage("डेटासेंटर IPs"),
    "ipTypeDataCenterDisclaimer": MessageLookupByLibrary.simpleMessage(
      "गति और प्रदर्शन के लिए अनुकूलित डेटासेंटर IPs।",
    ),
    "ipTypeResidential": MessageLookupByLibrary.simpleMessage("आवासीय IPs"),
    "ipTypeResidentialDisclaimer": MessageLookupByLibrary.simpleMessage(
      "असली घरों द्वारा प्रदान किए गए। लगभग पता न लगने योग्य लेकिन कम स्थिर।",
    ),
    "ipTypeResidentialTooltipBody": MessageLookupByLibrary.simpleMessage(
      "आवासीय IPs असली घरेलू डिवाइस से प्रदान किए जाते हैं, इसलिए समय के साथ उपलब्धता बदल सकती है।\n\nयदि कोई नोड ऑफ़लाइन हो जाता है, तो ऐप आपको नज़दीकी उपलब्ध आवासीय IP से फिर से कनेक्ट कर देता है।",
    ),
    "ipTypeResidentialTooltipTitle": MessageLookupByLibrary.simpleMessage(
      "मेरा IP क्यों बदल सकता है?",
    ),
    "it": MessageLookupByLibrary.simpleMessage("इतालवी"),
    "italy": MessageLookupByLibrary.simpleMessage("इटली"),
    "ja": MessageLookupByLibrary.simpleMessage("जापानी"),
    "keepSubscriptionBtn": MessageLookupByLibrary.simpleMessage("सदस्यता रखें"),
    "killSwitch": MessageLookupByLibrary.simpleMessage("Kill switch"),
    "killSwitchDesc": MessageLookupByLibrary.simpleMessage(
      "VPN कनेक्शन टूटने पर इंटरनेट ट्रैफ़िक ब्लॉक करता है",
    ),
    "languageSettingLbl": MessageLookupByLibrary.simpleMessage("भाषा"),
    "light": MessageLookupByLibrary.simpleMessage("लाइट"),
    "linkCopied": MessageLookupByLibrary.simpleMessage("लिंक क्लिपबोर्ड पर कॉपी हुआ!"),
    "linkExpires": MessageLookupByLibrary.simpleMessage(
      "लिंक 30 मिनट में समाप्त हो जाता है और केवल एक बार इस्तेमाल किया जा सकता है।",
    ),
    "location": MessageLookupByLibrary.simpleMessage("लोकेशन"),
    "locationItemCityCount": m14,
    "locationItemNodeCount": m15,
    "locationItemStatesCount": m16,
    "locationLbl": MessageLookupByLibrary.simpleMessage("लोकेशन"),
    "locationUnavailableAction": MessageLookupByLibrary.simpleMessage("नज़दीकी IP से कनेक्ट करें"),
    "locationUnavailableSubtitle": MessageLookupByLibrary.simpleMessage(
      "नज़दीकी IP से कनेक्ट करें - या इसे मैन्युअल रूप से चुनें",
    ),
    "locationUnavailableTitle": m17,
    "locationsUpdateFailed": m18,
    "locationsUpdated": m19,
    "loginSessionExpired": MessageLookupByLibrary.simpleMessage(
      "आपका सत्र समाप्त हो गया है। कृपया फिर से लॉग इन करें।",
    ),
    "loginSignupLabel": MessageLookupByLibrary.simpleMessage("लॉग इन या साइन अप करें"),
    "logout": MessageLookupByLibrary.simpleMessage("लॉग आउट"),
    "logoutConfirmationDesc": MessageLookupByLibrary.simpleMessage(
      "आप लॉग आउट करने वाले हैं। क्या आप निश्चित हैं?",
    ),
    "logoutConfirmationTitle": MessageLookupByLibrary.simpleMessage("लॉग आउट"),
    "logoutVPNConnectedDesc": MessageLookupByLibrary.simpleMessage(
      "VPN चालू है। अगर आप लॉग आउट जारी रखते हैं तो VPN सर्वर से आपका कनेक्शन कट जाएगा।",
    ),
    "lowLatencyReason": MessageLookupByLibrary.simpleMessage("कम लेटेंसी"),
    "madridLbl": MessageLookupByLibrary.simpleMessage("मैड्रिड, स्पेन 🇪🇸"),
    "malwareLbl": MessageLookupByLibrary.simpleMessage("मैलवेयर"),
    "manageOnWebBtn": MessageLookupByLibrary.simpleMessage("वेब पर प्रबंधित करें"),
    "marketingConsentPopupDesc": MessageLookupByLibrary.simpleMessage(
      "क्या आप Mysterium Network से ईमेल अपडेट, गोपनीयता टिप्स और खास ऑफ़र पाना चाहेंगे?",
    ),
    "marketingConsentPopupTitle": MessageLookupByLibrary.simpleMessage("ईमेल से अपडेट रहें"),
    "month": MessageLookupByLibrary.simpleMessage("माह"),
    "monthly": MessageLookupByLibrary.simpleMessage("मासिक"),
    "myIp": MessageLookupByLibrary.simpleMessage("मेरा IP"),
    "navLocations": MessageLookupByLibrary.simpleMessage("लोकेशन"),
    "navMap": MessageLookupByLibrary.simpleMessage("मैप"),
    "navProducts": MessageLookupByLibrary.simpleMessage("उत्पाद"),
    "nextBilling": m20,
    "nextBillingDateLbl": MessageLookupByLibrary.simpleMessage("अगली बिलिंग तिथि:"),
    "no": MessageLookupByLibrary.simpleMessage("नहीं"),
    "noActiveSubsDesc": MessageLookupByLibrary.simpleMessage("आपके पास कोई सक्रिय सदस्यता नहीं है"),
    "noEmailApp": MessageLookupByLibrary.simpleMessage("आपके डिवाइस पर कोई ईमेल ऐप नहीं है।"),
    "noLocationsFound": MessageLookupByLibrary.simpleMessage("कोई लोकेशन नहीं मिली"),
    "noServersAvailable": MessageLookupByLibrary.simpleMessage("कोई सर्वर उपलब्ध नहीं है"),
    "noServersAvailableSub": MessageLookupByLibrary.simpleMessage(
      "कनेक्टिविटी समस्या है और कोई सर्वर उपलब्ध नहीं है। कृपया बाद में प्रयास करें।",
    ),
    "noSubscriptionAction": MessageLookupByLibrary.simpleMessage("प्लान लें"),
    "noSubscriptionTitle": MessageLookupByLibrary.simpleMessage("कोई सक्रिय प्लान उपलब्ध नहीं"),
    "noneLbl": MessageLookupByLibrary.simpleMessage("कोई नहीं"),
    "notAvailableMsg": MessageLookupByLibrary.simpleMessage("उपलब्ध नहीं"),
    "notNowBtn": MessageLookupByLibrary.simpleMessage("अभी नहीं"),
    "notReadyToCancelTitle": MessageLookupByLibrary.simpleMessage(
      "अभी रद्द करने के लिए तैयार नहीं?",
    ),
    "nsfwLbl": MessageLookupByLibrary.simpleMessage("NSFW और मैलवेयर"),
    "onboardingStep1Desc": MessageLookupByLibrary.simpleMessage(
      "आपका IP और लोकेशन वेबसाइटों, ट्रैकर्स और सार्वजनिक Wi-Fi नेटवर्क को दिखाई देते हैं।",
    ),
    "onboardingStep1Title": MessageLookupByLibrary.simpleMessage("आपका कनेक्शन उजागर है"),
    "onboardingStep2Desc": MessageLookupByLibrary.simpleMessage(
      "Mysterium VPN आपके IP, ISP और लोकेशन को छिपाता है ताकि आप वास्तविक गोपनीयता के साथ ब्राउज़ कर सकें।",
    ),
    "onboardingStep2Title": MessageLookupByLibrary.simpleMessage(
      "एक टैप में अपनी असली पहचान छिपाएँ",
    ),
    "onboardingStep3Desc": MessageLookupByLibrary.simpleMessage(
      "आवासीय IPs के साथ, आपका कनेक्शन स्वाभाविक दिखता है - सामान्य VPN ट्रैफ़िक जैसा नहीं।",
    ),
    "onboardingStep3Title": MessageLookupByLibrary.simpleMessage("सभी VPN एक जैसे काम नहीं करते"),
    "openEmailApp": MessageLookupByLibrary.simpleMessage("ईमेल ऐप खोलें"),
    "openSystemSettingsBtn": MessageLookupByLibrary.simpleMessage("सिस्टम सेटिंग्स खोलें"),
    "optional": MessageLookupByLibrary.simpleMessage("वैकल्पिक"),
    "or": MessageLookupByLibrary.simpleMessage("या"),
    "orSelectCountryManually": MessageLookupByLibrary.simpleMessage(
      "हम आपको बेहतरीन सर्वर से कनेक्ट करेंगे - या आप मैन्युअल रूप से कोई देश चुन सकते हैं।",
    ),
    "otherReason": MessageLookupByLibrary.simpleMessage("अन्य…"),
    "pauseDurationRequiredError": MessageLookupByLibrary.simpleMessage(
      "कृपया एक रोकने की अवधि चुनें।",
    ),
    "pauseForMonths": m21,
    "pauseSubscriptionBtn": MessageLookupByLibrary.simpleMessage("सदस्यता रोकें"),
    "pauseSubscriptionInfoDesc": MessageLookupByLibrary.simpleMessage(
      "आप प्रति बिलिंग चक्र में एक बार अपना प्लान रोक सकते हैं।",
    ),
    "paused": MessageLookupByLibrary.simpleMessage("रोका गया"),
    "pausedUntil": m22,
    "pendingTransactionMessage": MessageLookupByLibrary.simpleMessage(
      "आपका पहले से एक भुगतान लेनदेन चल रहा है। कृपया नया शुरू करने से पहले उसे पूरा करें।",
    ),
    "perMonth": MessageLookupByLibrary.simpleMessage("माह"),
    "pl": MessageLookupByLibrary.simpleMessage("पोलिश"),
    "planAlreadyPurchasedMsg": MessageLookupByLibrary.simpleMessage(
      "सब तैयार है! आपके पास पहले से यह प्लान सक्रिय है।",
    ),
    "plan_2_years": MessageLookupByLibrary.simpleMessage("2 वर्ष प्लान"),
    "plan_2_years_basic": MessageLookupByLibrary.simpleMessage("Basic 2-वर्ष"),
    "plan_2_years_pro": MessageLookupByLibrary.simpleMessage("Pro 2-वर्ष"),
    "plan_6_months": MessageLookupByLibrary.simpleMessage("6-माह प्लान"),
    "plan_monthly": MessageLookupByLibrary.simpleMessage("मासिक प्लान"),
    "plan_monthly_basic": MessageLookupByLibrary.simpleMessage("Basic मासिक"),
    "plan_monthly_plus": MessageLookupByLibrary.simpleMessage("Plus मासिक"),
    "plan_monthly_pro": MessageLookupByLibrary.simpleMessage("Pro मासिक"),
    "plan_yearly": MessageLookupByLibrary.simpleMessage("वार्षिक प्लान"),
    "plan_yearly_basic": MessageLookupByLibrary.simpleMessage("Basic वार्षिक"),
    "plan_yearly_plus": MessageLookupByLibrary.simpleMessage("Plus वार्षिक"),
    "plan_yearly_pro": MessageLookupByLibrary.simpleMessage("Pro वार्षिक"),
    "poland": MessageLookupByLibrary.simpleMessage("पोलैंड"),
    "preferences": MessageLookupByLibrary.simpleMessage("प्राथमिकताएँ"),
    "pricingPlanSeePlansBtn": MessageLookupByLibrary.simpleMessage("सभी प्लान देखें"),
    "privacyPolicy": MessageLookupByLibrary.simpleMessage("गोपनीयता नीति"),
    "processingPayment": MessageLookupByLibrary.simpleMessage(
      "हम आपका भुगतान प्रोसेस कर रहे हैं। सब कुछ जल्द ही तैयार हो जाएगा…",
    ),
    "productsActivePlanWebSyncAlert": MessageLookupByLibrary.simpleMessage(
      "आपके पास पहले से एक सक्रिय प्लान है। वेब पर अपग्रेड करें - बदलाव स्वतः सिंक होते हैं",
    ),
    "productsAllPlansLbl": MessageLookupByLibrary.simpleMessage("सभी प्लान:"),
    "productsBasicDescription": MessageLookupByLibrary.simpleMessage(
      "रोज़मर्रा की गोपनीयता के लिए ज़रूरी बातें",
    ),
    "productsDuration1Month": MessageLookupByLibrary.simpleMessage("1 माह"),
    "productsDuration1Year": MessageLookupByLibrary.simpleMessage("1-वर्ष"),
    "productsDuration2Year": MessageLookupByLibrary.simpleMessage("2-वर्ष"),
    "productsExploreSubtitle": MessageLookupByLibrary.simpleMessage("प्लान और फ़ीचर देखें"),
    "productsManageSubtitle": MessageLookupByLibrary.simpleMessage(
      "वेब पर प्रबंधित और अपग्रेड करें",
    ),
    "productsMaxPlanAlert": MessageLookupByLibrary.simpleMessage(
      "आप पहले से उपलब्ध सबसे ऊँचे प्लान पर हैं।",
    ),
    "productsNotAvailable": MessageLookupByLibrary.simpleMessage(
      "इस समय कोई उत्पाद उपलब्ध नहीं है। कृपया बाद में फिर से प्रयास करें।",
    ),
    "productsPlusDescription": MessageLookupByLibrary.simpleMessage("अधिक डिवाइस, अधिक लोकेशन"),
    "productsProDescription": MessageLookupByLibrary.simpleMessage(
      "ज़्यादा इस्तेमाल करने वालों के लिए अधिकतम सुरक्षा",
    ),
    "productsSubscribeWebAlert": MessageLookupByLibrary.simpleMessage(
      "सदस्यताएँ वेब पर प्रबंधित की जाती हैं। आपका प्लान ऐप में स्वतः सिंक हो जाएगा।",
    ),
    "productsSubscribeWebSubtitle": MessageLookupByLibrary.simpleMessage("वेब पर सदस्यता लें"),
    "productsTitle": MessageLookupByLibrary.simpleMessage("VPN उत्पाद"),
    "protectedLbl": MessageLookupByLibrary.simpleMessage("सुरक्षित"),
    "protocol": MessageLookupByLibrary.simpleMessage("प्रोटोकॉल"),
    "protocolLabel": m23,
    "protocolPickerSettingDesc": MessageLookupByLibrary.simpleMessage(
      "VPN प्रोटोकॉल बदलने से आप डिस्कनेक्ट हो जाएँगे। इसके बाद आपको फिर से कनेक्ट करना होगा।",
    ),
    "protocolPickerSettingTitle": MessageLookupByLibrary.simpleMessage("VPN प्रोटोकॉल बदलना"),
    "pt": MessageLookupByLibrary.simpleMessage("पुर्तगाली"),
    "ptBR": MessageLookupByLibrary.simpleMessage("ब्राज़ीलियाई पुर्तगाली"),
    "pushNotificationsConsentPopupDesc": MessageLookupByLibrary.simpleMessage(
      "नए फ़ीचर, उपयोगी टिप्स और खास ऑफ़र की सूचना पाएँ - बस काम के अपडेट।",
    ),
    "pushNotificationsConsentPopupTitle": MessageLookupByLibrary.simpleMessage(
      "पुश नोटिफिकेशन के साथ अपडेट रहें",
    ),
    "pushNotificationsSetting": MessageLookupByLibrary.simpleMessage("पुश नोटिफिकेशन"),
    "pushNotificationsSettingDesc": MessageLookupByLibrary.simpleMessage(
      "उत्पाद अपडेट, टिप्स और खास ऑफ़र",
    ),
    "qaToolboxLbl": MessageLookupByLibrary.simpleMessage("QA Toolbox"),
    "rateConnection": MessageLookupByLibrary.simpleMessage("आपका कनेक्शन कैसा है?"),
    "rateConnectionDislike": MessageLookupByLibrary.simpleMessage("आपको क्या पसंद नहीं आया?"),
    "rateConnectionLike": MessageLookupByLibrary.simpleMessage("आपको क्या पसंद आया?"),
    "reactivateSubscriptionAnytimeDesc": MessageLookupByLibrary.simpleMessage(
      "पहुँच समाप्त होने से पहले आप कभी भी अपनी सदस्यता फिर से सक्रिय कर सकते हैं।",
    ),
    "recentLocations": MessageLookupByLibrary.simpleMessage("हाल की लोकेशन"),
    "redeemDiscountCode": MessageLookupByLibrary.simpleMessage("डिस्काउंट कोड रिडीम करें"),
    "redirectToLoginPage": MessageLookupByLibrary.simpleMessage(
      "आपका खाता सफलतापूर्वक हटा दिया गया है। आपको लॉग इन स्क्रीन पर भेजा जाएगा।",
    ),
    "refresh": MessageLookupByLibrary.simpleMessage("रिफ्रेश करें"),
    "refreshIP": MessageLookupByLibrary.simpleMessage("IP रिफ्रेश करें"),
    "refreshIPAddress": MessageLookupByLibrary.simpleMessage("IP पता रिफ्रेश करें"),
    "refreshLocationsTooltip": m24,
    "renewsOn": m25,
    "resetAppDesc": MessageLookupByLibrary.simpleMessage("जब कुछ काम न कर रहा हो तो रीसेट करें"),
    "resetAppDialogContent": MessageLookupByLibrary.simpleMessage(
      "अगर आप ऐप रीसेट करना जारी रखते हैं, तो आप Mysterium VPN से डिस्कनेक्ट हो जाएँगे।",
    ),
    "resetAppDialogTitle": MessageLookupByLibrary.simpleMessage("VPN कनेक्शन इस समय सक्रिय है"),
    "resetAppFailed": MessageLookupByLibrary.simpleMessage(
      "ऐप रीसेट नहीं हो सका। कृपया फिर से प्रयास करें।",
    ),
    "resetAppSuccess": MessageLookupByLibrary.simpleMessage("ऐप सफलतापूर्वक रीसेट हो गया।"),
    "resetAppTitle": MessageLookupByLibrary.simpleMessage("ऐप रीसेट करें"),
    "resetBtn": MessageLookupByLibrary.simpleMessage("रीसेट करें"),
    "residential": MessageLookupByLibrary.simpleMessage("आवासीय"),
    "residentialCentreComparisonCardItem1": MessageLookupByLibrary.simpleMessage(
      "असली उपयोगकर्ता जैसा दिखता है",
    ),
    "residentialCentreComparisonCardItem2": MessageLookupByLibrary.simpleMessage("पता लगाना कठिन"),
    "residentialCentreComparisonCardItem3": MessageLookupByLibrary.simpleMessage("कम ब्लॉक"),
    "residentialCentreComparisonCardLbl": MessageLookupByLibrary.simpleMessage("आवासीय IPs"),
    "residentialEducationBlock1Body": MessageLookupByLibrary.simpleMessage(
      "आवासीय IPs असली घरेलू डिवाइस से आते हैं, जिससे आपका ट्रैफ़िक सामान्य इंटरनेट उपयोग जैसा दिखता है।",
    ),
    "residentialEducationBlock1Title": MessageLookupByLibrary.simpleMessage("असली घरेलू डिवाइस"),
    "residentialEducationBlock2Body": MessageLookupByLibrary.simpleMessage(
      "चूँकि ये IPs असली डिवाइसों से आती हैं, कुछ नोड्स समय-समय पर ऑफ़लाइन हो सकते हैं।",
    ),
    "residentialEducationBlock2Title": MessageLookupByLibrary.simpleMessage("उपलब्धता बदल सकती है"),
    "residentialEducationBlock3Body": MessageLookupByLibrary.simpleMessage(
      "यदि आपका मौजूदा IP अनुपलब्ध हो जाता है, तो ऐप आपको नज़दीकी उपलब्ध आवासीय IP से फिर से कनेक्ट कर देता है।",
    ),
    "residentialEducationBlock3Title": MessageLookupByLibrary.simpleMessage("स्वतः फिर से कनेक्शन"),
    "residentialEducationGotIt": MessageLookupByLibrary.simpleMessage("ठीक है"),
    "residentialEducationSubtitle": MessageLookupByLibrary.simpleMessage(
      "आवासीय IPs डेटासेंटर IPs से अलग होते हैं। यहाँ जानें कि क्या उम्मीद करें।",
    ),
    "residentialEducationTitle": MessageLookupByLibrary.simpleMessage(
      "आवासीय IPs कैसे काम करते हैं",
    ),
    "resumeBtn": MessageLookupByLibrary.simpleMessage("फिर शुरू करें"),
    "resumeSubscriptionPromptDesc": MessageLookupByLibrary.simpleMessage(
      "आपकी सदस्यता तुरंत फिर शुरू हो जाएगी।",
    ),
    "resumeSubscriptionTitle": MessageLookupByLibrary.simpleMessage("सदस्यता फिर शुरू करें?"),
    "retryBtn": MessageLookupByLibrary.simpleMessage("फिर से प्रयास करें"),
    "reviewLeaveReviewBtn": MessageLookupByLibrary.simpleMessage("समीक्षा दें"),
    "reviewPositiveTitle": MessageLookupByLibrary.simpleMessage(
      "बहुत बढ़िया! क्या आप हमें एक समीक्षा देना चाहेंगे?",
    ),
    "reviewSatisfactionTitle": MessageLookupByLibrary.simpleMessage(
      "क्या आप इस ऐप को दूसरों को सुझाएँगे?",
    ),
    "searchForLocations": MessageLookupByLibrary.simpleMessage("लोकेशन खोजें"),
    "seePlansBtn": MessageLookupByLibrary.simpleMessage("प्लान देखें"),
    "selectEmailApp": MessageLookupByLibrary.simpleMessage("जारी रखने के लिए ईमेल ऐप चुनें"),
    "semiAnnual": MessageLookupByLibrary.simpleMessage("अर्ध-वार्षिक"),
    "sendAgain": m26,
    "serviceUnavailableError": MessageLookupByLibrary.simpleMessage(
      "हमें अस्थायी नेटवर्क समस्याएँ आ रही हैं। कृपया बाद में फिर से प्रयास करें।",
    ),
    "settingManageBtn": MessageLookupByLibrary.simpleMessage("प्रबंधित करें"),
    "settings": MessageLookupByLibrary.simpleMessage("सेटिंग्स"),
    "setupTunnerPermissionsDialogDesc": MessageLookupByLibrary.simpleMessage(
      "Mysterium VPN का इस्तेमाल करने के लिए, हमें VPN प्रोफ़ाइल इंस्टॉल करने की आपकी अनुमति चाहिए।",
    ),
    "setupTunnerPermissionsDialogDisclaimer": MessageLookupByLibrary.simpleMessage(
      "आपकी गुमनामी सुरक्षित है। हम आपकी ब्राउज़िंग गतिविधि को न देखते हैं, न एकत्र करते हैं और न ही संग्रहीत करते हैं।",
    ),
    "setupTunnerPermissionsDialogTitle": MessageLookupByLibrary.simpleMessage(
      "हमें आपकी अनुमति चाहिए",
    ),
    "signIn": MessageLookupByLibrary.simpleMessage("Mysterium VPN में साइन इन करें"),
    "signInAbortedMsg": MessageLookupByLibrary.simpleMessage("साइन इन रद्द किया गया"),
    "signInBtn": MessageLookupByLibrary.simpleMessage("साइन इन करें"),
    "signInDisclaimer": MessageLookupByLibrary.simpleMessage(
      "Mysterium VPN आपकी ऑनलाइन गतिविधियों को लॉग नहीं करता, और कोई रिकॉर्ड आपसे, आपके डिवाइस, आपके IP पते या आपके ईमेल से नहीं जुड़ता। साइन इन करके, आप इनसे सहमत होते हैं",
    ),
    "sixMonths": MessageLookupByLibrary.simpleMessage("6-माह"),
    "skipBtn": MessageLookupByLibrary.simpleMessage("छोड़ें"),
    "somethingWentWrong": MessageLookupByLibrary.simpleMessage(
      "कुछ गड़बड़ हो गई। कृपया फिर से प्रयास करें!",
    ),
    "stableConnectionReason": MessageLookupByLibrary.simpleMessage("स्थिर कनेक्शन"),
    "status": MessageLookupByLibrary.simpleMessage("स्थिति"),
    "stayButton": MessageLookupByLibrary.simpleMessage("बने रहें"),
    "stayOnAppBtn": MessageLookupByLibrary.simpleMessage("ऐप में रहें"),
    "submitBtn": MessageLookupByLibrary.simpleMessage("सबमिट करें"),
    "subscribeOnWebBtn": MessageLookupByLibrary.simpleMessage("वेब पर सदस्यता लें"),
    "subscriptionActive": MessageLookupByLibrary.simpleMessage(
      "बढ़िया खबर! अब आपकी सदस्यता सक्रिय है।",
    ),
    "subscriptionAllPlansBackToPlans": MessageLookupByLibrary.simpleMessage("प्लान पर वापस"),
    "subscriptionAllPlansCompareAll": MessageLookupByLibrary.simpleMessage(
      "सभी फ़ीचर की तुलना करें",
    ),
    "subscriptionAllPlansCurrentPlan": MessageLookupByLibrary.simpleMessage("मौजूदा प्लान"),
    "subscriptionAllPlansPurchase": MessageLookupByLibrary.simpleMessage("प्लान लें"),
    "subscriptionAllPlansTabMonth": MessageLookupByLibrary.simpleMessage("मासिक"),
    "subscriptionAllPlansTabYear": MessageLookupByLibrary.simpleMessage("1-वर्ष"),
    "subscriptionAllPlansTitle": MessageLookupByLibrary.simpleMessage("सभी प्लान"),
    "subscriptionAllPlansUpgrade": MessageLookupByLibrary.simpleMessage("अपना प्लान अपग्रेड करें"),
    "subscriptionCancelledTitle": MessageLookupByLibrary.simpleMessage("सदस्यता रद्द हो गई"),
    "subscriptionOnboardingBoostProtectionDescription": MessageLookupByLibrary.simpleMessage(
      "VPN प्रोटोकॉल और मैलवेयर ब्लॉकिंग जैसे उन्नत फ़ीचर देखें।",
    ),
    "subscriptionOnboardingBoostProtectionTitle": MessageLookupByLibrary.simpleMessage(
      "अपनी सुरक्षा बढ़ाएँ",
    ),
    "subscriptionOnboardingCancelTourLabel": MessageLookupByLibrary.simpleMessage(
      "अभी के लिए छोड़ें",
    ),
    "subscriptionOnboardingConnectDescription": MessageLookupByLibrary.simpleMessage(
      "हम आपको बेहतरीन सर्वर से कनेक्ट करेंगे।",
    ),
    "subscriptionOnboardingConnectTitle": MessageLookupByLibrary.simpleMessage(
      "निजी रहने के लिए कनेक्ट करें",
    ),
    "subscriptionOnboardingManagePlanDescription": MessageLookupByLibrary.simpleMessage(
      "अपने खाते की पहुँच के आधार पर प्लान खरीदें, अपग्रेड करें या उपलब्ध प्लान देखें।",
    ),
    "subscriptionOnboardingManagePlanTitle": MessageLookupByLibrary.simpleMessage(
      "अपना प्लान प्रबंधित करें",
    ),
    "subscriptionOnboardingMapDesktopDescription": MessageLookupByLibrary.simpleMessage(
      "मैप ब्राउज़ करें या साइडबार से लोकेशन खोजें।",
    ),
    "subscriptionOnboardingMapDesktopTitle": MessageLookupByLibrary.simpleMessage(
      "अपने तरीके से लोकेशन खोजें",
    ),
    "subscriptionOnboardingMapMobileDescription": MessageLookupByLibrary.simpleMessage(
      "देश चुनने और तुरंत कनेक्ट करने के लिए मैप ब्राउज़ करें।",
    ),
    "subscriptionOnboardingMapMobileTitle": MessageLookupByLibrary.simpleMessage(
      "मैप से कनेक्ट करें",
    ),
    "subscriptionOnboardingPromptDescription": MessageLookupByLibrary.simpleMessage(
      "अपडेटेड ऐप में अपना रास्ता जानें और देखें कि अब मुख्य फ़ीचर कहाँ हैं।",
    ),
    "subscriptionOnboardingPromptTitle": MessageLookupByLibrary.simpleMessage("एक छोटा टूर लें"),
    "subscriptionOnboardingSearchDescription": MessageLookupByLibrary.simpleMessage(
      "सर्च से देश, शहर और सर्वर जल्दी खोजें।",
    ),
    "subscriptionOnboardingSearchTitle": MessageLookupByLibrary.simpleMessage(
      "तेज़ी से खोजें और कनेक्ट करें",
    ),
    "subscriptionOnboardingSetupCompleteDescription": MessageLookupByLibrary.simpleMessage(
      "अधिक निजी तरीके से ब्राउज़िंग शुरू करने के लिए एक लोकेशन चुनें।",
    ),
    "subscriptionOnboardingSetupCompleteTitle": MessageLookupByLibrary.simpleMessage(
      "सेटअप पूरा हुआ",
    ),
    "subscriptionOnboardingStartTourLabel": MessageLookupByLibrary.simpleMessage("टूर शुरू करें"),
    "subscriptionOnboardingVPNLocationsDesktopDescription": MessageLookupByLibrary.simpleMessage(
      "देशों और शहरों को एक ही जगह पर देखें।",
    ),
    "subscriptionOnboardingVPNLocationsMobileDescription": MessageLookupByLibrary.simpleMessage(
      "देश, शहर, हाल के कनेक्शन और विशेष सर्वर एक ही जगह पर देखें।",
    ),
    "subscriptionOnboardingVPNLocationsTitle": MessageLookupByLibrary.simpleMessage(
      "VPN लोकेशन ब्राउज़ करें",
    ),
    "subscriptionPlanBestValue": MessageLookupByLibrary.simpleMessage("सबसे बढ़िया"),
    "subscriptionPlanCityLevel": MessageLookupByLibrary.simpleMessage("शहर-स्तर के विकल्प"),
    "subscriptionPlanCityLevelDesc": MessageLookupByLibrary.simpleMessage(
      "अधिकांश VPN की तुलना में अधिक सटीक लोकेशन नियंत्रण देता है, जो आमतौर पर आपको केवल पूरे देश या राज्य चुनने तक सीमित रखते हैं।",
    ),
    "subscriptionPlanDevicesSecured": MessageLookupByLibrary.simpleMessage(
      "एक साथ सुरक्षित डिवाइस",
    ),
    "subscriptionPlanDoubleVPN": MessageLookupByLibrary.simpleMessage("डबल VPN"),
    "subscriptionPlanDoubleVPNDesc": MessageLookupByLibrary.simpleMessage(
      "सुरक्षा की एक अतिरिक्त परत। आपके इंटरनेट ट्रैफ़िक को दो अलग-अलग VPN सर्वरों के ज़रिए भेजता है, आपके डेटा को दोबारा एन्क्रिप्ट करता है और आपके IP पते को दूसरे सर्वर के पीछे छिपा देता है",
    ),
    "subscriptionPlanMalwareBlocker": MessageLookupByLibrary.simpleMessage("मैलवेयर ब्लॉकर"),
    "subscriptionPlanMalwareBlockerDesc": MessageLookupByLibrary.simpleMessage(
      "आपके डिवाइस तक पहुँचने से पहले ही खतरों को रोककर उसकी रक्षा करता है, आपको बाधित किए बिना चुपचाप बैकग्राउंड में चलता है।",
    ),
    "subscriptionPlanMoneyBack": MessageLookupByLibrary.simpleMessage("7-दिन मनी-बैक गारंटी"),
    "subscriptionPlanNameBasic": MessageLookupByLibrary.simpleMessage("Basic"),
    "subscriptionPlanNamePlus": MessageLookupByLibrary.simpleMessage("Plus"),
    "subscriptionPlanNamePro": MessageLookupByLibrary.simpleMessage("Pro"),
    "subscriptionPlanPF1Basic": MessageLookupByLibrary.simpleMessage(
      "एक साथ 6 डिवाइस सुरक्षित करें",
    ),
    "subscriptionPlanPF1Plus": MessageLookupByLibrary.simpleMessage(
      "एक साथ 10 डिवाइस सुरक्षित करें",
    ),
    "subscriptionPlanPF2Basic": MessageLookupByLibrary.simpleMessage("57 समर्थित देश"),
    "subscriptionPlanPF2Plus": MessageLookupByLibrary.simpleMessage("100+ समर्थित देश"),
    "subscriptionPlanPF3Basic": MessageLookupByLibrary.simpleMessage("10 सर्वर"),
    "subscriptionPlanPF3Plus": MessageLookupByLibrary.simpleMessage("100 सर्वर"),
    "subscriptionPlanPF4Basic": MessageLookupByLibrary.simpleMessage("VPN प्रोटोकॉल"),
    "subscriptionPlanPF4Plus": MessageLookupByLibrary.simpleMessage("7,500+ आवासीय IPs"),
    "subscriptionPlanPF5Plus": MessageLookupByLibrary.simpleMessage("VPN प्रोटोकॉल"),
    "subscriptionPlanPF6Plus": MessageLookupByLibrary.simpleMessage("शहर-स्तर के विकल्प"),
    "subscriptionPlanResidentialIPs": MessageLookupByLibrary.simpleMessage("आवासीय IPs"),
    "subscriptionPlanResidentialIPsDesc": MessageLookupByLibrary.simpleMessage(
      "एक सामान्य घरेलू उपयोगकर्ता की तरह दिखें, जिससे आप स्ट्रीमिंग सेवाओं तक पहुँच पाएँ और VPN डिटेक्शन से बच सकें।",
    ),
    "subscriptionPlanSavePercent": m27,
    "subscriptionPlanSaveWith": m28,
    "subscriptionPlanServers": MessageLookupByLibrary.simpleMessage("सर्वर"),
    "subscriptionPlanSupportedCountries": MessageLookupByLibrary.simpleMessage("समर्थित देश"),
    "subscriptionPlanWireGuard": MessageLookupByLibrary.simpleMessage("VPN प्रोटोकॉल"),
    "subscriptionPlanWireGuardDesc": MessageLookupByLibrary.simpleMessage(
      "WireGuard - तेज़ प्रोटोकॉल, गेमिंग और स्ट्रीमिंग के लिए बेहतरीन\nOpenVPN - अत्यधिक कॉन्फ़िगर करने योग्य प्रोटोकॉल जो वहाँ भी काम करता है जहाँ अन्य प्रोटोकॉल विफल हो जाते हैं (Android पर उपलब्ध नहीं)",
    ),
    "subscriptionProcessCanceled": MessageLookupByLibrary.simpleMessage(
      "आपने अपनी सदस्यता में बदलाव पूरे नहीं किए।",
    ),
    "subscriptionUpgrade": MessageLookupByLibrary.simpleMessage("अपग्रेड करें"),
    "subscriptionUpgradeCTA": m29,
    "subscriptionUpgradeModalDescription": MessageLookupByLibrary.simpleMessage(
      "7,500+ आवासीय IPs तक पहुँच के लिए",
    ),
    "subscriptionUpgradeModalTitle": m30,
    "subscriptionUpgradeSeeAllPlans": MessageLookupByLibrary.simpleMessage("सभी प्लान देखें"),
    "subscriptionVerificationFailed": MessageLookupByLibrary.simpleMessage("सत्यापन दोबारा करें"),
    "subscripton": MessageLookupByLibrary.simpleMessage("सदस्यता"),
    "switchToLocationBtn": m31,
    "system": MessageLookupByLibrary.simpleMessage("सिस्टम"),
    "takeBackTheInternetLbl": MessageLookupByLibrary.simpleMessage("इंटरनेट को वापस पाएँ।"),
    "termsAndConditions": MessageLookupByLibrary.simpleMessage("नियम और शर्तें"),
    "title": MessageLookupByLibrary.simpleMessage("नमस्ते"),
    "toManyRequestsErrorMsg": MessageLookupByLibrary.simpleMessage(
      "बहुत अधिक अनुरोध। कृपया बाद में फिर से प्रयास करें।",
    ),
    "tokenAlreadyUsed": MessageLookupByLibrary.simpleMessage(
      "टोकन पहले ही इस्तेमाल हो चुका है। कृपया फिर से प्रयास करें।\n",
    ),
    "tooManyConnectionsBannerCTADisconnect": MessageLookupByLibrary.simpleMessage(
      "डिस्कनेक्ट करें",
    ),
    "tooManyConnectionsBannerCTAReconnect": MessageLookupByLibrary.simpleMessage(
      "फिर से कनेक्ट करें",
    ),
    "tooManyConnectionsBannerDesc": MessageLookupByLibrary.simpleMessage(
      "आप अपने खाते पर 6 कनेक्टेड डिवाइस की अधिकतम सीमा तक पहुँच गए हैं। VPN का इस्तेमाल जारी रखने के लिए, फिर से कनेक्ट करने हेतु क्लिक करें।",
    ),
    "tooManyConnectionsBannerDescConnected": MessageLookupByLibrary.simpleMessage(
      "आप अपने खाते पर 6 कनेक्टेड डिवाइस की अधिकतम सीमा तक पहुँच गए हैं। VPN का इस्तेमाल जारी रखने के लिए, डिस्कनेक्ट करें और फिर से प्रयास करें।",
    ),
    "tooManyConnectionsBannerTitle": MessageLookupByLibrary.simpleMessage(
      "आप डिस्कनेक्ट हो गए हैं",
    ),
    "topLocations": MessageLookupByLibrary.simpleMessage("शीर्ष लोकेशन"),
    "tr": MessageLookupByLibrary.simpleMessage("तुर्की"),
    "tryAgainBtn": MessageLookupByLibrary.simpleMessage("फिर से प्रयास करें"),
    "tryAnotherLocation": MessageLookupByLibrary.simpleMessage(
      "कोई दूसरी लोकेशन खोजने का प्रयास करें",
    ),
    "tunnelPermissionRequired": MessageLookupByLibrary.simpleMessage(
      "VPN टनल शुरू करने के लिए आपको अनुमति देनी होगी।",
    ),
    "tunnelSetupError": MessageLookupByLibrary.simpleMessage("टनल सेटअप करते समय एक त्रुटि हुई"),
    "typeDelete": m32,
    "typeFeedback": MessageLookupByLibrary.simpleMessage("अपना फ़ीडबैक यहाँ लिखें…"),
    "ukraine": MessageLookupByLibrary.simpleMessage("यूक्रेन"),
    "unableToConnectToPaymentProcesor": MessageLookupByLibrary.simpleMessage(
      "पेमेंट प्रोसेसर से कनेक्ट नहीं हो सका! कृपया फिर से प्रयास करें।",
    ),
    "unauthenticatedBannerTitle": MessageLookupByLibrary.simpleMessage("आप साइन इन नहीं हैं"),
    "unauthenticatedSettingSubtitle": MessageLookupByLibrary.simpleMessage(
      "अपने खाते तक पहुँचने और सभी फ़ीचर अनलॉक करने के लिए साइन इन करें",
    ),
    "unauthenticatedSettingTitle": MessageLookupByLibrary.simpleMessage("आप साइन इन नहीं हैं"),
    "unprotectedLbl": MessageLookupByLibrary.simpleMessage("असुरक्षित"),
    "unstableSpeedReason": MessageLookupByLibrary.simpleMessage("अस्थिर गति"),
    "updateBtn": MessageLookupByLibrary.simpleMessage("अपडेट करें"),
    "userIntentBestSpeed": MessageLookupByLibrary.simpleMessage("बेहतरीन गति"),
    "userIntentBestSpeedDesc": MessageLookupByLibrary.simpleMessage(
      "बेहतरीन प्रदर्शन के लिए सबसे तेज़ उपलब्ध सर्वर से कनेक्ट करें",
    ),
    "userIntentLabel": MessageLookupByLibrary.simpleMessage("विशेष सर्वर"),
    "userIntentLowLatency": MessageLookupByLibrary.simpleMessage("कम लेटेंसी"),
    "userIntentLowLatencyDesc": MessageLookupByLibrary.simpleMessage(
      "स्थिर और भरोसेमंद पहुँच के लिए आपको स्वतः नज़दीकी सर्वर से कनेक्ट करता है",
    ),
    "userIntentMaxPrivacy": MessageLookupByLibrary.simpleMessage("अधिकतम गोपनीयता"),
    "userIntentMaxPrivacyDesc": MessageLookupByLibrary.simpleMessage(
      "देश के आधार पर बेहतरीन अभिव्यक्ति स्वतंत्रता और गति विकल्पों वाला सर्वर पाएँ",
    ),
    "userIntentNearestLocation": MessageLookupByLibrary.simpleMessage("नज़दीकी लोकेशन"),
    "userIntentNearestLocationDesc": MessageLookupByLibrary.simpleMessage(
      "आपकी मौजूदा लोकेशन के आधार पर बेहतरीन गति और प्रदर्शन के लिए आपको नज़दीकी उपलब्ध VPN IP से कनेक्ट करता है",
    ),
    "userIntentP2P": MessageLookupByLibrary.simpleMessage("P2P"),
    "userIntentP2PDesc": MessageLookupByLibrary.simpleMessage(
      "सुरक्षित क्रिप्टो लेनदेन, फ़ाइल शेयरिंग, गेम होस्टिंग और संचार के लिए बेहतरीन सर्वर चुनें",
    ),
    "userIntentStreaming": MessageLookupByLibrary.simpleMessage("Streaming"),
    "userIntentStreamingDesc": MessageLookupByLibrary.simpleMessage(
      "क्षेत्र-विशिष्ट प्लेटफ़ॉर्म से अपने पसंदीदा शो और फ़िल्में देखें",
    ),
    "viewAllFeaturesBtn": MessageLookupByLibrary.simpleMessage("सभी फ़ीचर देखें"),
    "viewLessBtn": MessageLookupByLibrary.simpleMessage("कम देखें"),
    "vodafoneLbl": MessageLookupByLibrary.simpleMessage("Vodafone Iberia"),
    "vpnDetails": MessageLookupByLibrary.simpleMessage("VPN विवरण"),
    "vpnIp": MessageLookupByLibrary.simpleMessage("VPN IP"),
    "vpnProtocolSettingLbl": MessageLookupByLibrary.simpleMessage("VPN प्रोटोकॉल"),
    "year": MessageLookupByLibrary.simpleMessage("वर्ष"),
    "yearly": MessageLookupByLibrary.simpleMessage("वार्षिक"),
    "yes": MessageLookupByLibrary.simpleMessage("हाँ"),
    "zh": MessageLookupByLibrary.simpleMessage("चीनी"),
  };
}
