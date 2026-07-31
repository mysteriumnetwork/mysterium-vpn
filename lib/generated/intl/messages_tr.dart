// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a tr locale. All the
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
  String get localeName => 'tr';

  static String m0(store) =>
      "${store} üzerinden ödenen aktif bir aboneliğin zaten var. ${store} üzerinden yönet.";

  static String m1(amount, period) => "${amount} /${period}";

  static String m2(amount, period) => "${amount}/ay — ${period} faturalanır";

  static String m3(location) => "${location} konumuna bağlan";

  static String m4(couponCode) => "${couponCode} panoya kopyalandı!";

  static String m5(email) => "${email} adresine bir e-posta gönderdik";

  static String m6(email) => "“${email}” ile ödeme yaptığın bir aboneliğin zaten olabilir";

  static String m7(errorCode) => "Bağlanılamadı. Lütfen tekrar dene [hata: ${errorCode}]";

  static String m8(plan) => "${plan} al";

  static String m9(plan) => "${plan} planını al";

  static String m10(count) => "IP havuzu: ${count}";

  static String m11(location) =>
      "${location} içinde alternatif IP yok. Bir dahaki sefere farklı bir IP almak için başka bir ülke veya şehir seç.";

  static String m12(location) =>
      "${location} içinde alternatif IP yok. Bir dahaki sefere farklı bir IP almak için başka bir ülke seç.";

  static String m13(count) =>
      "${Intl.plural(count, one: '${count} Şehir', other: '${count} Şehir')}";

  static String m14(count) => "${Intl.plural(count, one: '${count} IP', other: '${count} IP')}";

  static String m15(count) =>
      "${Intl.plural(count, one: '${count} Eyalet', other: '${count} Eyalet')}";

  static String m16(location) => "${location} kullanılamıyor";

  static String m17(location) => "${location} güncellenemedi";

  static String m18(location) => "${location} güncellendi";

  static String m19(date) => "Sonraki Faturalandırma: ${date}";

  static String m20(count) =>
      "${Intl.plural(count, zero: '', one: '${count} ay duraklat', other: '${count} ay duraklat')}";

  static String m21(protocol, label) => "${protocol} (${label})";

  static String m22(location) => "${location} yenile";

  static String m23(count) =>
      "${Intl.plural(count, one: 'Tekrar gönder', other: 'Tekrar gönder (${count})')}";

  static String m24(percent) => "%${percent} tasarruf";

  static String m25(percent, planId) => "${planId} planıyla %${percent} tasarruf";

  static String m26(plan) => "${plan} planına yükselt";

  static String m27(plan) => "${plan} planına yükselt";

  static String m28(location) => "${location} konumuna geç";

  static String m29(word) => "${word} yaz";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "LoggingYouIn": MessageLookupByLibrary.simpleMessage("Giriş yapılıyor..."),
    "acceptOfferBtn": MessageLookupByLibrary.simpleMessage("Teklifi kabul et"),
    "accessAvailableUntilLbl": MessageLookupByLibrary.simpleMessage("Erişim şu tarihe kadar:"),
    "accessBlockedSitesReason": MessageLookupByLibrary.simpleMessage(
      "Engellenen sitelere erişilemiyor",
    ),
    "account": MessageLookupByLibrary.simpleMessage("Hesap"),
    "accountSuccessfullyDeleted": MessageLookupByLibrary.simpleMessage("Hesap silindi"),
    "activeSubsPaidVia": m0,
    "allLocations": MessageLookupByLibrary.simpleMessage("Tüm konumlar"),
    "allowBtn": MessageLookupByLibrary.simpleMessage("İzin ver"),
    "allowNotificationsBtn": MessageLookupByLibrary.simpleMessage("Bildirimlere izin ver"),
    "allowPushNotificationsBtn": MessageLookupByLibrary.simpleMessage("Bildirimlere izin ver"),
    "and": MessageLookupByLibrary.simpleMessage(" ve "),
    "appUpdateAvailableDesc": MessageLookupByLibrary.simpleMessage(
      "Yeni uygulama sürümü hazır! En son özellikler ve iyileştirmeler için şimdi güncelle.",
    ),
    "appUpdateAvailableSetting": MessageLookupByLibrary.simpleMessage(
      "Uygulama Güncellemesi Mevcut!",
    ),
    "appUpdateAvailableTitle": MessageLookupByLibrary.simpleMessage("Uygulama Güncellemesi Mevcut"),
    "appearanceSettingLbl": MessageLookupByLibrary.simpleMessage("Görünüm"),
    "ar": MessageLookupByLibrary.simpleMessage("Arapça"),
    "austria": MessageLookupByLibrary.simpleMessage("Avusturya"),
    "authenticationFailed": MessageLookupByLibrary.simpleMessage(
      "Giriş yapılamadı. Lütfen tekrar dene.",
    ),
    "back": MessageLookupByLibrary.simpleMessage("Geri"),
    "backToSettingsLbl": MessageLookupByLibrary.simpleMessage("Ayarlara geri dön"),
    "batterySaverLabel": MessageLookupByLibrary.simpleMessage("Pil tasarrufu"),
    "berlinLbl": MessageLookupByLibrary.simpleMessage("Berlin, Almanya 🇩🇪"),
    "billedInTotal": m1,
    "billedPerMonth": m2,
    "blockerSettingLbl": MessageLookupByLibrary.simpleMessage("Engelleyici"),
    "buttonUpdateApp": MessageLookupByLibrary.simpleMessage("Şimdi güncelle"),
    "bypassRestrictionsReason": MessageLookupByLibrary.simpleMessage("Kısıtlamaları aş"),
    "cancelBtn": MessageLookupByLibrary.simpleMessage("İptal"),
    "cancelDisconnects": MessageLookupByLibrary.simpleMessage("Bağlantı kopmaları"),
    "cancelDowntimes": MessageLookupByLibrary.simpleMessage("Kesintiler"),
    "cancelError7040": MessageLookupByLibrary.simpleMessage("Hata 7040"),
    "cancelLatency": MessageLookupByLibrary.simpleMessage("Gecikme"),
    "cancelMissingFeatures": MessageLookupByLibrary.simpleMessage("Eksik özellikler"),
    "cancelSpeed": MessageLookupByLibrary.simpleMessage("Hız"),
    "cancelSubscriptionPromptDesc": MessageLookupByLibrary.simpleMessage(
      "Aboneliğini iptal etmek istediğinden emin misin?",
    ),
    "cancelSubscriptionTitle": MessageLookupByLibrary.simpleMessage("Aboneliği iptal et"),
    "cancelSubscriptionWarningDesc": MessageLookupByLibrary.simpleMessage(
      "Aboneliğin iptal edilecek. Erişimin bitene kadar Mysterium VPN’i kullanmaya devam edebilirsin.",
    ),
    "cancelSurveyFeedbackHint": MessageLookupByLibrary.simpleMessage(
      "Lütfen daha fazla ayrıntı gir...",
    ),
    "cancelSurveyTellUsMoreHint": MessageLookupByLibrary.simpleMessage(
      "Daha fazla anlat (isteğe bağlı)",
    ),
    "cancelSurveyTitle": MessageLookupByLibrary.simpleMessage("İptal nedenleri"),
    "cancelTooExpensive": MessageLookupByLibrary.simpleMessage("Çok pahalı"),
    "cancelUnableToAccessBlockedSites": MessageLookupByLibrary.simpleMessage(
      "Engellenen sitelere erişemiyorum",
    ),
    "cancelUsabilityIssues": MessageLookupByLibrary.simpleMessage("Kullanılabilirlik sorunları"),
    "cancelYourSubsMess": MessageLookupByLibrary.simpleMessage(
      "Hesabını silmeden önce App Store aboneliklerinden aboneliğini iptal et.",
    ),
    "cancellationDateLbl": MessageLookupByLibrary.simpleMessage("İptal tarihi:"),
    "checkSubsStatusFailedDesc": MessageLookupByLibrary.simpleMessage(
      "Plan bilgilerine ulaşamıyoruz.",
    ),
    "checkSubsStatusFailedTitle": MessageLookupByLibrary.simpleMessage(
      "Plan bilgileri mevcut değil",
    ),
    "checkSubsStatusTitle": MessageLookupByLibrary.simpleMessage("Plan bilgileri alınıyor..."),
    "checkYourEmail": MessageLookupByLibrary.simpleMessage("E-postanı kontrol et"),
    "clearSearchBtn": MessageLookupByLibrary.simpleMessage("Aramayı temizle"),
    "closeBtn": MessageLookupByLibrary.simpleMessage("Kapat"),
    "communicationLbl": MessageLookupByLibrary.simpleMessage("İletişim"),
    "communicationLblDesktop": MessageLookupByLibrary.simpleMessage("İLETİŞİM"),
    "completeBtn": MessageLookupByLibrary.simpleMessage("Tamamla"),
    "confirm": MessageLookupByLibrary.simpleMessage("Onayla"),
    "confirmCancellationTitle": MessageLookupByLibrary.simpleMessage("İptali onayla"),
    "connect": MessageLookupByLibrary.simpleMessage("Bağlan"),
    "connectBestServer": MessageLookupByLibrary.simpleMessage("En iyi sunucu"),
    "connectToLocationBtn": m3,
    "connected": MessageLookupByLibrary.simpleMessage("Bağlandı"),
    "connectedSince": MessageLookupByLibrary.simpleMessage("Bağlantı süresi"),
    "connecting": MessageLookupByLibrary.simpleMessage("Bağlanıyor"),
    "connectingToPaymentProcesor": MessageLookupByLibrary.simpleMessage(
      "Ödeme işlemcisine bağlanılıyor...",
    ),
    "connection": MessageLookupByLibrary.simpleMessage("Bağlantı"),
    "connectionDetails": MessageLookupByLibrary.simpleMessage("Bağlantı ayrıntıları"),
    "connectionSettingLbl": MessageLookupByLibrary.simpleMessage("Bağlantı ve Koruma"),
    "connectionTimeout": MessageLookupByLibrary.simpleMessage(
      "Bağlantı zaman aşımına uğradı. Lütfen daha sonra tekrar dene. Sorun devam ederse destek ekibiyle iletişime geç",
    ),
    "consistentSpeedReason": MessageLookupByLibrary.simpleMessage("Tutarlı hız"),
    "consumeLink": MessageLookupByLibrary.simpleMessage(
      "Yalnızca talep eden cihazda çalışır - devam etmek için e-postandaki bağlantıya dokun.",
    ),
    "continueBtn": MessageLookupByLibrary.simpleMessage("Devam et"),
    "continueCancellationOnWebDesc": MessageLookupByLibrary.simpleMessage(
      "İptali tamamlamak için Mysterium VPN web sitesine yönlendirileceksin.",
    ),
    "continueCancellationOnWebTitle": MessageLookupByLibrary.simpleMessage(
      "İptale web’de devam et",
    ),
    "continueToCancelBtn": MessageLookupByLibrary.simpleMessage("İptale devam et"),
    "continueToWebBtn": MessageLookupByLibrary.simpleMessage("Siteye git"),
    "continueWithApple": MessageLookupByLibrary.simpleMessage("Apple ile devam et"),
    "continueWithEmail": MessageLookupByLibrary.simpleMessage("E-posta ile devam et"),
    "continueWithGoogle": MessageLookupByLibrary.simpleMessage("Google ile devam et"),
    "copyLink": MessageLookupByLibrary.simpleMessage("Bağlantıyı kopyala ve tarayıcına yapıştır"),
    "couponCodeCopied": m4,
    "dark": MessageLookupByLibrary.simpleMessage("Koyu"),
    "dataCentreComparisonCardItem1": MessageLookupByLibrary.simpleMessage("Kolayca tespit edilir"),
    "dataCentreComparisonCardItem2": MessageLookupByLibrary.simpleMessage("Sık sık engellenir"),
    "dataCentreComparisonCardItem3": MessageLookupByLibrary.simpleMessage("Daha az gizli"),
    "dataCentreComparisonCardLbl": MessageLookupByLibrary.simpleMessage("VERİ MERKEZİ IP\'LERİ"),
    "dataCentreComparisonCardTitle": MessageLookupByLibrary.simpleMessage("Çoğu VPN"),
    "de": MessageLookupByLibrary.simpleMessage("Almanca"),
    "deleteAccount": MessageLookupByLibrary.simpleMessage("Hesabı sil"),
    "deleteAccountQuestion": MessageLookupByLibrary.simpleMessage("Hesap silinsin mi?"),
    "deleteBtn": MessageLookupByLibrary.simpleMessage("Sil"),
    "deviceLimitReachedDesc": MessageLookupByLibrary.simpleMessage(
      "Bağlı cihaz sayısının üst sınırına ulaştın. Yeni bir cihaz eklemek için hesabından mevcut bir cihazı kaldır.",
    ),
    "deviceLimitReachedOpenDashboard": MessageLookupByLibrary.simpleMessage("Panosu aç"),
    "deviceLimitReachedTitle": MessageLookupByLibrary.simpleMessage("Cihaz Sınırına Ulaşıldı"),
    "disconnect": MessageLookupByLibrary.simpleMessage("Bağlantıyı kes"),
    "disconnected": MessageLookupByLibrary.simpleMessage("Bağlantı kesildi"),
    "disconnecting": MessageLookupByLibrary.simpleMessage("Bağlantı kesiliyor"),
    "discountedPriceLabel": MessageLookupByLibrary.simpleMessage("Yalnızca"),
    "dns": MessageLookupByLibrary.simpleMessage("DNS koruması"),
    "dnsDesc": MessageLookupByLibrary.simpleMessage("DNS sızıntılarını önler"),
    "doneBtn": MessageLookupByLibrary.simpleMessage("Tamam"),
    "duration": MessageLookupByLibrary.simpleMessage("Süre"),
    "email": MessageLookupByLibrary.simpleMessage("E-posta adresi"),
    "emailIsNotValid": MessageLookupByLibrary.simpleMessage("E-posta adresi geçerli değil"),
    "emailIsRequired": MessageLookupByLibrary.simpleMessage("E-posta adresi gerekli"),
    "emailNotificationsSetting": MessageLookupByLibrary.simpleMessage("E-posta Bildirimleri"),
    "emailSentTo": m5,
    "en": MessageLookupByLibrary.simpleMessage("İngilizce"),
    "es": MessageLookupByLibrary.simpleMessage("İspanyolca"),
    "existingSubscriptionDesc": m6,
    "existingSubscriptionTitle": MessageLookupByLibrary.simpleMessage(
      "Çıkış yapıp e-postanla deneyebilir veya bu uyarıyı yoksayabilirsin",
    ),
    "failedToConnectError": m7,
    "failedToSubmitFeedback": MessageLookupByLibrary.simpleMessage(
      "Geri bildirim gönderilemedi. Lütfen tekrar dene.",
    ),
    "failedToSubscribe": MessageLookupByLibrary.simpleMessage(
      "Aboneliğinle ilgili bir sorun oluştu. Lütfen tekrar dene!",
    ),
    "failedToVerifySubs": MessageLookupByLibrary.simpleMessage(
      "Son abonelik satın alımını doğrulayamadık. Tekrar denemek için aşağıdaki düğmeye dokun.",
    ),
    "fastLabel": MessageLookupByLibrary.simpleMessage("Hızlı"),
    "featureToggleMinVersionNotSatisfied": MessageLookupByLibrary.simpleMessage(
      "Uygulama sürümün güncel değil. Kullanmaya devam etmek için lütfen uygulamayı güncelle.",
    ),
    "formValidationError": MessageLookupByLibrary.simpleMessage(
      "Geçersiz form verisi. Lütfen alanları kontrol edip tekrar dene.",
    ),
    "fr": MessageLookupByLibrary.simpleMessage("Fransızca"),
    "france": MessageLookupByLibrary.simpleMessage("Fransa"),
    "frequentDisconnectsReason": MessageLookupByLibrary.simpleMessage("Sık bağlantı kesilmesi"),
    "fullPriceLabel": MessageLookupByLibrary.simpleMessage("Tam fiyat:"),
    "germany": MessageLookupByLibrary.simpleMessage("Almanya"),
    "getNewIPAddress": MessageLookupByLibrary.simpleMessage("Yenilemede yeni bir IP adresi al"),
    "getSubscriptionModalDesc": MessageLookupByLibrary.simpleMessage(
      "Bağlantını güvence altına al ve anında gizli gezinmenin keyfini çıkar",
    ),
    "getSubscriptionModalTitle": m8,
    "getSubscriptionPlanBtn": m9,
    "gettingIPAddress": MessageLookupByLibrary.simpleMessage("IP adresi alınıyor..."),
    "goBackButton": MessageLookupByLibrary.simpleMessage("Geri dön"),
    "goToLoginBtn": MessageLookupByLibrary.simpleMessage("Girişe git"),
    "helpSupportLbl": MessageLookupByLibrary.simpleMessage("Yardım ve Destek"),
    "hi": MessageLookupByLibrary.simpleMessage("Hintçe"),
    "hiddenLbl": MessageLookupByLibrary.simpleMessage("Gizli"),
    "highLatencyReason": MessageLookupByLibrary.simpleMessage("Yüksek gecikme"),
    "highSpeed": MessageLookupByLibrary.simpleMessage("Veri merkezi"),
    "homeLbl": MessageLookupByLibrary.simpleMessage("Ana sayfa"),
    "id": MessageLookupByLibrary.simpleMessage("Endonezce"),
    "incorrectLocationReason": MessageLookupByLibrary.simpleMessage("Hatalı konum"),
    "incorrectMagicLink": MessageLookupByLibrary.simpleMessage(
      "Hatalı sihirli bağlantı. Lütfen tekrar dene.",
    ),
    "ipAddressLbl": MessageLookupByLibrary.simpleMessage("IP adresi"),
    "ipDetails": MessageLookupByLibrary.simpleMessage("IP ayrıntıları"),
    "ipPool": MessageLookupByLibrary.simpleMessage("IP havuzu"),
    "ipPoolLabel": m10,
    "ipRefreshExhaustedCity": m11,
    "ipRefreshExhaustedCountry": m12,
    "ipType": MessageLookupByLibrary.simpleMessage("IP türü"),
    "ipTypeDataCenter": MessageLookupByLibrary.simpleMessage("Veri merkezi IP\'leri"),
    "ipTypeDataCenterDisclaimer": MessageLookupByLibrary.simpleMessage(
      "Hız ve performans için optimize edilmiş veri merkezi IP\'leri.",
    ),
    "ipTypeResidential": MessageLookupByLibrary.simpleMessage("Konut IP\'leri"),
    "ipTypeResidentialDisclaimer": MessageLookupByLibrary.simpleMessage(
      "Gerçek hanelerce sağlanır. Neredeyse tespit edilemez ama daha az kararlıdır.",
    ),
    "ipTypeResidentialTooltipBody": MessageLookupByLibrary.simpleMessage(
      "Konut IP\'leri gerçek ev cihazlarınca sağlanır, bu yüzden kullanılabilirlik zamanla değişebilir.\n\nBir düğüm çevrimdışı olursa uygulama seni en yakın kullanılabilir konut IP\'sine yeniden bağlar.",
    ),
    "ipTypeResidentialTooltipTitle": MessageLookupByLibrary.simpleMessage(
      "IP\'m neden değişebilir?",
    ),
    "it": MessageLookupByLibrary.simpleMessage("İtalyanca"),
    "italy": MessageLookupByLibrary.simpleMessage("İtalya"),
    "ja": MessageLookupByLibrary.simpleMessage("Japonca"),
    "keepSubscriptionBtn": MessageLookupByLibrary.simpleMessage("Aboneliği koru"),
    "killSwitch": MessageLookupByLibrary.simpleMessage("Kill switch"),
    "killSwitchDesc": MessageLookupByLibrary.simpleMessage(
      "VPN bağlantısı kesilirse internet trafiğini engeller",
    ),
    "languageSettingLbl": MessageLookupByLibrary.simpleMessage("Dil"),
    "light": MessageLookupByLibrary.simpleMessage("Açık"),
    "linkCopied": MessageLookupByLibrary.simpleMessage("Bağlantı panoya kopyalandı!"),
    "linkExpires": MessageLookupByLibrary.simpleMessage(
      "Bağlantı 30 dakika içinde sona erer ve yalnızca bir kez kullanılabilir.",
    ),
    "location": MessageLookupByLibrary.simpleMessage("Konum"),
    "locationItemCityCount": m13,
    "locationItemNodeCount": m14,
    "locationItemStatesCount": m15,
    "locationLbl": MessageLookupByLibrary.simpleMessage("Konum"),
    "locationUnavailableAction": MessageLookupByLibrary.simpleMessage("En yakın IP\'ye bağlan"),
    "locationUnavailableSubtitle": MessageLookupByLibrary.simpleMessage(
      "En yakın IP\'ye bağlan - ya da manuel olarak seç",
    ),
    "locationUnavailableTitle": m16,
    "locationsUpdateFailed": m17,
    "locationsUpdated": m18,
    "loginSessionExpired": MessageLookupByLibrary.simpleMessage(
      "Oturumunun süresi doldu. Lütfen tekrar giriş yap.",
    ),
    "loginSignupLabel": MessageLookupByLibrary.simpleMessage("Giriş yap veya kayıt ol"),
    "logout": MessageLookupByLibrary.simpleMessage("Çıkış yap"),
    "logoutConfirmationDesc": MessageLookupByLibrary.simpleMessage(
      "Çıkış yapmak üzeresin. Emin misin?",
    ),
    "logoutConfirmationTitle": MessageLookupByLibrary.simpleMessage("Çıkış yap"),
    "logoutVPNConnectedDesc": MessageLookupByLibrary.simpleMessage(
      "VPN açık. Çıkış yapmaya devam edersen VPN sunucusuyla bağlantın kesilir.",
    ),
    "lowLatencyReason": MessageLookupByLibrary.simpleMessage("Düşük gecikme"),
    "madridLbl": MessageLookupByLibrary.simpleMessage("Madrid, İspanya 🇪🇸"),
    "malwareLbl": MessageLookupByLibrary.simpleMessage("Kötü amaçlı yazılım"),
    "manageOnWebBtn": MessageLookupByLibrary.simpleMessage("Web\'de yönet"),
    "marketingConsentPopupDesc": MessageLookupByLibrary.simpleMessage(
      "Mysterium Network\'ten e-posta güncellemeleri, gizlilik ipuçları ve özel teklifler almak ister misin?",
    ),
    "marketingConsentPopupTitle": MessageLookupByLibrary.simpleMessage("E-postayla güncel kal"),
    "month": MessageLookupByLibrary.simpleMessage("ay"),
    "monthly": MessageLookupByLibrary.simpleMessage("aylık"),
    "myIp": MessageLookupByLibrary.simpleMessage("IP adresim"),
    "navLocations": MessageLookupByLibrary.simpleMessage("Konumlar"),
    "navMap": MessageLookupByLibrary.simpleMessage("Harita"),
    "navProducts": MessageLookupByLibrary.simpleMessage("Ürünler"),
    "nextBilling": m19,
    "nextBillingDateLbl": MessageLookupByLibrary.simpleMessage("Sonraki fatura tarihi:"),
    "no": MessageLookupByLibrary.simpleMessage("Hayır"),
    "noActiveSubsDesc": MessageLookupByLibrary.simpleMessage("Etkin aboneliğin yok"),
    "noEmailApp": MessageLookupByLibrary.simpleMessage("Cihazında e-posta uygulaması yok."),
    "noLocationsFound": MessageLookupByLibrary.simpleMessage("Konum bulunamadı"),
    "noServersAvailable": MessageLookupByLibrary.simpleMessage("Kullanılabilir sunucu yok"),
    "noServersAvailableSub": MessageLookupByLibrary.simpleMessage(
      "Bağlantı sorunu var ve kullanılabilir sunucu yok. Lütfen daha sonra dene.",
    ),
    "noSubscriptionAction": MessageLookupByLibrary.simpleMessage("Planı al"),
    "noSubscriptionTitle": MessageLookupByLibrary.simpleMessage("Etkin plan yok"),
    "noneLbl": MessageLookupByLibrary.simpleMessage("Hiçbiri"),
    "notAvailableMsg": MessageLookupByLibrary.simpleMessage("Kullanılamıyor"),
    "notNowBtn": MessageLookupByLibrary.simpleMessage("Şimdi değil"),
    "notReadyToCancelTitle": MessageLookupByLibrary.simpleMessage(
      "Henüz iptal etmeye hazır değil misin?",
    ),
    "nsfwLbl": MessageLookupByLibrary.simpleMessage("NSFW ve Kötü Amaçlı Yazılım"),
    "onboardingStep1Desc": MessageLookupByLibrary.simpleMessage(
      "IP adresin ve konumun web sitelerine, izleme araçlarına ve halka açık Wi-Fi ağlarına görünür durumda.",
    ),
    "onboardingStep1Title": MessageLookupByLibrary.simpleMessage("Bağlantın açıkta"),
    "onboardingStep2Desc": MessageLookupByLibrary.simpleMessage(
      "Mysterium VPN, IP adresini, ISP\'ni ve konumunu gizler; böylece gerçek gizlilikle gezinebilirsin.",
    ),
    "onboardingStep2Title": MessageLookupByLibrary.simpleMessage(
      "Gerçek kimliğini tek dokunuşla gizle",
    ),
    "onboardingStep3Desc": MessageLookupByLibrary.simpleMessage(
      "Konut IP\'leriyle bağlantın doğal görünür - tipik VPN trafiği gibi değil.",
    ),
    "onboardingStep3Title": MessageLookupByLibrary.simpleMessage("Tüm VPN\'ler aynı çalışmaz"),
    "openEmailApp": MessageLookupByLibrary.simpleMessage("E-posta uygulamasını aç"),
    "openSystemSettingsBtn": MessageLookupByLibrary.simpleMessage("Sistem ayarlarını aç"),
    "optional": MessageLookupByLibrary.simpleMessage("isteğe bağlı"),
    "or": MessageLookupByLibrary.simpleMessage("VEYA"),
    "orSelectCountryManually": MessageLookupByLibrary.simpleMessage(
      "Seni en iyi sunucuya bağlayacağız - ya da manuel olarak bir ülke seçebilirsin.",
    ),
    "otherReason": MessageLookupByLibrary.simpleMessage("Diğer..."),
    "pauseDurationRequiredError": MessageLookupByLibrary.simpleMessage(
      "Lütfen bir duraklatma süresi seç.",
    ),
    "pauseForMonths": m20,
    "pauseSubscriptionBtn": MessageLookupByLibrary.simpleMessage("Aboneliği duraklat"),
    "pauseSubscriptionInfoDesc": MessageLookupByLibrary.simpleMessage(
      "Aboneliğini faturalandırma döngüsü başına bir kez duraklatabilirsin.",
    ),
    "pendingTransactionMessage": MessageLookupByLibrary.simpleMessage(
      "Devam eden bir ödeme işlemin zaten var. Yeni bir işlem başlatmadan önce lütfen bunu tamamla.",
    ),
    "perMonth": MessageLookupByLibrary.simpleMessage("ay"),
    "pl": MessageLookupByLibrary.simpleMessage("Lehçe"),
    "planAlreadyPurchasedMsg": MessageLookupByLibrary.simpleMessage(
      "Her şey hazır! Bu plan zaten etkin.",
    ),
    "plan_2_years": MessageLookupByLibrary.simpleMessage("2 Yıllık Plan"),
    "plan_2_years_basic": MessageLookupByLibrary.simpleMessage("Basic 2 yıl"),
    "plan_2_years_pro": MessageLookupByLibrary.simpleMessage("Pro 2 yıl"),
    "plan_6_months": MessageLookupByLibrary.simpleMessage("6 Aylık Plan"),
    "plan_monthly": MessageLookupByLibrary.simpleMessage("Aylık Plan"),
    "plan_monthly_basic": MessageLookupByLibrary.simpleMessage("Basic aylık"),
    "plan_monthly_plus": MessageLookupByLibrary.simpleMessage("Plus aylık"),
    "plan_monthly_pro": MessageLookupByLibrary.simpleMessage("Pro aylık"),
    "plan_yearly": MessageLookupByLibrary.simpleMessage("Yıllık Plan"),
    "plan_yearly_basic": MessageLookupByLibrary.simpleMessage("Basic yıllık"),
    "plan_yearly_plus": MessageLookupByLibrary.simpleMessage("Plus yıllık"),
    "plan_yearly_pro": MessageLookupByLibrary.simpleMessage("Pro yıllık"),
    "poland": MessageLookupByLibrary.simpleMessage("Polonya"),
    "preferences": MessageLookupByLibrary.simpleMessage("Tercihler"),
    "pricingPlanSeePlansBtn": MessageLookupByLibrary.simpleMessage("Tüm planları gör"),
    "privacyPolicy": MessageLookupByLibrary.simpleMessage("Gizlilik Politikası"),
    "processingPayment": MessageLookupByLibrary.simpleMessage(
      "Ödemeni işliyoruz. Kısa süre içinde her şey hazır olacak…",
    ),
    "productsActivePlanWebSyncAlert": MessageLookupByLibrary.simpleMessage(
      "Zaten etkin bir planın var. Web\'de yükselt - değişiklikler otomatik senkronize olur",
    ),
    "productsAllPlansLbl": MessageLookupByLibrary.simpleMessage("Tüm planlar:"),
    "productsBasicDescription": MessageLookupByLibrary.simpleMessage(
      "Günlük gizlilik için temel özellikler",
    ),
    "productsDuration1Month": MessageLookupByLibrary.simpleMessage("1 ay"),
    "productsDuration1Year": MessageLookupByLibrary.simpleMessage("1 Yıl"),
    "productsDuration2Year": MessageLookupByLibrary.simpleMessage("2 Yıl"),
    "productsExploreSubtitle": MessageLookupByLibrary.simpleMessage(
      "Planları ve özellikleri keşfet",
    ),
    "productsManageSubtitle": MessageLookupByLibrary.simpleMessage("Web\'de yönet ve yükselt"),
    "productsMaxPlanAlert": MessageLookupByLibrary.simpleMessage(
      "Zaten mevcut en yüksek plandasın.",
    ),
    "productsNotAvailable": MessageLookupByLibrary.simpleMessage(
      "Şu anda kullanılabilir ürün yok. Lütfen daha sonra tekrar dene.",
    ),
    "productsPlusDescription": MessageLookupByLibrary.simpleMessage(
      "Daha fazla cihaz, daha fazla konum",
    ),
    "productsProDescription": MessageLookupByLibrary.simpleMessage(
      "Yoğun kullanıcılar için maksimum koruma",
    ),
    "productsSubscribeWebAlert": MessageLookupByLibrary.simpleMessage(
      "Abonelikler web\'de yönetilir. Planın uygulamaya otomatik senkronize olur.",
    ),
    "productsSubscribeWebSubtitle": MessageLookupByLibrary.simpleMessage("Web\'de abone ol"),
    "productsTitle": MessageLookupByLibrary.simpleMessage("VPN ürünleri"),
    "protectedLbl": MessageLookupByLibrary.simpleMessage("KORUMALI"),
    "protocol": MessageLookupByLibrary.simpleMessage("Protokol"),
    "protocolLabel": m21,
    "protocolPickerSettingDesc": MessageLookupByLibrary.simpleMessage(
      "VPN protokolünü değiştirmek bağlantını kesecek. Sonrasında yeniden bağlanman gerekir.",
    ),
    "protocolPickerSettingTitle": MessageLookupByLibrary.simpleMessage(
      "VPN protokolünü değiştirme",
    ),
    "pt": MessageLookupByLibrary.simpleMessage("Portekizce"),
    "ptBR": MessageLookupByLibrary.simpleMessage("Brezilya Portekizcesi"),
    "pushNotificationsConsentPopupDesc": MessageLookupByLibrary.simpleMessage(
      "Yeni özellikler, faydalı ipuçları ve özel teklifler hakkında bildirim al - yalnızca yararlı güncellemeler.",
    ),
    "pushNotificationsConsentPopupTitle": MessageLookupByLibrary.simpleMessage(
      "Anlık bildirimlerle güncel kal",
    ),
    "pushNotificationsSetting": MessageLookupByLibrary.simpleMessage("Anlık Bildirimler"),
    "pushNotificationsSettingDesc": MessageLookupByLibrary.simpleMessage(
      "Ürün güncellemeleri, ipuçları ve özel teklifler",
    ),
    "qaToolboxLbl": MessageLookupByLibrary.simpleMessage("QA Toolbox"),
    "rateConnection": MessageLookupByLibrary.simpleMessage("Bağlantın nasıl?"),
    "rateConnectionDislike": MessageLookupByLibrary.simpleMessage("Neyi beğenmedin?"),
    "rateConnectionLike": MessageLookupByLibrary.simpleMessage("Neyi beğendin?"),
    "reactivateSubscriptionAnytimeDesc": MessageLookupByLibrary.simpleMessage(
      "Erişimin bitmeden aboneliğini istediğin zaman yeniden etkinleştirebilirsin.",
    ),
    "recentLocations": MessageLookupByLibrary.simpleMessage("Son konumlar"),
    "redeemDiscountCode": MessageLookupByLibrary.simpleMessage("İndirim kodunu kullan"),
    "redirectToLoginPage": MessageLookupByLibrary.simpleMessage(
      "Hesabın başarıyla silindi. Giriş ekranına yönlendirileceksin.",
    ),
    "refresh": MessageLookupByLibrary.simpleMessage("Yenile"),
    "refreshIP": MessageLookupByLibrary.simpleMessage("IP\'yi yenile"),
    "refreshIPAddress": MessageLookupByLibrary.simpleMessage("IP adresini yenile"),
    "refreshLocationsTooltip": m22,
    "resetAppDesc": MessageLookupByLibrary.simpleMessage("Bir şey çalışmadığında sıfırla"),
    "resetAppDialogContent": MessageLookupByLibrary.simpleMessage(
      "Uygulamayı sıfırlamaya devam edersen Mysterium VPN bağlantın kesilir.",
    ),
    "resetAppDialogTitle": MessageLookupByLibrary.simpleMessage("VPN bağlantısı şu anda etkin"),
    "resetAppFailed": MessageLookupByLibrary.simpleMessage(
      "Uygulama sıfırlanamadı. Lütfen tekrar dene.",
    ),
    "resetAppSuccess": MessageLookupByLibrary.simpleMessage("Uygulama başarıyla sıfırlandı."),
    "resetAppTitle": MessageLookupByLibrary.simpleMessage("Uygulamayı sıfırla"),
    "resetBtn": MessageLookupByLibrary.simpleMessage("Sıfırla"),
    "residential": MessageLookupByLibrary.simpleMessage("Konut"),
    "residentialCentreComparisonCardItem1": MessageLookupByLibrary.simpleMessage(
      "Gerçek kullanıcı gibi görünür",
    ),
    "residentialCentreComparisonCardItem2": MessageLookupByLibrary.simpleMessage(
      "Tespiti daha zor",
    ),
    "residentialCentreComparisonCardItem3": MessageLookupByLibrary.simpleMessage("Daha az engel"),
    "residentialCentreComparisonCardLbl": MessageLookupByLibrary.simpleMessage("KONUT IP\'LERİ"),
    "residentialEducationBlock1Body": MessageLookupByLibrary.simpleMessage(
      "Konut IP\'leri gerçek ev cihazlarından gelir; böylece trafiğin normal internet kullanımı gibi görünür.",
    ),
    "residentialEducationBlock1Title": MessageLookupByLibrary.simpleMessage("Gerçek ev cihazları"),
    "residentialEducationBlock2Body": MessageLookupByLibrary.simpleMessage(
      "Bu IP\'ler gerçek cihazlardan geldiği için bazı düğümler zaman zaman çevrimdışı olabilir.",
    ),
    "residentialEducationBlock2Title": MessageLookupByLibrary.simpleMessage(
      "Kullanılabilirlik değişebilir",
    ),
    "residentialEducationBlock3Body": MessageLookupByLibrary.simpleMessage(
      "Mevcut IP\'n kullanılamaz hale gelirse uygulama seni en yakın kullanılabilir konut IP\'sine yeniden bağlar.",
    ),
    "residentialEducationBlock3Title": MessageLookupByLibrary.simpleMessage(
      "Otomatik yeniden bağlanma",
    ),
    "residentialEducationGotIt": MessageLookupByLibrary.simpleMessage("Anladım"),
    "residentialEducationSubtitle": MessageLookupByLibrary.simpleMessage(
      "Konut IP\'leri veri merkezi IP\'lerinden farklıdır. İşte beklemen gerekenler.",
    ),
    "residentialEducationTitle": MessageLookupByLibrary.simpleMessage(
      "Konut IP\'leri nasıl çalışır",
    ),
    "retryBtn": MessageLookupByLibrary.simpleMessage("Yeniden dene"),
    "reviewLeaveReviewBtn": MessageLookupByLibrary.simpleMessage("Yorum bırak"),
    "reviewPositiveTitle": MessageLookupByLibrary.simpleMessage(
      "Harika! Bize bir yorum bırakır mısın?",
    ),
    "reviewSatisfactionTitle": MessageLookupByLibrary.simpleMessage(
      "Bu uygulamayı başkalarına önerir misin?",
    ),
    "searchForLocations": MessageLookupByLibrary.simpleMessage("Konum ara"),
    "seePlansBtn": MessageLookupByLibrary.simpleMessage("Planları gör"),
    "selectEmailApp": MessageLookupByLibrary.simpleMessage(
      "Devam etmek için e-posta uygulaması seç",
    ),
    "semiAnnual": MessageLookupByLibrary.simpleMessage("altı ayda bir"),
    "sendAgain": m23,
    "serviceUnavailableError": MessageLookupByLibrary.simpleMessage(
      "Geçici ağ sorunları yaşıyoruz. Lütfen daha sonra tekrar dene..",
    ),
    "settingManageBtn": MessageLookupByLibrary.simpleMessage("Yönet"),
    "settings": MessageLookupByLibrary.simpleMessage("Ayarlar"),
    "setupTunnerPermissionsDialogDesc": MessageLookupByLibrary.simpleMessage(
      "Mysterium VPN\'i kullanmak için bir VPN profili kurma iznine ihtiyacımız var.",
    ),
    "setupTunnerPermissionsDialogDisclaimer": MessageLookupByLibrary.simpleMessage(
      "Anonimliğin güvende. Tarama etkinliğinin hiçbirini görmüyor, toplamıyor veya saklamıyoruz.",
    ),
    "setupTunnerPermissionsDialogTitle": MessageLookupByLibrary.simpleMessage(
      "İznine ihtiyacımız var",
    ),
    "signIn": MessageLookupByLibrary.simpleMessage("Mysterium VPN\'e giriş yap"),
    "signInAbortedMsg": MessageLookupByLibrary.simpleMessage("Giriş iptal edildi"),
    "signInBtn": MessageLookupByLibrary.simpleMessage("Giriş yap"),
    "signInDisclaimer": MessageLookupByLibrary.simpleMessage(
      "Mysterium VPN çevrimiçi etkinliklerini kaydetmez ve sana, cihazına, IP adresine veya e-postana hiçbir kayıt bağlanmaz. Giriş yaparak şunları kabul edersin:",
    ),
    "sixMonths": MessageLookupByLibrary.simpleMessage("6 ay"),
    "skipBtn": MessageLookupByLibrary.simpleMessage("Atla"),
    "somethingWentWrong": MessageLookupByLibrary.simpleMessage(
      "Bir sorun oluştu. Lütfen tekrar dene!",
    ),
    "stableConnectionReason": MessageLookupByLibrary.simpleMessage("Kararlı bağlantı"),
    "status": MessageLookupByLibrary.simpleMessage("Durum"),
    "stayButton": MessageLookupByLibrary.simpleMessage("Kal"),
    "stayOnAppBtn": MessageLookupByLibrary.simpleMessage("Uygulamada kal"),
    "submitBtn": MessageLookupByLibrary.simpleMessage("Gönder"),
    "subscribeOnWebBtn": MessageLookupByLibrary.simpleMessage("Web\'de abone ol"),
    "subscriptionActive": MessageLookupByLibrary.simpleMessage(
      "Harika haber! Aboneliğin artık etkin.",
    ),
    "subscriptionAllPlansBackToPlans": MessageLookupByLibrary.simpleMessage("Planlara geri dön"),
    "subscriptionAllPlansCompareAll": MessageLookupByLibrary.simpleMessage(
      "Tüm özellikleri karşılaştır",
    ),
    "subscriptionAllPlansCurrentPlan": MessageLookupByLibrary.simpleMessage("Mevcut plan"),
    "subscriptionAllPlansPurchase": MessageLookupByLibrary.simpleMessage("Planı al"),
    "subscriptionAllPlansTabMonth": MessageLookupByLibrary.simpleMessage("Aylık"),
    "subscriptionAllPlansTabYear": MessageLookupByLibrary.simpleMessage("1 Yıl"),
    "subscriptionAllPlansTitle": MessageLookupByLibrary.simpleMessage("Tüm planlar"),
    "subscriptionAllPlansUpgrade": MessageLookupByLibrary.simpleMessage("Planını yükselt"),
    "subscriptionCancelledTitle": MessageLookupByLibrary.simpleMessage("Abonelik iptal edildi"),
    "subscriptionOnboardingBoostProtectionDescription": MessageLookupByLibrary.simpleMessage(
      "VPN protokolleri ve kötü amaçlı yazılım engelleme gibi gelişmiş özellikleri keşfet.",
    ),
    "subscriptionOnboardingBoostProtectionTitle": MessageLookupByLibrary.simpleMessage(
      "Korumanı güçlendir",
    ),
    "subscriptionOnboardingCancelTourLabel": MessageLookupByLibrary.simpleMessage("Şimdilik atla"),
    "subscriptionOnboardingConnectDescription": MessageLookupByLibrary.simpleMessage(
      "Seni en iyi sunucuya bağlayacağız.",
    ),
    "subscriptionOnboardingConnectTitle": MessageLookupByLibrary.simpleMessage(
      "Gizli kalmak için bağlan",
    ),
    "subscriptionOnboardingManagePlanDescription": MessageLookupByLibrary.simpleMessage(
      "Hesap erişimine göre plan satın al, yükselt veya mevcut planları görüntüle.",
    ),
    "subscriptionOnboardingManagePlanTitle": MessageLookupByLibrary.simpleMessage("Planını yönet"),
    "subscriptionOnboardingMapDesktopDescription": MessageLookupByLibrary.simpleMessage(
      "Haritaya göz at veya kenar çubuğundan konumları keşfet.",
    ),
    "subscriptionOnboardingMapDesktopTitle": MessageLookupByLibrary.simpleMessage(
      "Konumları kendi tarzında keşfet",
    ),
    "subscriptionOnboardingMapMobileDescription": MessageLookupByLibrary.simpleMessage(
      "Haritaya göz atarak bir ülke seç ve anında bağlan.",
    ),
    "subscriptionOnboardingMapMobileTitle": MessageLookupByLibrary.simpleMessage(
      "Haritadan bağlan",
    ),
    "subscriptionOnboardingPromptDescription": MessageLookupByLibrary.simpleMessage(
      "Güncellenen uygulamada yolunu öğren ve önemli özelliklerin artık nerede olduğunu keşfet.",
    ),
    "subscriptionOnboardingPromptTitle": MessageLookupByLibrary.simpleMessage("Kısa bir tura çık"),
    "subscriptionOnboardingSearchDescription": MessageLookupByLibrary.simpleMessage(
      "Aramayla ülkeleri, şehirleri ve sunucuları hızlıca bul.",
    ),
    "subscriptionOnboardingSearchTitle": MessageLookupByLibrary.simpleMessage(
      "Daha hızlı ara ve bağlan",
    ),
    "subscriptionOnboardingSetupCompleteDescription": MessageLookupByLibrary.simpleMessage(
      "Daha gizli gezinmeye başlamak için bir konum seç.",
    ),
    "subscriptionOnboardingSetupCompleteTitle": MessageLookupByLibrary.simpleMessage(
      "Kurulum tamamlandı",
    ),
    "subscriptionOnboardingStartTourLabel": MessageLookupByLibrary.simpleMessage("Tura başla"),
    "subscriptionOnboardingVPNLocationsDesktopDescription": MessageLookupByLibrary.simpleMessage(
      "Ülkeleri ve şehirleri tek yerde keşfet.",
    ),
    "subscriptionOnboardingVPNLocationsMobileDescription": MessageLookupByLibrary.simpleMessage(
      "Ülkeleri, şehirleri, son bağlantıları ve özel sunucuları tek yerde keşfet.",
    ),
    "subscriptionOnboardingVPNLocationsTitle": MessageLookupByLibrary.simpleMessage(
      "VPN konumlarına göz at",
    ),
    "subscriptionPlanBestValue": MessageLookupByLibrary.simpleMessage("EN İYİ FİYAT"),
    "subscriptionPlanCityLevel": MessageLookupByLibrary.simpleMessage("Şehir düzeyinde seçim"),
    "subscriptionPlanCityLevelDesc": MessageLookupByLibrary.simpleMessage(
      "Çoğu VPN\'e göre daha hassas konum kontrolü sunar; VPN\'ler genellikle seni tüm ülkeleri veya eyaletleri seçmekle sınırlar.",
    ),
    "subscriptionPlanDevicesSecured": MessageLookupByLibrary.simpleMessage(
      "Aynı anda korunan cihazlar",
    ),
    "subscriptionPlanDoubleVPN": MessageLookupByLibrary.simpleMessage("Çift VPN"),
    "subscriptionPlanDoubleVPNDesc": MessageLookupByLibrary.simpleMessage(
      "Ekstra güvenlik katmanı. İnternet trafiğini iki farklı VPN sunucusu üzerinden yönlendirir, verilerini iki kez şifreler ve IP adresini ikinci bir sunucunun arkasında gizler",
    ),
    "subscriptionPlanMalwareBlocker": MessageLookupByLibrary.simpleMessage(
      "Kötü amaçlı yazılım engelleyici",
    ),
    "subscriptionPlanMalwareBlockerDesc": MessageLookupByLibrary.simpleMessage(
      "Tehditleri cihazına ulaşmadan durdurarak seni korur, seni rahatsız etmeden arka planda sessizce çalışır.",
    ),
    "subscriptionPlanMoneyBack": MessageLookupByLibrary.simpleMessage(
      "7 günlük para iade garantisi",
    ),
    "subscriptionPlanNameBasic": MessageLookupByLibrary.simpleMessage("Basic"),
    "subscriptionPlanNamePlus": MessageLookupByLibrary.simpleMessage("Plus"),
    "subscriptionPlanNamePro": MessageLookupByLibrary.simpleMessage("Pro"),
    "subscriptionPlanPF1Basic": MessageLookupByLibrary.simpleMessage("Aynı anda 6 cihazı koru"),
    "subscriptionPlanPF1Plus": MessageLookupByLibrary.simpleMessage("Aynı anda 10 cihazı koru"),
    "subscriptionPlanPF2Basic": MessageLookupByLibrary.simpleMessage("57 desteklenen ülke"),
    "subscriptionPlanPF2Plus": MessageLookupByLibrary.simpleMessage("100+ desteklenen ülke"),
    "subscriptionPlanPF3Basic": MessageLookupByLibrary.simpleMessage("10 sunucu"),
    "subscriptionPlanPF3Plus": MessageLookupByLibrary.simpleMessage("100 sunucu"),
    "subscriptionPlanPF4Basic": MessageLookupByLibrary.simpleMessage("VPN protokolü"),
    "subscriptionPlanPF4Plus": MessageLookupByLibrary.simpleMessage("7.500+ konut IP"),
    "subscriptionPlanPF5Plus": MessageLookupByLibrary.simpleMessage("VPN protokolü"),
    "subscriptionPlanPF6Plus": MessageLookupByLibrary.simpleMessage("Şehir düzeyinde seçim"),
    "subscriptionPlanResidentialIPs": MessageLookupByLibrary.simpleMessage("Konut IP\'leri"),
    "subscriptionPlanResidentialIPsDesc": MessageLookupByLibrary.simpleMessage(
      "Normal bir ev kullanıcısı gibi görünerek streaming hizmetlerine erişmeni ve VPN tespitinden kaçınmanı sağlar.",
    ),
    "subscriptionPlanSavePercent": m24,
    "subscriptionPlanSaveWith": m25,
    "subscriptionPlanServers": MessageLookupByLibrary.simpleMessage("Sunucular"),
    "subscriptionPlanSupportedCountries": MessageLookupByLibrary.simpleMessage(
      "Desteklenen ülkeler",
    ),
    "subscriptionPlanWireGuard": MessageLookupByLibrary.simpleMessage("VPN protokolü"),
    "subscriptionPlanWireGuardDesc": MessageLookupByLibrary.simpleMessage(
      "WireGuard - oyun ve streaming için en iyi hızlı protokol\nOpenVPN - diğer protokollerin başarısız olduğu yerlerde çalışan, yüksek düzeyde yapılandırılabilir protokol (Android\'de kullanılamaz)",
    ),
    "subscriptionProcessCanceled": MessageLookupByLibrary.simpleMessage(
      "Aboneliğindeki değişiklikleri tamamlamadın.",
    ),
    "subscriptionUpgrade": MessageLookupByLibrary.simpleMessage("Yükselt"),
    "subscriptionUpgradeCTA": m26,
    "subscriptionUpgradeModalDescription": MessageLookupByLibrary.simpleMessage(
      "7.500+ konut IP\'ye erişmek için",
    ),
    "subscriptionUpgradeModalTitle": m27,
    "subscriptionUpgradeSeeAllPlans": MessageLookupByLibrary.simpleMessage("Tüm planları gör"),
    "subscriptionVerificationFailed": MessageLookupByLibrary.simpleMessage(
      "Doğrulamayı Yeniden Dene",
    ),
    "subscripton": MessageLookupByLibrary.simpleMessage("Abonelik"),
    "switchToLocationBtn": m28,
    "system": MessageLookupByLibrary.simpleMessage("Sistem"),
    "takeBackTheInternetLbl": MessageLookupByLibrary.simpleMessage("İnterneti geri al."),
    "termsAndConditions": MessageLookupByLibrary.simpleMessage("Şartlar ve Koşullar"),
    "title": MessageLookupByLibrary.simpleMessage("Merhaba"),
    "toManyRequestsErrorMsg": MessageLookupByLibrary.simpleMessage(
      "Çok fazla istek. Lütfen daha sonra tekrar dene.",
    ),
    "tokenAlreadyUsed": MessageLookupByLibrary.simpleMessage(
      "Jeton zaten kullanıldı. Lütfen tekrar dene.\n",
    ),
    "tooManyConnectionsBannerCTADisconnect": MessageLookupByLibrary.simpleMessage("Bağlantıyı kes"),
    "tooManyConnectionsBannerCTAReconnect": MessageLookupByLibrary.simpleMessage("Yeniden bağlan"),
    "tooManyConnectionsBannerDesc": MessageLookupByLibrary.simpleMessage(
      "Hesabında bağlı 6 cihaz üst sınırına ulaştın. VPN\'i kullanmaya devam etmek için yeniden bağlanmaya dokun.",
    ),
    "tooManyConnectionsBannerDescConnected": MessageLookupByLibrary.simpleMessage(
      "Hesabında bağlı 6 cihaz üst sınırına ulaştın. VPN\'i kullanmaya devam etmek için bağlantıyı kesip tekrar dene.",
    ),
    "tooManyConnectionsBannerTitle": MessageLookupByLibrary.simpleMessage("Bağlantın Kesildi"),
    "topLocations": MessageLookupByLibrary.simpleMessage("En iyi konumlar"),
    "tr": MessageLookupByLibrary.simpleMessage("Türkçe"),
    "tryAgainBtn": MessageLookupByLibrary.simpleMessage("Tekrar dene"),
    "tryAnotherLocation": MessageLookupByLibrary.simpleMessage("Başka bir konum aramayı dene"),
    "tunnelPermissionRequired": MessageLookupByLibrary.simpleMessage(
      "VPN tünelini başlatmak için izin vermen gerekiyor.",
    ),
    "tunnelSetupError": MessageLookupByLibrary.simpleMessage("Tünel kurulurken bir hata oluştu"),
    "typeDelete": m29,
    "typeFeedback": MessageLookupByLibrary.simpleMessage("Geri bildirimini buraya yaz..."),
    "ukraine": MessageLookupByLibrary.simpleMessage("Ukrayna"),
    "unableToConnectToPaymentProcesor": MessageLookupByLibrary.simpleMessage(
      "Ödeme işlemcisine bağlanılamıyor! Lütfen tekrar dene.",
    ),
    "unauthenticatedBannerTitle": MessageLookupByLibrary.simpleMessage("Giriş yapmadın"),
    "unauthenticatedSettingSubtitle": MessageLookupByLibrary.simpleMessage(
      "Hesabına erişmek ve tüm özelliklerin kilidini açmak için giriş yap",
    ),
    "unauthenticatedSettingTitle": MessageLookupByLibrary.simpleMessage("Giriş yapmadın"),
    "unprotectedLbl": MessageLookupByLibrary.simpleMessage("KORUMASIZ"),
    "unstableSpeedReason": MessageLookupByLibrary.simpleMessage("Kararsız hız"),
    "updateBtn": MessageLookupByLibrary.simpleMessage("Güncelle"),
    "userIntentBestSpeed": MessageLookupByLibrary.simpleMessage("En iyi hız"),
    "userIntentBestSpeedDesc": MessageLookupByLibrary.simpleMessage(
      "En iyi performans için mevcut en hızlı sunucuya bağlan",
    ),
    "userIntentLabel": MessageLookupByLibrary.simpleMessage("Özel sunucu"),
    "userIntentLowLatency": MessageLookupByLibrary.simpleMessage("Düşük gecikme"),
    "userIntentLowLatencyDesc": MessageLookupByLibrary.simpleMessage(
      "Kararlı ve güvenilir erişim için seni otomatik olarak en yakın sunucuya bağlar",
    ),
    "userIntentMaxPrivacy": MessageLookupByLibrary.simpleMessage("Maksimum gizlilik"),
    "userIntentMaxPrivacyDesc": MessageLookupByLibrary.simpleMessage(
      "Ülkeye göre en iyi ifade özgürlüğü ve hız seçeneklerine sahip bir sunucu al",
    ),
    "userIntentNearestLocation": MessageLookupByLibrary.simpleMessage("En yakın konum"),
    "userIntentNearestLocationDesc": MessageLookupByLibrary.simpleMessage(
      "Mevcut konumuna göre en iyi hız ve performans için seni en yakın kullanılabilir VPN IP\'sine bağlar",
    ),
    "userIntentP2P": MessageLookupByLibrary.simpleMessage("P2P"),
    "userIntentP2PDesc": MessageLookupByLibrary.simpleMessage(
      "Güvenli kripto işlemleri, dosya paylaşımı, oyun barındırma ve iletişim için en iyi sunucuyu seç",
    ),
    "userIntentStreaming": MessageLookupByLibrary.simpleMessage("Streaming"),
    "userIntentStreamingDesc": MessageLookupByLibrary.simpleMessage(
      "Bölgeye özel platformlardan favori dizi ve filmlerine eriş",
    ),
    "viewAllFeaturesBtn": MessageLookupByLibrary.simpleMessage("Tüm özellikleri gör"),
    "viewLessBtn": MessageLookupByLibrary.simpleMessage("Daha az göster"),
    "vodafoneLbl": MessageLookupByLibrary.simpleMessage("Vodafone Iberia"),
    "vpnDetails": MessageLookupByLibrary.simpleMessage("VPN ayrıntıları"),
    "vpnIp": MessageLookupByLibrary.simpleMessage("VPN IP\'si"),
    "vpnProtocolSettingLbl": MessageLookupByLibrary.simpleMessage("VPN protokolü"),
    "year": MessageLookupByLibrary.simpleMessage("yıl"),
    "yearly": MessageLookupByLibrary.simpleMessage("yıllık"),
    "yes": MessageLookupByLibrary.simpleMessage("Evet"),
    "zh": MessageLookupByLibrary.simpleMessage("Çince"),
  };
}
