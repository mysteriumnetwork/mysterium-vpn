// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ar locale. All the
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
  String get localeName => 'ar';

  static String m0(date) => "الوصول متاح حتى ${date}";

  static String m1(store) => "لديك بالفعل اشتراك نشط مدفوع عبر ${store}. يمكنك إدارته من ${store}.";

  static String m2(amount, period) => "${amount} /${period}";

  static String m3(amount, period) => "${amount}/شهر — يُحصَّل ${period}";

  static String m4(location) => "الاتصال بـ ${location}";

  static String m5(couponCode) => "تم نسخ ${couponCode} إلى الحافظة!";

  static String m6(email) => "أرسلنا بريدًا إلكترونيًا إلى ${email}";

  static String m7(email) => "قد يكون لديك بالفعل اشتراك مدفوع باستخدام “${email}”";

  static String m8(errorCode) => "فشل الاتصال. يُرجى المحاولة مرة أخرى [الخطأ: ${errorCode}]";

  static String m9(plan) => "احصل على ${plan}";

  static String m10(plan) => "احصل على خطة اشتراك ${plan}";

  static String m11(count) => "${count} :مجموعة IP";

  static String m12(location) =>
      "لا تتوفر عناوين IP بديلة في ${location}. اختر دولة أو مدينة أخرى للحصول على عنوان IP مختلف في المرة القادمة.";

  static String m13(location) =>
      "لا تتوفر عناوين IP بديلة في ${location}. اختر دولة أخرى للحصول على عنوان IP مختلف في المرة القادمة.";

  static String m14(count) =>
      "${Intl.plural(count, zero: '${count} مدينة', one: 'مدينة واحدة', two: 'مدينتان', few: '${count} مدن', many: '${count} مدينة', other: '${count} مدينة')}";

  static String m15(count) =>
      "${Intl.plural(count, zero: '${count} IP', one: 'IP واحد', two: 'عنوانا IP', few: '${count} عناوين IP', many: '${count} عنوان IP', other: '${count} IP')}";

  static String m16(count) =>
      "${Intl.plural(count, zero: '${count} ولاية', one: 'ولاية واحدة', two: 'ولايتان', few: '${count} ولايات', many: '${count} ولاية', other: '${count} ولاية')}";

  static String m17(location) => "${location} غير متاح";

  static String m18(location) => "تعذّر تحديث ${location}";

  static String m19(location) => "تم تحديث ${location}";

  static String m20(date) => "الفوترة التالية: ${date}";

  static String m21(count) =>
      "${Intl.plural(count, zero: 'إيقاف مؤقت لمدة ${count} شهر', one: 'إيقاف مؤقت لمدة شهر', two: 'إيقاف مؤقت لمدة شهرين', few: 'إيقاف مؤقت لمدة ${count} أشهر', many: 'إيقاف مؤقت لمدة ${count} شهرًا', other: 'إيقاف مؤقت لمدة ${count} شهر')}";

  static String m22(date) => "متوقف مؤقتًا حتى ${date}";

  static String m23(protocol, label) => "${protocol} (${label})";

  static String m24(location) => "تحديث ${location}";

  static String m25(date) => "يتجدد في ${date}";

  static String m26(count) =>
      "${Intl.plural(count, zero: 'إعادة الإرسال', one: 'إعادة الإرسال', two: 'إعادة الإرسال', few: 'إعادة الإرسال (${count})', many: 'إعادة الإرسال (${count})', other: 'إعادة الإرسال (${count})')}";

  static String m27(percent) => "وفّر ${percent}%";

  static String m28(percent, planId) => "وفّر ${percent}% مع خطة ${planId}";

  static String m29(plan) => "الترقية إلى ${plan}";

  static String m30(plan) => "الترقية إلى خطة ${plan}";

  static String m31(location) => "التبديل إلى ${location}";

  static String m32(word) => "اكتب ${word}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "LoggingYouIn": MessageLookupByLibrary.simpleMessage("جارٍ تسجيل دخولك..."),
    "acceptOfferBtn": MessageLookupByLibrary.simpleMessage("قبول العرض"),
    "accessAvailableUntilLbl": MessageLookupByLibrary.simpleMessage("الوصول متاح حتى:"),
    "accessBlockedSitesReason": MessageLookupByLibrary.simpleMessage(
      "تعذّر الوصول إلى المواقع المحجوبة",
    ),
    "accessUntil": m0,
    "account": MessageLookupByLibrary.simpleMessage("الحساب"),
    "accountSuccessfullyDeleted": MessageLookupByLibrary.simpleMessage("تم حذف الحساب"),
    "activeSubsPaidVia": m1,
    "allLocations": MessageLookupByLibrary.simpleMessage("جميع المواقع"),
    "allowBtn": MessageLookupByLibrary.simpleMessage("اسمح"),
    "allowNotificationsBtn": MessageLookupByLibrary.simpleMessage("السماح بالإشعارات"),
    "allowPushNotificationsBtn": MessageLookupByLibrary.simpleMessage("السماح بالإشعارات"),
    "and": MessageLookupByLibrary.simpleMessage(" و "),
    "appUpdateAvailableDesc": MessageLookupByLibrary.simpleMessage(
      "الإصدار الجديد من التطبيق متاح الآن! حدّثه للحصول على أحدث الميزات والتحسينات.",
    ),
    "appUpdateAvailableSetting": MessageLookupByLibrary.simpleMessage("يتوفر تحديث للتطبيق!"),
    "appUpdateAvailableTitle": MessageLookupByLibrary.simpleMessage("يتوفر تحديث للتطبيق"),
    "appearanceSettingLbl": MessageLookupByLibrary.simpleMessage("المظهر"),
    "ar": MessageLookupByLibrary.simpleMessage("العربية"),
    "austria": MessageLookupByLibrary.simpleMessage("النمسا"),
    "authenticationFailed": MessageLookupByLibrary.simpleMessage(
      "تعذّر تسجيل الدخول. يُرجى المحاولة مرة أخرى.",
    ),
    "back": MessageLookupByLibrary.simpleMessage("رجوع"),
    "backToSettingsLbl": MessageLookupByLibrary.simpleMessage("العودة إلى الإعدادات"),
    "batterySaverLabel": MessageLookupByLibrary.simpleMessage("موفّر البطارية"),
    "berlinLbl": MessageLookupByLibrary.simpleMessage("برلين، ألمانيا 🇩🇪"),
    "billedInTotal": m2,
    "billedPerMonth": m3,
    "blockerSettingLbl": MessageLookupByLibrary.simpleMessage("المانع"),
    "buttonUpdateApp": MessageLookupByLibrary.simpleMessage("حدّث الآن"),
    "bypassRestrictionsReason": MessageLookupByLibrary.simpleMessage("تجاوز القيود"),
    "cancelBtn": MessageLookupByLibrary.simpleMessage("إلغاء"),
    "cancelDisconnects": MessageLookupByLibrary.simpleMessage("انقطاعات الاتصال"),
    "cancelDowntimes": MessageLookupByLibrary.simpleMessage("انقطاعات"),
    "cancelError7040": MessageLookupByLibrary.simpleMessage("خطأ 7040"),
    "cancelLatency": MessageLookupByLibrary.simpleMessage("الكمون"),
    "cancelMissingFeatures": MessageLookupByLibrary.simpleMessage("ميزات مفقودة"),
    "cancelSpeed": MessageLookupByLibrary.simpleMessage("السرعة"),
    "cancelSubscriptionPromptDesc": MessageLookupByLibrary.simpleMessage(
      "هل أنت متأكد أنك تريد إلغاء اشتراكك؟",
    ),
    "cancelSubscriptionTitle": MessageLookupByLibrary.simpleMessage("إلغاء الاشتراك"),
    "cancelSubscriptionWarningDesc": MessageLookupByLibrary.simpleMessage(
      "سيتم إلغاء اشتراكك. يمكنك مواصلة استخدام Mysterium VPN حتى ينتهي وصولك.",
    ),
    "cancelSurveyFeedbackHint": MessageLookupByLibrary.simpleMessage(
      "يُرجى إدخال المزيد من التفاصيل...",
    ),
    "cancelSurveyTellUsMoreHint": MessageLookupByLibrary.simpleMessage("أخبرنا بالمزيد (اختياري)"),
    "cancelSurveyTitle": MessageLookupByLibrary.simpleMessage("أسباب الإلغاء"),
    "cancelTooExpensive": MessageLookupByLibrary.simpleMessage("باهظ الثمن"),
    "cancelUnableToAccessBlockedSites": MessageLookupByLibrary.simpleMessage(
      "غير قادر على الوصول إلى المواقع المحجوبة",
    ),
    "cancelUsabilityIssues": MessageLookupByLibrary.simpleMessage("مشاكل في سهولة الاستخدام"),
    "cancelYourSubsMess": MessageLookupByLibrary.simpleMessage(
      "ألغِ اشتراكك في اشتراكات App Store قبل حذف حسابك.",
    ),
    "cancellationDateLbl": MessageLookupByLibrary.simpleMessage("تاريخ الإلغاء:"),
    "cancelled": MessageLookupByLibrary.simpleMessage("ملغى"),
    "checkSubsStatusFailedDesc": MessageLookupByLibrary.simpleMessage(
      "تعذّر علينا استرداد معلومات خطتك.",
    ),
    "checkSubsStatusFailedTitle": MessageLookupByLibrary.simpleMessage("معلومات الخطة غير متوفرة"),
    "checkSubsStatusTitle": MessageLookupByLibrary.simpleMessage(
      "جارٍ الحصول على معلومات الخطة...",
    ),
    "checkYourEmail": MessageLookupByLibrary.simpleMessage("تحقق من بريدك الإلكتروني"),
    "clearSearchBtn": MessageLookupByLibrary.simpleMessage("مسح البحث"),
    "closeBtn": MessageLookupByLibrary.simpleMessage("إغلاق"),
    "communicationLbl": MessageLookupByLibrary.simpleMessage("الاتصالات"),
    "communicationLblDesktop": MessageLookupByLibrary.simpleMessage("الاتصالات"),
    "completeBtn": MessageLookupByLibrary.simpleMessage("إكمال"),
    "confirm": MessageLookupByLibrary.simpleMessage("تأكيد"),
    "confirmCancellationTitle": MessageLookupByLibrary.simpleMessage("تأكيد الإلغاء"),
    "connect": MessageLookupByLibrary.simpleMessage("اتصال"),
    "connectBestServer": MessageLookupByLibrary.simpleMessage("أفضل خادم"),
    "connectToLocationBtn": m4,
    "connected": MessageLookupByLibrary.simpleMessage("متصل"),
    "connectedSince": MessageLookupByLibrary.simpleMessage("مدة الاتصال"),
    "connecting": MessageLookupByLibrary.simpleMessage("جارٍ الاتصال"),
    "connectingToPaymentProcesor": MessageLookupByLibrary.simpleMessage(
      "جارٍ الاتصال بمعالج الدفع...",
    ),
    "connection": MessageLookupByLibrary.simpleMessage("الاتصال"),
    "connectionDetails": MessageLookupByLibrary.simpleMessage("تفاصيل الاتصال"),
    "connectionSettingLbl": MessageLookupByLibrary.simpleMessage("الاتصال والحماية"),
    "connectionTimeout": MessageLookupByLibrary.simpleMessage(
      "انتهت مهلة الاتصال. يُرجى المحاولة لاحقًا. إذا استمرت المشكلة، تواصل مع فريق الدعم",
    ),
    "consistentSpeedReason": MessageLookupByLibrary.simpleMessage("سرعة ثابتة"),
    "consumeLink": MessageLookupByLibrary.simpleMessage(
      "يعمل فقط على الجهاز الذي طلبه — اضغط الرابط في بريدك الإلكتروني للمتابعة.",
    ),
    "continueBtn": MessageLookupByLibrary.simpleMessage("متابعة"),
    "continueCancellationOnWebDesc": MessageLookupByLibrary.simpleMessage(
      "سيتم توجيهك إلى موقع Mysterium VPN لإكمال الإلغاء.",
    ),
    "continueCancellationOnWebTitle": MessageLookupByLibrary.simpleMessage(
      "متابعة الإلغاء عبر الويب",
    ),
    "continueToCancelBtn": MessageLookupByLibrary.simpleMessage("متابعة الإلغاء"),
    "continueToWebBtn": MessageLookupByLibrary.simpleMessage("المتابعة إلى الموقع"),
    "continueWithApple": MessageLookupByLibrary.simpleMessage("المتابعة عبر Apple"),
    "continueWithEmail": MessageLookupByLibrary.simpleMessage("المتابعة عبر البريد الإلكتروني"),
    "continueWithGoogle": MessageLookupByLibrary.simpleMessage("المتابعة عبر Google"),
    "copyLink": MessageLookupByLibrary.simpleMessage("انسخ الرابط والصقه في متصفحك"),
    "couponCodeCopied": m5,
    "dark": MessageLookupByLibrary.simpleMessage("داكن"),
    "dataCentreComparisonCardItem1": MessageLookupByLibrary.simpleMessage("سهلة الاكتشاف"),
    "dataCentreComparisonCardItem2": MessageLookupByLibrary.simpleMessage(
      "كثيرًا ما تحجبها المواقع",
    ),
    "dataCentreComparisonCardItem3": MessageLookupByLibrary.simpleMessage("أقل خصوصية"),
    "dataCentreComparisonCardLbl": MessageLookupByLibrary.simpleMessage(
      "عناوين IP لمراكز البيانات",
    ),
    "dataCentreComparisonCardTitle": MessageLookupByLibrary.simpleMessage("معظم شبكات VPN"),
    "datacenterIpBadge": MessageLookupByLibrary.simpleMessage("عنوان IP لمركز بيانات"),
    "de": MessageLookupByLibrary.simpleMessage("الألمانية"),
    "deleteAccount": MessageLookupByLibrary.simpleMessage("حذف الحساب"),
    "deleteAccountQuestion": MessageLookupByLibrary.simpleMessage("حذف الحساب؟"),
    "deleteBtn": MessageLookupByLibrary.simpleMessage("حذف"),
    "deviceLimitReachedDesc": MessageLookupByLibrary.simpleMessage(
      "لقد بلغت الحد الأقصى لعدد الأجهزة المتصلة. لإضافة جهاز جديد، أزِل جهازًا موجودًا من حسابك.",
    ),
    "deviceLimitReachedOpenDashboard": MessageLookupByLibrary.simpleMessage("فتح لوحة التحكم"),
    "deviceLimitReachedTitle": MessageLookupByLibrary.simpleMessage("تم بلوغ حد الأجهزة"),
    "disconnect": MessageLookupByLibrary.simpleMessage("قطع الاتصال"),
    "disconnected": MessageLookupByLibrary.simpleMessage("غير متصل"),
    "disconnecting": MessageLookupByLibrary.simpleMessage("جارٍ قطع الاتصال"),
    "discountedPriceLabel": MessageLookupByLibrary.simpleMessage("فقط"),
    "dismissNewIpPreview": MessageLookupByLibrary.simpleMessage("إغلاق معاينة عنوان IP الجديد"),
    "dns": MessageLookupByLibrary.simpleMessage("حماية DNS"),
    "dnsDesc": MessageLookupByLibrary.simpleMessage("يمنع تسريبات DNS"),
    "doneBtn": MessageLookupByLibrary.simpleMessage("تم"),
    "duration": MessageLookupByLibrary.simpleMessage("المدة"),
    "email": MessageLookupByLibrary.simpleMessage("عنوان البريد الإلكتروني"),
    "emailIsNotValid": MessageLookupByLibrary.simpleMessage("عنوان البريد الإلكتروني غير صالح"),
    "emailIsRequired": MessageLookupByLibrary.simpleMessage("عنوان البريد الإلكتروني مطلوب"),
    "emailNotificationsSetting": MessageLookupByLibrary.simpleMessage("إشعارات البريد الإلكتروني"),
    "emailSentTo": m6,
    "en": MessageLookupByLibrary.simpleMessage("الإنجليزية"),
    "es": MessageLookupByLibrary.simpleMessage("الإسبانية"),
    "existingSubscriptionDesc": m7,
    "existingSubscriptionTitle": MessageLookupByLibrary.simpleMessage(
      "يمكنك تسجيل الخروج والمحاولة ببريدك الإلكتروني أو تجاهل هذا التحذير",
    ),
    "failedToConnectError": m8,
    "failedToSubmitFeedback": MessageLookupByLibrary.simpleMessage(
      "فشل إرسال الملاحظات. يُرجى المحاولة مرة أخرى.",
    ),
    "failedToSubscribe": MessageLookupByLibrary.simpleMessage(
      "حدث خطأ ما في اشتراكك. يُرجى المحاولة مرة أخرى!",
    ),
    "failedToVerifySubs": MessageLookupByLibrary.simpleMessage(
      "تعذّر التحقق من آخر عملية شراء لاشتراكك. اضغط الزر أدناه لإعادة المحاولة.",
    ),
    "fastLabel": MessageLookupByLibrary.simpleMessage("سريع"),
    "favoriteIpAddAction": MessageLookupByLibrary.simpleMessage("إضافة إلى عناوين IP المفضلة"),
    "favoriteIpAddedToast": MessageLookupByLibrary.simpleMessage("تمت إضافة عنوان IP إلى المفضلة"),
    "favoriteIpLimitReached": MessageLookupByLibrary.simpleMessage(
      "تم بلوغ الحد الأقصى لعناوين IP المفضلة. احذف عنوانًا لحفظ عنوان جديد.",
    ),
    "favoriteIpRemoveAction": MessageLookupByLibrary.simpleMessage("إزالة من عناوين IP المفضلة"),
    "favoriteIpRemovedToast": MessageLookupByLibrary.simpleMessage("تمت إزالة عنوان IP من المفضلة"),
    "favoriteIpsDisclaimer": MessageLookupByLibrary.simpleMessage(
      "قد تتغير إمكانية توفّر عناوين IP المحفوظة مع الوقت. أصبح عنوان IP المفضّل لديك غير متاح، لذا وصّلناك بأقرب موقع متاح.",
    ),
    "favoriteIpsEmptyBody": MessageLookupByLibrary.simpleMessage(
      "اتصل ثم اضغط على القلب في بطاقة الاتصال لحفظ عنوان IP والوصول إليه بسرعة.",
    ),
    "favoriteIpsEmptyTitle": MessageLookupByLibrary.simpleMessage("لا توجد عناوين IP مفضلة بعد"),
    "favoriteIpsLabel": MessageLookupByLibrary.simpleMessage("عناوين IP المفضلة"),
    "favoriteIpsLockedBody": MessageLookupByLibrary.simpleMessage(
      "قم بالترقية إلى Plus أو Pro لحفظ عناوين IP الأنسب لك والوصول إليها بسرعة وقتما تشاء.",
    ),
    "favoriteIpsLockedTitle": MessageLookupByLibrary.simpleMessage("احفظ عناوين IP المفضلة"),
    "favoriteIpsNotAvailableOnPlan": MessageLookupByLibrary.simpleMessage(
      "عناوين IP المحفوظة غير متاحة في خطتك الحالية.",
    ),
    "favoriteIpsTab": MessageLookupByLibrary.simpleMessage("المفضلة"),
    "favoriteIpsUnavailableHeading": MessageLookupByLibrary.simpleMessage("عناوين IP غير المتاحة"),
    "favoriteIpsUpgradePlan": MessageLookupByLibrary.simpleMessage("ترقية الخطة"),
    "featureToggleMinVersionNotSatisfied": MessageLookupByLibrary.simpleMessage(
      "إصدار تطبيقك قديم. يُرجى تحديث التطبيق لمواصلة استخدامه.",
    ),
    "formValidationError": MessageLookupByLibrary.simpleMessage(
      "بيانات النموذج غير صالحة. يُرجى التحقق من الحقول والمحاولة مرة أخرى.",
    ),
    "fr": MessageLookupByLibrary.simpleMessage("الفرنسية"),
    "france": MessageLookupByLibrary.simpleMessage("فرنسا"),
    "frequentDisconnectsReason": MessageLookupByLibrary.simpleMessage("انقطاعات متكررة"),
    "fullPriceLabel": MessageLookupByLibrary.simpleMessage("السعر الكامل:"),
    "germany": MessageLookupByLibrary.simpleMessage("ألمانيا"),
    "getAPlanBtn": MessageLookupByLibrary.simpleMessage("احصل على خطة"),
    "getNewIPAddress": MessageLookupByLibrary.simpleMessage("احصل على عنوان IP جديد عند التحديث"),
    "getSubscriptionModalDesc": MessageLookupByLibrary.simpleMessage(
      "أمّن اتصالك واستمتع بتصفح خاص فورًا",
    ),
    "getSubscriptionModalTitle": m9,
    "getSubscriptionPlanBtn": m10,
    "gettingIPAddress": MessageLookupByLibrary.simpleMessage("جارٍ الحصول على عنوان IP..."),
    "goBackButton": MessageLookupByLibrary.simpleMessage("رجوع"),
    "goToLoginBtn": MessageLookupByLibrary.simpleMessage("الانتقال إلى تسجيل الدخول"),
    "helpSupportLbl": MessageLookupByLibrary.simpleMessage("المساعدة والدعم"),
    "hi": MessageLookupByLibrary.simpleMessage("الهندية"),
    "hiddenLbl": MessageLookupByLibrary.simpleMessage("مخفي"),
    "highLatencyReason": MessageLookupByLibrary.simpleMessage("زمن استجابة مرتفع"),
    "highSpeed": MessageLookupByLibrary.simpleMessage("مركز البيانات"),
    "homeLbl": MessageLookupByLibrary.simpleMessage("الرئيسية"),
    "id": MessageLookupByLibrary.simpleMessage("الإندونيسية"),
    "incorrectLocationReason": MessageLookupByLibrary.simpleMessage("موقع غير صحيح"),
    "incorrectMagicLink": MessageLookupByLibrary.simpleMessage(
      "رابط سحري غير صحيح. يُرجى المحاولة مرة أخرى.",
    ),
    "ipAddressLbl": MessageLookupByLibrary.simpleMessage("عنوان IP"),
    "ipDetails": MessageLookupByLibrary.simpleMessage("تفاصيل IP"),
    "ipPool": MessageLookupByLibrary.simpleMessage("مجموعة IP"),
    "ipPoolLabel": m11,
    "ipRefreshExhaustedCity": m12,
    "ipRefreshExhaustedCountry": m13,
    "ipType": MessageLookupByLibrary.simpleMessage("نوع IP"),
    "ipTypeDataCenter": MessageLookupByLibrary.simpleMessage("عناوين IP لمراكز البيانات"),
    "ipTypeDataCenterDisclaimer": MessageLookupByLibrary.simpleMessage(
      "عناوين IP لمراكز البيانات مُحسّنة للسرعة والأداء.",
    ),
    "ipTypeDataCenterTab": MessageLookupByLibrary.simpleMessage("مركز بيانات"),
    "ipTypeResidential": MessageLookupByLibrary.simpleMessage("عناوين IP سكنية"),
    "ipTypeResidentialDisclaimer": MessageLookupByLibrary.simpleMessage(
      "مقدّمة من منازل حقيقية. يكاد يستحيل اكتشافها لكنها أقل استقرارًا.",
    ),
    "ipTypeResidentialTab": MessageLookupByLibrary.simpleMessage("سكني"),
    "ipTypeResidentialTooltipBody": MessageLookupByLibrary.simpleMessage(
      "تُقدَّم عناوين IP السكنية من أجهزة منزلية حقيقية، لذا قد يتغير توفرها بمرور الوقت.\n\nإذا انقطع اتصال أحد العُقد، يعيد التطبيق توصيلك بأقرب عنوان IP سكني متاح.",
    ),
    "ipTypeResidentialTooltipTitle": MessageLookupByLibrary.simpleMessage(
      "لماذا قد يتغير عنوان IP الخاص بي؟",
    ),
    "it": MessageLookupByLibrary.simpleMessage("الإيطالية"),
    "italy": MessageLookupByLibrary.simpleMessage("إيطاليا"),
    "ja": MessageLookupByLibrary.simpleMessage("اليابانية"),
    "keepSubscriptionBtn": MessageLookupByLibrary.simpleMessage("الإبقاء على الاشتراك"),
    "killSwitch": MessageLookupByLibrary.simpleMessage("Kill switch"),
    "killSwitchDesc": MessageLookupByLibrary.simpleMessage(
      "يحجب حركة الإنترنت إذا انقطع اتصال VPN",
    ),
    "languageSettingLbl": MessageLookupByLibrary.simpleMessage("اللغة"),
    "light": MessageLookupByLibrary.simpleMessage("فاتح"),
    "linkCopied": MessageLookupByLibrary.simpleMessage("تم نسخ الرابط إلى الحافظة!"),
    "linkExpires": MessageLookupByLibrary.simpleMessage(
      "تنتهي صلاحية الرابط خلال 30 دقيقة ويمكن استخدامه مرة واحدة فقط.",
    ),
    "location": MessageLookupByLibrary.simpleMessage("الموقع"),
    "locationItemCityCount": m14,
    "locationItemNodeCount": m15,
    "locationItemStatesCount": m16,
    "locationLbl": MessageLookupByLibrary.simpleMessage("الموقع"),
    "locationUnavailableAction": MessageLookupByLibrary.simpleMessage("الاتصال بأقرب عنوان IP"),
    "locationUnavailableSubtitle": MessageLookupByLibrary.simpleMessage(
      "اتصل بأقرب عنوان IP — أو اختره يدويًا",
    ),
    "locationUnavailableTitle": m17,
    "locationsUpdateFailed": m18,
    "locationsUpdated": m19,
    "loginSessionExpired": MessageLookupByLibrary.simpleMessage(
      "انتهت صلاحية جلستك. يُرجى تسجيل الدخول مرة أخرى.",
    ),
    "loginSignupLabel": MessageLookupByLibrary.simpleMessage("تسجيل الدخول أو إنشاء حساب"),
    "logout": MessageLookupByLibrary.simpleMessage("تسجيل الخروج"),
    "logoutConfirmationDesc": MessageLookupByLibrary.simpleMessage(
      "أنت على وشك تسجيل الخروج. هل أنت متأكد؟",
    ),
    "logoutConfirmationTitle": MessageLookupByLibrary.simpleMessage("تسجيل الخروج"),
    "logoutVPNConnectedDesc": MessageLookupByLibrary.simpleMessage(
      "VPN مفعّل. سيتم قطع اتصالك بخادم VPN إذا تابعت تسجيل الخروج.",
    ),
    "lowLatencyReason": MessageLookupByLibrary.simpleMessage("زمن استجابة منخفض"),
    "madridLbl": MessageLookupByLibrary.simpleMessage("مدريد، إسبانيا 🇪🇸"),
    "malwareLbl": MessageLookupByLibrary.simpleMessage("برامج ضارة"),
    "manageFavoriteIpsBtn": MessageLookupByLibrary.simpleMessage("إدارة"),
    "manageOnWebBtn": MessageLookupByLibrary.simpleMessage("الإدارة عبر الويب"),
    "marketingConsentPopupDesc": MessageLookupByLibrary.simpleMessage(
      "هل ترغب في تلقي تحديثات بريدية ونصائح خصوصية وعروض خاصة من Mysterium Network؟",
    ),
    "marketingConsentPopupTitle": MessageLookupByLibrary.simpleMessage(
      "ابقَ على اطلاع عبر البريد الإلكتروني",
    ),
    "month": MessageLookupByLibrary.simpleMessage("شهر"),
    "monthly": MessageLookupByLibrary.simpleMessage("شهريًا"),
    "myIp": MessageLookupByLibrary.simpleMessage("عنوان IP الخاص بي"),
    "navLocations": MessageLookupByLibrary.simpleMessage("المواقع"),
    "navMap": MessageLookupByLibrary.simpleMessage("الخريطة"),
    "navProducts": MessageLookupByLibrary.simpleMessage("المنتجات"),
    "nextBilling": m20,
    "nextBillingDateLbl": MessageLookupByLibrary.simpleMessage("تاريخ الفوترة التالي:"),
    "no": MessageLookupByLibrary.simpleMessage("لا"),
    "noActiveSubsDesc": MessageLookupByLibrary.simpleMessage("ليس لديك اشتراك نشط"),
    "noEmailApp": MessageLookupByLibrary.simpleMessage("لا توجد تطبيقات بريد إلكتروني على جهازك."),
    "noLocationsFound": MessageLookupByLibrary.simpleMessage("لم يُعثر على مواقع"),
    "noServersAvailable": MessageLookupByLibrary.simpleMessage("لا توجد خوادم متاحة"),
    "noServersAvailableSub": MessageLookupByLibrary.simpleMessage(
      "توجد مشكلة في الاتصال ولا تتوفر خوادم. يُرجى المحاولة لاحقًا.",
    ),
    "noSubscriptionAction": MessageLookupByLibrary.simpleMessage("الحصول على الخطة"),
    "noSubscriptionTitle": MessageLookupByLibrary.simpleMessage("لا توجد خطة نشطة متاحة"),
    "noneLbl": MessageLookupByLibrary.simpleMessage("بدون"),
    "notAvailableMsg": MessageLookupByLibrary.simpleMessage("غير متاح"),
    "notNowBtn": MessageLookupByLibrary.simpleMessage("ليس الآن"),
    "notReadyToCancelTitle": MessageLookupByLibrary.simpleMessage("لست مستعدًا للإلغاء بعد؟"),
    "nsfwLbl": MessageLookupByLibrary.simpleMessage("NSFW وبرامج ضارة"),
    "onboardingStep1Desc": MessageLookupByLibrary.simpleMessage(
      "عنوان IP وموقعك مرئيان للمواقع وأدوات التتبع وشبكات Wi-Fi العامة.",
    ),
    "onboardingStep1Title": MessageLookupByLibrary.simpleMessage("اتصالك مكشوف"),
    "onboardingStep2Desc": MessageLookupByLibrary.simpleMessage(
      "يُخفي Mysterium VPN عنوان IP ومزوّد خدمة الإنترنت وموقعك لتتصفح بخصوصية حقيقية.",
    ),
    "onboardingStep2Title": MessageLookupByLibrary.simpleMessage("أخفِ هويتك الحقيقية بنقرة واحدة"),
    "onboardingStep3Desc": MessageLookupByLibrary.simpleMessage(
      "مع عناوين IP السكنية، يبدو اتصالك طبيعيًا — وليس كحركة VPN التقليدية.",
    ),
    "onboardingStep3Title": MessageLookupByLibrary.simpleMessage("ليست كل شبكات VPN متشابهة"),
    "openEmailApp": MessageLookupByLibrary.simpleMessage("فتح تطبيق البريد الإلكتروني"),
    "openSystemSettingsBtn": MessageLookupByLibrary.simpleMessage("فتح إعدادات النظام"),
    "optional": MessageLookupByLibrary.simpleMessage("اختياري"),
    "or": MessageLookupByLibrary.simpleMessage("أو"),
    "orSelectCountryManually": MessageLookupByLibrary.simpleMessage(
      "سنوصلك بأفضل خادم — أو يمكنك اختيار دولة يدويًا.",
    ),
    "otherReason": MessageLookupByLibrary.simpleMessage("أخرى..."),
    "pauseDurationRequiredError": MessageLookupByLibrary.simpleMessage(
      "يرجى اختيار مدة الإيقاف المؤقت.",
    ),
    "pauseForMonths": m21,
    "pauseSubscriptionBtn": MessageLookupByLibrary.simpleMessage("إيقاف الاشتراك مؤقتًا"),
    "pauseSubscriptionFailed": MessageLookupByLibrary.simpleMessage(
      "تعذّر إيقاف اشتراكك مؤقتًا. يُرجى المحاولة مرة أخرى.",
    ),
    "pauseSubscriptionInfoDesc": MessageLookupByLibrary.simpleMessage(
      "يمكنك إيقاف خطتك مؤقتًا مرة واحدة لكل دورة فوترة.",
    ),
    "paused": MessageLookupByLibrary.simpleMessage("متوقف مؤقتًا"),
    "pausedUntil": m22,
    "pendingTransactionMessage": MessageLookupByLibrary.simpleMessage(
      "لديك بالفعل عملية دفع جارية. يُرجى إكمالها قبل بدء عملية جديدة.",
    ),
    "perMonth": MessageLookupByLibrary.simpleMessage("شهر"),
    "pl": MessageLookupByLibrary.simpleMessage("البولندية"),
    "planAlreadyPurchasedMsg": MessageLookupByLibrary.simpleMessage(
      "كل شيء جاهز! هذه الخطة مفعّلة لديك بالفعل.",
    ),
    "plan_2_years": MessageLookupByLibrary.simpleMessage("خطة عامين"),
    "plan_2_years_basic": MessageLookupByLibrary.simpleMessage("Basic عامان"),
    "plan_2_years_pro": MessageLookupByLibrary.simpleMessage("Pro عامان"),
    "plan_6_months": MessageLookupByLibrary.simpleMessage("خطة 6 أشهر"),
    "plan_monthly": MessageLookupByLibrary.simpleMessage("الخطة الشهرية"),
    "plan_monthly_basic": MessageLookupByLibrary.simpleMessage("Basic شهري"),
    "plan_monthly_plus": MessageLookupByLibrary.simpleMessage("Plus شهري"),
    "plan_monthly_pro": MessageLookupByLibrary.simpleMessage("Pro شهري"),
    "plan_yearly": MessageLookupByLibrary.simpleMessage("الخطة السنوية"),
    "plan_yearly_basic": MessageLookupByLibrary.simpleMessage("Basic سنوي"),
    "plan_yearly_plus": MessageLookupByLibrary.simpleMessage("Plus سنوي"),
    "plan_yearly_pro": MessageLookupByLibrary.simpleMessage("Pro سنوي"),
    "poland": MessageLookupByLibrary.simpleMessage("بولندا"),
    "preferences": MessageLookupByLibrary.simpleMessage("التفضيلات"),
    "pricingPlanSeePlansBtn": MessageLookupByLibrary.simpleMessage("عرض جميع الخطط"),
    "privacyPolicy": MessageLookupByLibrary.simpleMessage("سياسة الخصوصية"),
    "processingPayment": MessageLookupByLibrary.simpleMessage(
      "نعالج دفعتك الآن. سيصبح كل شيء جاهزًا بعد قليل...",
    ),
    "productsActivePlanWebSyncAlert": MessageLookupByLibrary.simpleMessage(
      "لديك بالفعل خطة نشطة. رقِّها عبر الويب — تتزامن التغييرات تلقائيًا",
    ),
    "productsAllPlansLbl": MessageLookupByLibrary.simpleMessage("جميع الخطط:"),
    "productsBasicDescription": MessageLookupByLibrary.simpleMessage("أساسيات الخصوصية اليومية"),
    "productsDuration1Month": MessageLookupByLibrary.simpleMessage("شهر واحد"),
    "productsDuration1Year": MessageLookupByLibrary.simpleMessage("سنة واحدة"),
    "productsDuration2Year": MessageLookupByLibrary.simpleMessage("عامان"),
    "productsExploreSubtitle": MessageLookupByLibrary.simpleMessage("استكشف الخطط والميزات"),
    "productsManageSubtitle": MessageLookupByLibrary.simpleMessage("الإدارة والترقية عبر الويب"),
    "productsMaxPlanAlert": MessageLookupByLibrary.simpleMessage("أنت بالفعل على أعلى خطة متاحة."),
    "productsNotAvailable": MessageLookupByLibrary.simpleMessage(
      "لا توجد منتجات متاحة حاليًا. يُرجى المحاولة لاحقًا.",
    ),
    "productsPlusDescription": MessageLookupByLibrary.simpleMessage("أجهزة أكثر ومواقع أكثر"),
    "productsProDescription": MessageLookupByLibrary.simpleMessage(
      "أقصى حماية للمستخدمين المكثّفين",
    ),
    "productsSubscribeWebAlert": MessageLookupByLibrary.simpleMessage(
      "تُدار الاشتراكات عبر الويب. ستتزامن خطتك مع التطبيق تلقائيًا.",
    ),
    "productsSubscribeWebSubtitle": MessageLookupByLibrary.simpleMessage("الاشتراك عبر الويب"),
    "productsTitle": MessageLookupByLibrary.simpleMessage("منتجات VPN"),
    "protectedLbl": MessageLookupByLibrary.simpleMessage("محمي"),
    "protocol": MessageLookupByLibrary.simpleMessage("البروتوكول"),
    "protocolLabel": m23,
    "protocolPickerSettingDesc": MessageLookupByLibrary.simpleMessage(
      "سيؤدي تبديل بروتوكول VPN إلى قطع اتصالك. ستحتاج إلى إعادة الاتصال بعد ذلك.",
    ),
    "protocolPickerSettingTitle": MessageLookupByLibrary.simpleMessage("تبديل بروتوكول VPN"),
    "pt": MessageLookupByLibrary.simpleMessage("البرتغالية"),
    "ptBR": MessageLookupByLibrary.simpleMessage("البرتغالية البرازيلية"),
    "pushNotificationsConsentPopupDesc": MessageLookupByLibrary.simpleMessage(
      "احصل على إشعارات بالميزات الجديدة والنصائح المفيدة والعروض الحصرية — تحديثات مفيدة فقط.",
    ),
    "pushNotificationsConsentPopupTitle": MessageLookupByLibrary.simpleMessage(
      "ابقَ على اطلاع عبر الإشعارات",
    ),
    "pushNotificationsSetting": MessageLookupByLibrary.simpleMessage("الإشعارات الفورية"),
    "pushNotificationsSettingDesc": MessageLookupByLibrary.simpleMessage(
      "تحديثات المنتج والنصائح والعروض الخاصة",
    ),
    "qaToolboxLbl": MessageLookupByLibrary.simpleMessage("QA Toolbox"),
    "rateConnection": MessageLookupByLibrary.simpleMessage("كيف هو اتصالك؟"),
    "rateConnectionDislike": MessageLookupByLibrary.simpleMessage("ما الذي لم يعجبك؟"),
    "rateConnectionLike": MessageLookupByLibrary.simpleMessage("ما الذي أعجبك؟"),
    "reactivateSubscriptionAnytimeDesc": MessageLookupByLibrary.simpleMessage(
      "يمكنك إعادة تفعيل اشتراكك في أي وقت قبل انتهاء وصولك.",
    ),
    "recentLocations": MessageLookupByLibrary.simpleMessage("المواقع الأخيرة"),
    "redeemDiscountCode": MessageLookupByLibrary.simpleMessage("استخدام رمز الخصم"),
    "redirectToLoginPage": MessageLookupByLibrary.simpleMessage(
      "تم حذف حسابك بنجاح. سيتم توجيهك إلى شاشة تسجيل الدخول.",
    ),
    "refresh": MessageLookupByLibrary.simpleMessage("تحديث"),
    "refreshIP": MessageLookupByLibrary.simpleMessage("تحديث IP"),
    "refreshIPAddress": MessageLookupByLibrary.simpleMessage("تحديث عنوان IP"),
    "refreshLocationsTooltip": m24,
    "renewsOn": m25,
    "resetAppDesc": MessageLookupByLibrary.simpleMessage("أعد الضبط عندما لا يعمل شيء ما"),
    "resetAppDialogContent": MessageLookupByLibrary.simpleMessage(
      "إذا تابعت إعادة ضبط التطبيق، فسيتم فصلك عن Mysterium VPN.",
    ),
    "resetAppDialogTitle": MessageLookupByLibrary.simpleMessage("اتصال VPN نشط حاليًا"),
    "resetAppFailed": MessageLookupByLibrary.simpleMessage(
      "فشل إعادة ضبط التطبيق. يُرجى المحاولة مرة أخرى.",
    ),
    "resetAppSuccess": MessageLookupByLibrary.simpleMessage("تمت إعادة ضبط التطبيق بنجاح."),
    "resetAppTitle": MessageLookupByLibrary.simpleMessage("إعادة ضبط التطبيق"),
    "resetBtn": MessageLookupByLibrary.simpleMessage("إعادة ضبط"),
    "residential": MessageLookupByLibrary.simpleMessage("سكني"),
    "residentialCentreComparisonCardItem1": MessageLookupByLibrary.simpleMessage(
      "تبدو كمستخدم حقيقي",
    ),
    "residentialCentreComparisonCardItem2": MessageLookupByLibrary.simpleMessage(
      "أصعب في الاكتشاف",
    ),
    "residentialCentreComparisonCardItem3": MessageLookupByLibrary.simpleMessage("حجب أقل"),
    "residentialCentreComparisonCardLbl": MessageLookupByLibrary.simpleMessage("عناوين IP سكنية"),
    "residentialEducationBlock1Body": MessageLookupByLibrary.simpleMessage(
      "تأتي عناوين IP السكنية من أجهزة منزلية حقيقية، مما يجعل حركة بياناتك تبدو كاستخدام عادي للإنترنت.",
    ),
    "residentialEducationBlock1Title": MessageLookupByLibrary.simpleMessage("أجهزة منزلية حقيقية"),
    "residentialEducationBlock2Body": MessageLookupByLibrary.simpleMessage(
      "بما أن هذه العناوين تأتي من أجهزة حقيقية، قد تصبح بعض النقاط غير متصلة من وقت لآخر.",
    ),
    "residentialEducationBlock2Title": MessageLookupByLibrary.simpleMessage("قد يتغير التوفر"),
    "residentialEducationBlock3Body": MessageLookupByLibrary.simpleMessage(
      "إذا أصبح عنوان IP الحالي غير متاح، يعيد التطبيق توصيلك بأقرب عنوان IP سكني متاح.",
    ),
    "residentialEducationBlock3Title": MessageLookupByLibrary.simpleMessage("إعادة اتصال تلقائية"),
    "residentialEducationGotIt": MessageLookupByLibrary.simpleMessage("فهمت"),
    "residentialEducationSubtitle": MessageLookupByLibrary.simpleMessage(
      "تختلف عناوين IP السكنية عن عناوين IP لمراكز البيانات. إليك ما يمكن توقعه.",
    ),
    "residentialEducationTitle": MessageLookupByLibrary.simpleMessage("كيف تعمل عناوين IP السكنية"),
    "residentialIpBadge": MessageLookupByLibrary.simpleMessage("عنوان IP سكني"),
    "resumeBtn": MessageLookupByLibrary.simpleMessage("استئناف"),
    "resumeSubscriptionFailed": MessageLookupByLibrary.simpleMessage(
      "تعذّر استئناف اشتراكك. يُرجى المحاولة مرة أخرى.",
    ),
    "resumeSubscriptionPromptDesc": MessageLookupByLibrary.simpleMessage(
      "سيتم استئناف اشتراكك فورًا.",
    ),
    "resumeSubscriptionTitle": MessageLookupByLibrary.simpleMessage("استئناف الاشتراك؟"),
    "retryBtn": MessageLookupByLibrary.simpleMessage("إعادة المحاولة"),
    "reviewLeaveReviewBtn": MessageLookupByLibrary.simpleMessage("اترك تقييمًا"),
    "reviewPositiveTitle": MessageLookupByLibrary.simpleMessage("رائع! هل تمانع في ترك تقييم لنا؟"),
    "reviewSatisfactionTitle": MessageLookupByLibrary.simpleMessage(
      "هل توصي بهذا التطبيق للآخرين؟",
    ),
    "searchForLocations": MessageLookupByLibrary.simpleMessage("ابحث عن المواقع"),
    "seePlansBtn": MessageLookupByLibrary.simpleMessage("عرض الخطط"),
    "selectEmailApp": MessageLookupByLibrary.simpleMessage("اختر تطبيق البريد الإلكتروني للمتابعة"),
    "semiAnnual": MessageLookupByLibrary.simpleMessage("نصف سنوي"),
    "sendAgain": m26,
    "serviceUnavailableError": MessageLookupByLibrary.simpleMessage(
      "نواجه مشكلات مؤقتة في الشبكة. يُرجى المحاولة لاحقًا..",
    ),
    "settingManageBtn": MessageLookupByLibrary.simpleMessage("إدارة"),
    "settings": MessageLookupByLibrary.simpleMessage("الإعدادات"),
    "setupTunnerPermissionsDialogDesc": MessageLookupByLibrary.simpleMessage(
      "لاستخدام Mysterium VPN، نحتاج إلى إذنك لتثبيت ملف تعريف VPN.",
    ),
    "setupTunnerPermissionsDialogDisclaimer": MessageLookupByLibrary.simpleMessage(
      "هويتك المجهولة آمنة. نحن لا نرى نشاط تصفحك ولا نجمعه ولا نخزّنه.",
    ),
    "setupTunnerPermissionsDialogTitle": MessageLookupByLibrary.simpleMessage("نحتاج إلى إذنك"),
    "signIn": MessageLookupByLibrary.simpleMessage("سجّل الدخول إلى Mysterium VPN"),
    "signInAbortedMsg": MessageLookupByLibrary.simpleMessage("تم إلغاء تسجيل الدخول"),
    "signInBtn": MessageLookupByLibrary.simpleMessage("تسجيل الدخول"),
    "signInDisclaimer": MessageLookupByLibrary.simpleMessage(
      "لا تسجّل Mysterium VPN أنشطتك عبر الإنترنت، ولا ترتبط أي سجلات بك أو بجهازك أو بعنوان IP الخاص بك أو ببريدك الإلكتروني. بتسجيل الدخول، فإنك توافق على",
    ),
    "sixMonths": MessageLookupByLibrary.simpleMessage("6 أشهر"),
    "skipBtn": MessageLookupByLibrary.simpleMessage("تخطي"),
    "somethingWentWrong": MessageLookupByLibrary.simpleMessage(
      "حدث خطأ ما. يُرجى المحاولة مرة أخرى!",
    ),
    "stableConnectionReason": MessageLookupByLibrary.simpleMessage("اتصال مستقر"),
    "status": MessageLookupByLibrary.simpleMessage("الحالة"),
    "stayButton": MessageLookupByLibrary.simpleMessage("البقاء"),
    "stayOnAppBtn": MessageLookupByLibrary.simpleMessage("البقاء في التطبيق"),
    "submitBtn": MessageLookupByLibrary.simpleMessage("إرسال"),
    "subscribeOnWebBtn": MessageLookupByLibrary.simpleMessage("الاشتراك عبر الويب"),
    "subscriptionActive": MessageLookupByLibrary.simpleMessage("خبر رائع! اشتراكك نشط الآن."),
    "subscriptionAllPlansBackToPlans": MessageLookupByLibrary.simpleMessage("العودة إلى الخطط"),
    "subscriptionAllPlansCompareAll": MessageLookupByLibrary.simpleMessage("قارن جميع الميزات"),
    "subscriptionAllPlansCurrentPlan": MessageLookupByLibrary.simpleMessage("الخطة الحالية"),
    "subscriptionAllPlansPurchase": MessageLookupByLibrary.simpleMessage("الحصول على الخطة"),
    "subscriptionAllPlansTabMonth": MessageLookupByLibrary.simpleMessage("شهريًا"),
    "subscriptionAllPlansTabYear": MessageLookupByLibrary.simpleMessage("سنة واحدة"),
    "subscriptionAllPlansTitle": MessageLookupByLibrary.simpleMessage("جميع الخطط"),
    "subscriptionAllPlansUpgrade": MessageLookupByLibrary.simpleMessage("ترقية خطتك"),
    "subscriptionCancelledTitle": MessageLookupByLibrary.simpleMessage("تم إلغاء الاشتراك"),
    "subscriptionOnboardingBoostProtectionDescription": MessageLookupByLibrary.simpleMessage(
      "استكشف ميزات متقدمة مثل بروتوكولات VPN وحظر البرامج الضارة.",
    ),
    "subscriptionOnboardingBoostProtectionTitle": MessageLookupByLibrary.simpleMessage(
      "عزّز حمايتك",
    ),
    "subscriptionOnboardingCancelTourLabel": MessageLookupByLibrary.simpleMessage("تخطٍّ الآن"),
    "subscriptionOnboardingConnectDescription": MessageLookupByLibrary.simpleMessage(
      "سنوصلك بأفضل خادم.",
    ),
    "subscriptionOnboardingConnectTitle": MessageLookupByLibrary.simpleMessage("اتصل لتبقى خاصًا"),
    "subscriptionOnboardingManagePlanDescription": MessageLookupByLibrary.simpleMessage(
      "اشترِ خططًا أو رقِّها أو اعرض الخطط المتاحة حسب صلاحيات حسابك.",
    ),
    "subscriptionOnboardingManagePlanTitle": MessageLookupByLibrary.simpleMessage("إدارة خطتك"),
    "subscriptionOnboardingMapDesktopDescription": MessageLookupByLibrary.simpleMessage(
      "تصفّح الخريطة أو استكشف المواقع من الشريط الجانبي.",
    ),
    "subscriptionOnboardingMapDesktopTitle": MessageLookupByLibrary.simpleMessage(
      "استكشف المواقع على طريقتك",
    ),
    "subscriptionOnboardingMapMobileDescription": MessageLookupByLibrary.simpleMessage(
      "تصفّح الخريطة لاختيار دولة والاتصال فورًا.",
    ),
    "subscriptionOnboardingMapMobileTitle": MessageLookupByLibrary.simpleMessage(
      "الاتصال من الخريطة",
    ),
    "subscriptionOnboardingPromptDescription": MessageLookupByLibrary.simpleMessage(
      "تعرّف على التطبيق المحدّث واكتشف أين توجد الميزات الرئيسية الآن.",
    ),
    "subscriptionOnboardingPromptTitle": MessageLookupByLibrary.simpleMessage("خذ جولة سريعة"),
    "subscriptionOnboardingSearchDescription": MessageLookupByLibrary.simpleMessage(
      "اعثر بسرعة على الدول والمدن والخوادم عبر البحث.",
    ),
    "subscriptionOnboardingSearchTitle": MessageLookupByLibrary.simpleMessage(
      "ابحث واتصل بشكل أسرع",
    ),
    "subscriptionOnboardingSetupCompleteDescription": MessageLookupByLibrary.simpleMessage(
      "اختر موقعًا لبدء تصفح أكثر خصوصية.",
    ),
    "subscriptionOnboardingSetupCompleteTitle": MessageLookupByLibrary.simpleMessage(
      "اكتمل الإعداد",
    ),
    "subscriptionOnboardingStartTourLabel": MessageLookupByLibrary.simpleMessage("بدء الجولة"),
    "subscriptionOnboardingVPNLocationsDesktopDescription": MessageLookupByLibrary.simpleMessage(
      "استكشف الدول والمدن في مكان واحد.",
    ),
    "subscriptionOnboardingVPNLocationsMobileDescription": MessageLookupByLibrary.simpleMessage(
      "استكشف الدول والمدن والاتصالات الأخيرة والخوادم المتخصصة في مكان واحد.",
    ),
    "subscriptionOnboardingVPNLocationsTitle": MessageLookupByLibrary.simpleMessage(
      "تصفّح مواقع VPN",
    ),
    "subscriptionPlanBestValue": MessageLookupByLibrary.simpleMessage("أفضل قيمة"),
    "subscriptionPlanCityLevel": MessageLookupByLibrary.simpleMessage("اختيارات على مستوى المدينة"),
    "subscriptionPlanCityLevelDesc": MessageLookupByLibrary.simpleMessage(
      "يوفّر تحكمًا أدق في الموقع من معظم شبكات VPN التي تقتصر عادةً على اختيار دول أو ولايات بأكملها.",
    ),
    "subscriptionPlanDevicesSecured": MessageLookupByLibrary.simpleMessage(
      "الأجهزة المؤمّنة في آنٍ واحد",
    ),
    "subscriptionPlanDoubleVPN": MessageLookupByLibrary.simpleMessage("VPN مزدوج"),
    "subscriptionPlanDoubleVPNDesc": MessageLookupByLibrary.simpleMessage(
      "طبقة أمان إضافية. يوجّه حركة الإنترنت عبر خادمَي VPN مختلفين، فيشفّر بياناتك مرتين ويُخفي عنوان IP خلف خادم ثانٍ",
    ),
    "subscriptionPlanMalwareBlocker": MessageLookupByLibrary.simpleMessage("مانع البرامج الضارة"),
    "subscriptionPlanMalwareBlockerDesc": MessageLookupByLibrary.simpleMessage(
      "يحمي جهازك بإيقاف التهديدات قبل وصولها إليه، ويعمل بهدوء في الخلفية دون مقاطعتك.",
    ),
    "subscriptionPlanMoneyBack": MessageLookupByLibrary.simpleMessage(
      "ضمان استرداد الأموال خلال 7 أيام",
    ),
    "subscriptionPlanNameBasic": MessageLookupByLibrary.simpleMessage("Basic"),
    "subscriptionPlanNamePlus": MessageLookupByLibrary.simpleMessage("Plus"),
    "subscriptionPlanNamePro": MessageLookupByLibrary.simpleMessage("Pro"),
    "subscriptionPlanPF1Basic": MessageLookupByLibrary.simpleMessage("تأمين 6 أجهزة في آنٍ واحد"),
    "subscriptionPlanPF1Plus": MessageLookupByLibrary.simpleMessage("تأمين 10 أجهزة في آنٍ واحد"),
    "subscriptionPlanPF2Basic": MessageLookupByLibrary.simpleMessage("57 دولة مدعومة"),
    "subscriptionPlanPF2Plus": MessageLookupByLibrary.simpleMessage("أكثر من 100 دولة مدعومة"),
    "subscriptionPlanPF3Basic": MessageLookupByLibrary.simpleMessage("10 خوادم"),
    "subscriptionPlanPF3Plus": MessageLookupByLibrary.simpleMessage("100 خادم"),
    "subscriptionPlanPF4Basic": MessageLookupByLibrary.simpleMessage("بروتوكول VPN"),
    "subscriptionPlanPF4Plus": MessageLookupByLibrary.simpleMessage("أكثر من 7,500 عنوان IP سكني"),
    "subscriptionPlanPF5Plus": MessageLookupByLibrary.simpleMessage("بروتوكول VPN"),
    "subscriptionPlanPF6Plus": MessageLookupByLibrary.simpleMessage("اختيارات على مستوى المدينة"),
    "subscriptionPlanResidentialIPs": MessageLookupByLibrary.simpleMessage("عناوين IP سكنية"),
    "subscriptionPlanResidentialIPsDesc": MessageLookupByLibrary.simpleMessage(
      "اظهر كمستخدم منزلي عادي، مما يتيح لك الوصول إلى خدمات البث وتجنّب اكتشاف VPN.",
    ),
    "subscriptionPlanSavePercent": m27,
    "subscriptionPlanSaveWith": m28,
    "subscriptionPlanServers": MessageLookupByLibrary.simpleMessage("الخوادم"),
    "subscriptionPlanSupportedCountries": MessageLookupByLibrary.simpleMessage("الدول المدعومة"),
    "subscriptionPlanWireGuard": MessageLookupByLibrary.simpleMessage("بروتوكول VPN"),
    "subscriptionPlanWireGuardDesc": MessageLookupByLibrary.simpleMessage(
      "WireGuard — بروتوكول سريع مثالي للألعاب والبث\nOpenVPN — بروتوكول عالي القابلية للتخصيص يعمل حيث تفشل البروتوكولات الأخرى (غير متاح على Android)",
    ),
    "subscriptionProcessCanceled": MessageLookupByLibrary.simpleMessage(
      "لم تُكمل التغييرات على اشتراكك.",
    ),
    "subscriptionResumed": MessageLookupByLibrary.simpleMessage("اشتراكك نشط مرة أخرى."),
    "subscriptionUpgrade": MessageLookupByLibrary.simpleMessage("ترقية"),
    "subscriptionUpgradeCTA": m29,
    "subscriptionUpgradeModalDescription": MessageLookupByLibrary.simpleMessage(
      "للوصول إلى أكثر من 7,500 عنوان IP سكني",
    ),
    "subscriptionUpgradeModalTitle": m30,
    "subscriptionUpgradeSeeAllPlans": MessageLookupByLibrary.simpleMessage("عرض جميع الخطط"),
    "subscriptionVerificationFailed": MessageLookupByLibrary.simpleMessage("إعادة محاولة التحقق"),
    "subscripton": MessageLookupByLibrary.simpleMessage("الاشتراك"),
    "switchToLocationBtn": m31,
    "system": MessageLookupByLibrary.simpleMessage("النظام"),
    "takeBackTheInternetLbl": MessageLookupByLibrary.simpleMessage("استعد الإنترنت."),
    "termsAndConditions": MessageLookupByLibrary.simpleMessage("الأحكام والشروط"),
    "title": MessageLookupByLibrary.simpleMessage("مرحبًا"),
    "toManyRequestsErrorMsg": MessageLookupByLibrary.simpleMessage(
      "طلبات كثيرة جدًا. يُرجى المحاولة لاحقًا.",
    ),
    "tokenAlreadyUsed": MessageLookupByLibrary.simpleMessage(
      "تم استخدام الرمز مسبقًا. يُرجى المحاولة مرة أخرى.\n",
    ),
    "tooManyConnectionsBannerCTADisconnect": MessageLookupByLibrary.simpleMessage("قطع الاتصال"),
    "tooManyConnectionsBannerCTAReconnect": MessageLookupByLibrary.simpleMessage("إعادة الاتصال"),
    "tooManyConnectionsBannerDesc": MessageLookupByLibrary.simpleMessage(
      "لقد بلغت الحد الأقصى وهو 6 أجهزة متصلة بحسابك. لمواصلة استخدام VPN، اضغط لإعادة الاتصال.",
    ),
    "tooManyConnectionsBannerDescConnected": MessageLookupByLibrary.simpleMessage(
      "لقد بلغت الحد الأقصى وهو 6 أجهزة متصلة بحسابك. لمواصلة استخدام VPN، اضغط قطع الاتصال وحاول مرة أخرى.",
    ),
    "tooManyConnectionsBannerTitle": MessageLookupByLibrary.simpleMessage("تم قطع اتصالك"),
    "topLocations": MessageLookupByLibrary.simpleMessage("أفضل المواقع"),
    "tr": MessageLookupByLibrary.simpleMessage("التركية"),
    "tryAgainBtn": MessageLookupByLibrary.simpleMessage("حاول مرة أخرى"),
    "tryAnotherLocation": MessageLookupByLibrary.simpleMessage("حاول البحث عن موقع آخر"),
    "tunnelPermissionRequired": MessageLookupByLibrary.simpleMessage("يجب منح الإذن لبدء نفق VPN."),
    "tunnelSetupError": MessageLookupByLibrary.simpleMessage("حدث خطأ أثناء إعداد النفق"),
    "typeDelete": m32,
    "typeFeedback": MessageLookupByLibrary.simpleMessage("اكتب ملاحظاتك هنا..."),
    "ukraine": MessageLookupByLibrary.simpleMessage("أوكرانيا"),
    "unableToConnectToPaymentProcesor": MessageLookupByLibrary.simpleMessage(
      "تعذّر الاتصال بمعالج الدفع! يُرجى المحاولة مرة أخرى.",
    ),
    "unauthenticatedBannerTitle": MessageLookupByLibrary.simpleMessage("لم تسجّل الدخول"),
    "unauthenticatedSettingSubtitle": MessageLookupByLibrary.simpleMessage(
      "سجّل الدخول للوصول إلى حسابك وفتح جميع الميزات",
    ),
    "unauthenticatedSettingTitle": MessageLookupByLibrary.simpleMessage("لم تسجّل الدخول"),
    "undo": MessageLookupByLibrary.simpleMessage("تراجع"),
    "unprotectedLbl": MessageLookupByLibrary.simpleMessage("غير محمي"),
    "unstableSpeedReason": MessageLookupByLibrary.simpleMessage("سرعة غير مستقرة"),
    "updateBtn": MessageLookupByLibrary.simpleMessage("تحديث"),
    "userIntentBestSpeed": MessageLookupByLibrary.simpleMessage("أفضل سرعة"),
    "userIntentBestSpeedDesc": MessageLookupByLibrary.simpleMessage(
      "اتصل بأسرع خادم متاح للحصول على أداء مثالي",
    ),
    "userIntentLabel": MessageLookupByLibrary.simpleMessage("خادم متخصص"),
    "userIntentLowLatency": MessageLookupByLibrary.simpleMessage("زمن استجابة منخفض"),
    "userIntentLowLatencyDesc": MessageLookupByLibrary.simpleMessage(
      "يتصل تلقائيًا بأقرب خادم لوصول مستقر وموثوق",
    ),
    "userIntentMaxPrivacy": MessageLookupByLibrary.simpleMessage("أقصى خصوصية"),
    "userIntentMaxPrivacyDesc": MessageLookupByLibrary.simpleMessage(
      "احصل على خادم بأفضل خيارات حرية التعبير والسرعة حسب الدولة",
    ),
    "userIntentNearestLocation": MessageLookupByLibrary.simpleMessage("أقرب موقع"),
    "userIntentNearestLocationDesc": MessageLookupByLibrary.simpleMessage(
      "يوصلك بأقرب عنوان IP VPN متاح لأفضل سرعة وأداء بناءً على موقعك الحالي",
    ),
    "userIntentP2P": MessageLookupByLibrary.simpleMessage("P2P"),
    "userIntentP2PDesc": MessageLookupByLibrary.simpleMessage(
      "اختر أفضل خادم للمعاملات المشفرة الآمنة ومشاركة الملفات واستضافة الألعاب والاتصالات",
    ),
    "userIntentStreaming": MessageLookupByLibrary.simpleMessage("Streaming"),
    "userIntentStreamingDesc": MessageLookupByLibrary.simpleMessage(
      "شاهد برامجك وأفلامك المفضلة من منصات مخصصة حسب المنطقة",
    ),
    "viewAllFeaturesBtn": MessageLookupByLibrary.simpleMessage("عرض جميع الميزات"),
    "viewLessBtn": MessageLookupByLibrary.simpleMessage("عرض أقل"),
    "vodafoneLbl": MessageLookupByLibrary.simpleMessage("Vodafone Iberia"),
    "vpnDetails": MessageLookupByLibrary.simpleMessage("تفاصيل VPN"),
    "vpnIp": MessageLookupByLibrary.simpleMessage("عنوان IP لشبكة VPN"),
    "vpnProtocolSettingLbl": MessageLookupByLibrary.simpleMessage("بروتوكول VPN"),
    "year": MessageLookupByLibrary.simpleMessage("سنة"),
    "yearly": MessageLookupByLibrary.simpleMessage("سنويًا"),
    "yes": MessageLookupByLibrary.simpleMessage("نعم"),
    "zh": MessageLookupByLibrary.simpleMessage("الصينية"),
  };
}
