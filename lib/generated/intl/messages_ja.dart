// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ja locale. All the
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
  String get localeName => 'ja';

  static String m0(store) => "${store} で支払い済みの有効なサブスクリプションがすでにあります。${store} で管理してください。";

  static String m1(amount, period) => "${amount} /${period}";

  static String m2(amount, period) => "${amount}/月 — ${period}請求";

  static String m3(couponCode) => "${couponCode} をクリップボードにコピーしました";

  static String m4(email) => "${email} にメールを送信しました";

  static String m5(email) => "「${email}」で有料サブスクリプションをすでにお持ちの可能性があります";

  static String m6(errorCode) => "接続に失敗しました。もう一度お試しください [エラー: ${errorCode}]";

  static String m7(plan) => "${plan} を入手";

  static String m8(plan) => "${plan} プランを入手";

  static String m9(location) => "${location} では代替の IP がありません。次回別の IP を取得するには、別の国または都市を選んでください。";

  static String m10(location) => "${location} では代替の IP がありません。次回別の IP を取得するには、別の国を選んでください。";

  static String m11(count) => "${Intl.plural(count, other: '${count} 都市')}";

  static String m12(count) => "${Intl.plural(count, other: '${count} IP')}";

  static String m13(count) => "${Intl.plural(count, other: '${count} 州')}";

  static String m14(location) => "${location} は利用できません";

  static String m15(location) => "${location} を更新できませんでした";

  static String m16(location) => "${location} を更新しました";

  static String m17(date) => "次回の請求: ${date}";

  static String m18(protocol, label) => "${protocol} (${label})";

  static String m19(location) => "${location} を更新";

  static String m20(count) => "${Intl.plural(count, other: '再送信 (${count})')}";

  static String m21(percent) => "${percent}% お得";

  static String m22(percent, planId) => "${planId} プランで ${percent}% お得";

  static String m23(plan) => "${plan} にアップグレード";

  static String m24(plan) => "${plan} プランにアップグレード";

  static String m25(location) => "${location} に切り替える";

  static String m26(word) => "${word} を入力";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "LoggingYouIn": MessageLookupByLibrary.simpleMessage("ログイン中…"),
    "accessBlockedSitesReason": MessageLookupByLibrary.simpleMessage("ブロックされたサイトにアクセスできません"),
    "account": MessageLookupByLibrary.simpleMessage("アカウント"),
    "accountSuccessfullyDeleted": MessageLookupByLibrary.simpleMessage("アカウントを削除しました"),
    "activeSubsPaidVia": m0,
    "allLocations": MessageLookupByLibrary.simpleMessage("すべてのロケーション"),
    "allowBtn": MessageLookupByLibrary.simpleMessage("許可"),
    "allowNotificationsBtn": MessageLookupByLibrary.simpleMessage("通知を許可"),
    "allowPushNotificationsBtn": MessageLookupByLibrary.simpleMessage("通知を許可"),
    "and": MessageLookupByLibrary.simpleMessage(" と "),
    "appUpdateAvailableDesc": MessageLookupByLibrary.simpleMessage(
      "新しいアプリバージョンが登場しました。最新の機能と改善のために今すぐアップデートしましょう。",
    ),
    "appUpdateAvailableSetting": MessageLookupByLibrary.simpleMessage("アプリのアップデートがあります"),
    "appUpdateAvailableTitle": MessageLookupByLibrary.simpleMessage("アプリのアップデートがあります"),
    "appearanceSettingLbl": MessageLookupByLibrary.simpleMessage("外観"),
    "ar": MessageLookupByLibrary.simpleMessage("アラビア語"),
    "austria": MessageLookupByLibrary.simpleMessage("オーストリア"),
    "authenticationFailed": MessageLookupByLibrary.simpleMessage("サインインできませんでした。もう一度お試しください。"),
    "back": MessageLookupByLibrary.simpleMessage("戻る"),
    "backToSettingsLbl": MessageLookupByLibrary.simpleMessage("設定に戻る"),
    "batterySaverLabel": MessageLookupByLibrary.simpleMessage("バッテリー節約"),
    "berlinLbl": MessageLookupByLibrary.simpleMessage("ベルリン（ドイツ） 🇩🇪"),
    "billedInTotal": m1,
    "billedPerMonth": m2,
    "blockerSettingLbl": MessageLookupByLibrary.simpleMessage("ブロッカー"),
    "buttonUpdateApp": MessageLookupByLibrary.simpleMessage("今すぐアップデート"),
    "bypassRestrictionsReason": MessageLookupByLibrary.simpleMessage("制限を回避"),
    "cancelBtn": MessageLookupByLibrary.simpleMessage("キャンセル"),
    "cancelDisconnects": MessageLookupByLibrary.simpleMessage("切断"),
    "cancelDowntimes": MessageLookupByLibrary.simpleMessage("ダウンタイム"),
    "cancelError7040": MessageLookupByLibrary.simpleMessage("エラー 7040"),
    "cancelLatency": MessageLookupByLibrary.simpleMessage("遅延"),
    "cancelMissingFeatures": MessageLookupByLibrary.simpleMessage("不足している機能"),
    "cancelSpeed": MessageLookupByLibrary.simpleMessage("速度"),
    "cancelSurveyFeedbackHint": MessageLookupByLibrary.simpleMessage("詳細を入力してください…"),
    "cancelSurveyTitle": MessageLookupByLibrary.simpleMessage("キャンセルの理由"),
    "cancelTooExpensive": MessageLookupByLibrary.simpleMessage("高すぎる"),
    "cancelUnableToAccessBlockedSites": MessageLookupByLibrary.simpleMessage("ブロックされたサイトにアクセスできない"),
    "cancelUsabilityIssues": MessageLookupByLibrary.simpleMessage("使いやすさの問題"),
    "cancelYourSubsMess": MessageLookupByLibrary.simpleMessage(
      "アカウントを削除する前に、App Store のサブスクリプションをキャンセルしてください。",
    ),
    "checkSubsStatusFailedDesc": MessageLookupByLibrary.simpleMessage("プラン情報を取得できませんでした。"),
    "checkSubsStatusFailedTitle": MessageLookupByLibrary.simpleMessage("プラン情報を取得できません"),
    "checkSubsStatusTitle": MessageLookupByLibrary.simpleMessage("プラン情報を取得中…"),
    "checkYourEmail": MessageLookupByLibrary.simpleMessage("メールをご確認ください"),
    "clearSearchBtn": MessageLookupByLibrary.simpleMessage("検索をクリア"),
    "closeBtn": MessageLookupByLibrary.simpleMessage("閉じる"),
    "communicationLbl": MessageLookupByLibrary.simpleMessage("お知らせ"),
    "communicationLblDesktop": MessageLookupByLibrary.simpleMessage("お知らせ"),
    "completeBtn": MessageLookupByLibrary.simpleMessage("完了"),
    "confirm": MessageLookupByLibrary.simpleMessage("確認"),
    "connect": MessageLookupByLibrary.simpleMessage("接続"),
    "connectBestServer": MessageLookupByLibrary.simpleMessage("最適なサーバー"),
    "connected": MessageLookupByLibrary.simpleMessage("接続済み"),
    "connecting": MessageLookupByLibrary.simpleMessage("接続中…"),
    "connectingToPaymentProcesor": MessageLookupByLibrary.simpleMessage("決済プロセッサに接続中…"),
    "connection": MessageLookupByLibrary.simpleMessage("接続"),
    "connectionSettingLbl": MessageLookupByLibrary.simpleMessage("接続と保護"),
    "connectionTimeout": MessageLookupByLibrary.simpleMessage(
      "接続がタイムアウトしました。後でもう一度お試しください。問題が続く場合はサポートチームにお問い合わせください",
    ),
    "consistentSpeedReason": MessageLookupByLibrary.simpleMessage("安定した速度"),
    "consumeLink": MessageLookupByLibrary.simpleMessage(
      "リクエストしたデバイスでのみ動作します。続行するには、メール内のリンクをクリックしてください。",
    ),
    "continueBtn": MessageLookupByLibrary.simpleMessage("続行"),
    "continueWithApple": MessageLookupByLibrary.simpleMessage("Apple で続行"),
    "continueWithEmail": MessageLookupByLibrary.simpleMessage("メールで続行"),
    "continueWithGoogle": MessageLookupByLibrary.simpleMessage("Google で続行"),
    "copyLink": MessageLookupByLibrary.simpleMessage("リンクをコピーしてブラウザに貼り付けてください"),
    "couponCodeCopied": m3,
    "dark": MessageLookupByLibrary.simpleMessage("ダーク"),
    "dataCentreComparisonCardItem1": MessageLookupByLibrary.simpleMessage("検出されやすい"),
    "dataCentreComparisonCardItem2": MessageLookupByLibrary.simpleMessage("サイトでブロックされがち"),
    "dataCentreComparisonCardItem3": MessageLookupByLibrary.simpleMessage("プライバシーが低い"),
    "dataCentreComparisonCardLbl": MessageLookupByLibrary.simpleMessage("データセンター IP"),
    "dataCentreComparisonCardTitle": MessageLookupByLibrary.simpleMessage("多くの VPN"),
    "de": MessageLookupByLibrary.simpleMessage("ドイツ語"),
    "deleteAccount": MessageLookupByLibrary.simpleMessage("アカウントを削除"),
    "deleteAccountQuestion": MessageLookupByLibrary.simpleMessage("アカウントを削除しますか？"),
    "deleteBtn": MessageLookupByLibrary.simpleMessage("削除"),
    "deviceLimitReachedDesc": MessageLookupByLibrary.simpleMessage(
      "接続できるデバイスの上限に達しました。新しいデバイスを追加するには、アカウントから既存のデバイスを削除してください。",
    ),
    "deviceLimitReachedOpenDashboard": MessageLookupByLibrary.simpleMessage("ダッシュボードを開く"),
    "deviceLimitReachedTitle": MessageLookupByLibrary.simpleMessage("デバイスの上限に達しました"),
    "disconnect": MessageLookupByLibrary.simpleMessage("切断"),
    "disconnected": MessageLookupByLibrary.simpleMessage("切断済み"),
    "disconnecting": MessageLookupByLibrary.simpleMessage("切断中…"),
    "discountedPriceLabel": MessageLookupByLibrary.simpleMessage("特価"),
    "dns": MessageLookupByLibrary.simpleMessage("DNS 保護"),
    "dnsDesc": MessageLookupByLibrary.simpleMessage("DNS リークを防止します"),
    "duration": MessageLookupByLibrary.simpleMessage("期間"),
    "email": MessageLookupByLibrary.simpleMessage("メールアドレス"),
    "emailIsNotValid": MessageLookupByLibrary.simpleMessage("メールアドレスが無効です"),
    "emailIsRequired": MessageLookupByLibrary.simpleMessage("メールアドレスは必須です"),
    "emailNotificationsSetting": MessageLookupByLibrary.simpleMessage("メール通知"),
    "emailSentTo": m4,
    "en": MessageLookupByLibrary.simpleMessage("英語"),
    "es": MessageLookupByLibrary.simpleMessage("スペイン語"),
    "existingSubscriptionDesc": m5,
    "existingSubscriptionTitle": MessageLookupByLibrary.simpleMessage("ログアウトしてメールで試すか、この警告を無視できます"),
    "failedToConnectError": m6,
    "failedToSubmitFeedback": MessageLookupByLibrary.simpleMessage(
      "フィードバックの送信に失敗しました。もう一度お試しください。",
    ),
    "failedToSubscribe": MessageLookupByLibrary.simpleMessage("サブスクリプションで問題が発生しました。もう一度お試しください。"),
    "failedToVerifySubs": MessageLookupByLibrary.simpleMessage(
      "前回のサブスクリプション購入を確認できませんでした。下のボタンを押して再試行してください。",
    ),
    "fastLabel": MessageLookupByLibrary.simpleMessage("高速"),
    "featureToggleMinVersionNotSatisfied": MessageLookupByLibrary.simpleMessage(
      "アプリのバージョンが古くなっています。引き続き使用するにはアプリをアップデートしてください。",
    ),
    "formValidationError": MessageLookupByLibrary.simpleMessage(
      "フォームのデータが無効です。項目を確認してもう一度お試しください。",
    ),
    "fr": MessageLookupByLibrary.simpleMessage("フランス語"),
    "france": MessageLookupByLibrary.simpleMessage("フランス"),
    "frequentDisconnectsReason": MessageLookupByLibrary.simpleMessage("頻繁な切断"),
    "fullPriceLabel": MessageLookupByLibrary.simpleMessage("通常価格:"),
    "germany": MessageLookupByLibrary.simpleMessage("ドイツ"),
    "getNewIPAddress": MessageLookupByLibrary.simpleMessage("更新時に新しい IP アドレスを取得"),
    "getSubscriptionModalDesc": MessageLookupByLibrary.simpleMessage(
      "接続を保護し、すぐにプライベートな閲覧をお楽しみください",
    ),
    "getSubscriptionModalTitle": m7,
    "getSubscriptionPlanBtn": m8,
    "gettingIPAddress": MessageLookupByLibrary.simpleMessage("IP アドレスを取得中…"),
    "goBackButton": MessageLookupByLibrary.simpleMessage("戻る"),
    "goToLoginBtn": MessageLookupByLibrary.simpleMessage("ログインへ"),
    "helpSupportLbl": MessageLookupByLibrary.simpleMessage("ヘルプとサポート"),
    "hi": MessageLookupByLibrary.simpleMessage("ヒンディー語"),
    "hiddenLbl": MessageLookupByLibrary.simpleMessage("非表示"),
    "highLatencyReason": MessageLookupByLibrary.simpleMessage("高遅延"),
    "highSpeed": MessageLookupByLibrary.simpleMessage("データセンター"),
    "homeLbl": MessageLookupByLibrary.simpleMessage("ホーム"),
    "id": MessageLookupByLibrary.simpleMessage("インドネシア語"),
    "incorrectLocationReason": MessageLookupByLibrary.simpleMessage("ロケーションが正しくない"),
    "incorrectMagicLink": MessageLookupByLibrary.simpleMessage("マジックリンクが正しくありません。もう一度お試しください。"),
    "ipAddressLbl": MessageLookupByLibrary.simpleMessage("IP アドレス"),
    "ipRefreshExhaustedCity": m9,
    "ipRefreshExhaustedCountry": m10,
    "ipTypeDataCenter": MessageLookupByLibrary.simpleMessage("データセンター IP"),
    "ipTypeDataCenterDisclaimer": MessageLookupByLibrary.simpleMessage(
      "速度とパフォーマンスに最適化されたデータセンター IP。",
    ),
    "ipTypeResidential": MessageLookupByLibrary.simpleMessage("レジデンシャル IP"),
    "ipTypeResidentialDisclaimer": MessageLookupByLibrary.simpleMessage(
      "実際の家庭から提供。ほぼ検出不可能ですが安定性は低めです。",
    ),
    "ipTypeResidentialTooltipBody": MessageLookupByLibrary.simpleMessage(
      "レジデンシャル IP は実際の家庭用デバイスから提供されるため、利用可否は時間とともに変わることがあります。\n\nノードがオフラインになると、アプリは最寄りの利用可能な レジデンシャル IP に再接続します。",
    ),
    "ipTypeResidentialTooltipTitle": MessageLookupByLibrary.simpleMessage("IP はなぜ変わるのですか？"),
    "it": MessageLookupByLibrary.simpleMessage("イタリア語"),
    "italy": MessageLookupByLibrary.simpleMessage("イタリア"),
    "ja": MessageLookupByLibrary.simpleMessage("日本語"),
    "killSwitch": MessageLookupByLibrary.simpleMessage("Kill switch"),
    "killSwitchDesc": MessageLookupByLibrary.simpleMessage("VPN 接続が切断されるとインターネット通信を遮断します"),
    "languageSettingLbl": MessageLookupByLibrary.simpleMessage("言語"),
    "light": MessageLookupByLibrary.simpleMessage("ライト"),
    "linkCopied": MessageLookupByLibrary.simpleMessage("リンクをクリップボードにコピーしました"),
    "linkExpires": MessageLookupByLibrary.simpleMessage("このリンクは 30 分で期限切れになり、1 回だけ使用できます。"),
    "location": MessageLookupByLibrary.simpleMessage("ロケーション"),
    "locationItemCityCount": m11,
    "locationItemNodeCount": m12,
    "locationItemStatesCount": m13,
    "locationLbl": MessageLookupByLibrary.simpleMessage("ロケーション"),
    "locationUnavailableAction": MessageLookupByLibrary.simpleMessage("最寄りの IP に接続"),
    "locationUnavailableSubtitle": MessageLookupByLibrary.simpleMessage(
      "最寄りの IP に接続するか、手動で選択してください",
    ),
    "locationUnavailableTitle": m14,
    "locationsUpdateFailed": m15,
    "locationsUpdated": m16,
    "loginSessionExpired": MessageLookupByLibrary.simpleMessage("セッションの有効期限が切れました。もう一度ログインしてください。"),
    "loginSignupLabel": MessageLookupByLibrary.simpleMessage("ログインまたは新規登録"),
    "logout": MessageLookupByLibrary.simpleMessage("ログアウト"),
    "logoutConfirmationDesc": MessageLookupByLibrary.simpleMessage("ログアウトしようとしています。よろしいですか？"),
    "logoutConfirmationTitle": MessageLookupByLibrary.simpleMessage("ログアウト"),
    "logoutVPNConnectedDesc": MessageLookupByLibrary.simpleMessage(
      "VPN はオンです。ログアウトを続けると VPN サーバーから切断されます。",
    ),
    "lowLatencyReason": MessageLookupByLibrary.simpleMessage("低遅延"),
    "madridLbl": MessageLookupByLibrary.simpleMessage("マドリード（スペイン） 🇪🇸"),
    "malwareLbl": MessageLookupByLibrary.simpleMessage("マルウェア"),
    "manageOnWebBtn": MessageLookupByLibrary.simpleMessage("ウェブで管理"),
    "marketingConsentPopupDesc": MessageLookupByLibrary.simpleMessage(
      "Mysterium Network からのメール更新、プライバシーのヒント、特別オファーを受け取りますか？",
    ),
    "marketingConsentPopupTitle": MessageLookupByLibrary.simpleMessage("メールで最新情報を受け取る"),
    "month": MessageLookupByLibrary.simpleMessage("月"),
    "monthly": MessageLookupByLibrary.simpleMessage("毎月"),
    "navLocations": MessageLookupByLibrary.simpleMessage("ロケーション"),
    "navMap": MessageLookupByLibrary.simpleMessage("地図"),
    "navProducts": MessageLookupByLibrary.simpleMessage("製品"),
    "nextBilling": m17,
    "no": MessageLookupByLibrary.simpleMessage("いいえ"),
    "noActiveSubsDesc": MessageLookupByLibrary.simpleMessage("有効なサブスクリプションがありません"),
    "noEmailApp": MessageLookupByLibrary.simpleMessage("デバイスにメールアプリがありません。"),
    "noLocationsFound": MessageLookupByLibrary.simpleMessage("ロケーションが見つかりません"),
    "noServersAvailable": MessageLookupByLibrary.simpleMessage("利用可能なサーバーがありません"),
    "noServersAvailableSub": MessageLookupByLibrary.simpleMessage(
      "接続に問題が発生しており、利用可能なサーバーがありません。後でお試しください。",
    ),
    "noSubscriptionAction": MessageLookupByLibrary.simpleMessage("プランを入手"),
    "noSubscriptionTitle": MessageLookupByLibrary.simpleMessage("有効なプランがありません"),
    "noneLbl": MessageLookupByLibrary.simpleMessage("なし"),
    "notAvailableMsg": MessageLookupByLibrary.simpleMessage("利用できません"),
    "notNowBtn": MessageLookupByLibrary.simpleMessage("今はしない"),
    "nsfwLbl": MessageLookupByLibrary.simpleMessage("NSFW とマルウェア"),
    "onboardingStep1Desc": MessageLookupByLibrary.simpleMessage(
      "あなたの IP と位置情報は、ウェブサイト、トラッカー、公共 Wi-Fi ネットワークから見えています。",
    ),
    "onboardingStep1Title": MessageLookupByLibrary.simpleMessage("あなたの接続は露出しています"),
    "onboardingStep2Desc": MessageLookupByLibrary.simpleMessage(
      "Mysterium VPN は IP、ISP、位置情報を隠し、本当のプライバシーで閲覧できるようにします。",
    ),
    "onboardingStep2Title": MessageLookupByLibrary.simpleMessage("ワンタップで本当の身元を隠す"),
    "onboardingStep3Desc": MessageLookupByLibrary.simpleMessage(
      "レジデンシャル IP なら、接続が自然に見え、一般的な VPN トラフィックのようには見えません。",
    ),
    "onboardingStep3Title": MessageLookupByLibrary.simpleMessage("すべての VPN が同じではありません"),
    "openEmailApp": MessageLookupByLibrary.simpleMessage("メールアプリを開く"),
    "openSystemSettingsBtn": MessageLookupByLibrary.simpleMessage("システム設定を開く"),
    "or": MessageLookupByLibrary.simpleMessage("または"),
    "orSelectCountryManually": MessageLookupByLibrary.simpleMessage(
      "最適なサーバーに接続します。または国を手動で選択できます。",
    ),
    "otherReason": MessageLookupByLibrary.simpleMessage("その他…"),
    "pendingTransactionMessage": MessageLookupByLibrary.simpleMessage(
      "進行中の決済がすでにあります。新しい決済を開始する前に完了してください。",
    ),
    "perMonth": MessageLookupByLibrary.simpleMessage("月"),
    "pl": MessageLookupByLibrary.simpleMessage("ポーランド語"),
    "planAlreadyPurchasedMsg": MessageLookupByLibrary.simpleMessage("準備完了です。このプランはすでに有効になっています。"),
    "plan_2_years": MessageLookupByLibrary.simpleMessage("2 年プラン"),
    "plan_2_years_basic": MessageLookupByLibrary.simpleMessage("Basic 2 年"),
    "plan_2_years_pro": MessageLookupByLibrary.simpleMessage("Pro 2 年"),
    "plan_6_months": MessageLookupByLibrary.simpleMessage("6 か月プラン"),
    "plan_monthly": MessageLookupByLibrary.simpleMessage("月額プラン"),
    "plan_monthly_basic": MessageLookupByLibrary.simpleMessage("Basic 月額"),
    "plan_monthly_plus": MessageLookupByLibrary.simpleMessage("Plus 月額"),
    "plan_monthly_pro": MessageLookupByLibrary.simpleMessage("Pro 月額"),
    "plan_yearly": MessageLookupByLibrary.simpleMessage("年間プラン"),
    "plan_yearly_basic": MessageLookupByLibrary.simpleMessage("Basic 年間"),
    "plan_yearly_plus": MessageLookupByLibrary.simpleMessage("Plus 年間"),
    "plan_yearly_pro": MessageLookupByLibrary.simpleMessage("Pro 年間"),
    "poland": MessageLookupByLibrary.simpleMessage("ポーランド"),
    "preferences": MessageLookupByLibrary.simpleMessage("環境設定"),
    "pricingPlanSeePlansBtn": MessageLookupByLibrary.simpleMessage("すべてのプランを見る"),
    "privacyPolicy": MessageLookupByLibrary.simpleMessage("プライバシーポリシー"),
    "processingPayment": MessageLookupByLibrary.simpleMessage("お支払いを処理中です。まもなく完了します…"),
    "productsActivePlanWebSyncAlert": MessageLookupByLibrary.simpleMessage(
      "すでに有効なプランがあります。ウェブでアップグレードしてください。変更は自動的に同期されます",
    ),
    "productsAllPlansLbl": MessageLookupByLibrary.simpleMessage("すべてのプラン:"),
    "productsBasicDescription": MessageLookupByLibrary.simpleMessage("日常のプライバシーに必要な機能"),
    "productsDuration1Month": MessageLookupByLibrary.simpleMessage("1 か月"),
    "productsDuration1Year": MessageLookupByLibrary.simpleMessage("1 年"),
    "productsDuration2Year": MessageLookupByLibrary.simpleMessage("2 年"),
    "productsExploreSubtitle": MessageLookupByLibrary.simpleMessage("プランと機能を見る"),
    "productsManageSubtitle": MessageLookupByLibrary.simpleMessage("ウェブで管理・アップグレード"),
    "productsMaxPlanAlert": MessageLookupByLibrary.simpleMessage("すでに利用可能な最上位プランをご利用中です。"),
    "productsNotAvailable": MessageLookupByLibrary.simpleMessage("現在利用できる製品がありません。後でもう一度お試しください。"),
    "productsPlusDescription": MessageLookupByLibrary.simpleMessage("より多くのデバイスとロケーション"),
    "productsProDescription": MessageLookupByLibrary.simpleMessage("ヘビーユーザー向けの最大限の保護"),
    "productsSubscribeWebAlert": MessageLookupByLibrary.simpleMessage(
      "サブスクリプションはウェブで管理します。プランはアプリに自動的に同期されます。",
    ),
    "productsSubscribeWebSubtitle": MessageLookupByLibrary.simpleMessage("ウェブで登録"),
    "productsTitle": MessageLookupByLibrary.simpleMessage("VPN 製品"),
    "protectedLbl": MessageLookupByLibrary.simpleMessage("保護中"),
    "protocol": MessageLookupByLibrary.simpleMessage("プロトコル"),
    "protocolLabel": m18,
    "protocolPickerSettingDesc": MessageLookupByLibrary.simpleMessage(
      "VPN プロトコルを切り替えると接続が切断されます。その後、再接続が必要です。",
    ),
    "protocolPickerSettingTitle": MessageLookupByLibrary.simpleMessage("VPN プロトコルの切り替え"),
    "pt": MessageLookupByLibrary.simpleMessage("ポルトガル語"),
    "ptBR": MessageLookupByLibrary.simpleMessage("ブラジルポルトガル語"),
    "pushNotificationsConsentPopupDesc": MessageLookupByLibrary.simpleMessage(
      "新機能、役立つヒント、限定オファーなど、便利な最新情報をお届けします。",
    ),
    "pushNotificationsConsentPopupTitle": MessageLookupByLibrary.simpleMessage("プッシュ通知で最新情報を受け取る"),
    "pushNotificationsSetting": MessageLookupByLibrary.simpleMessage("プッシュ通知"),
    "pushNotificationsSettingDesc": MessageLookupByLibrary.simpleMessage("製品の最新情報、ヒント、特別オファー"),
    "qaToolboxLbl": MessageLookupByLibrary.simpleMessage("QA Toolbox"),
    "rateConnection": MessageLookupByLibrary.simpleMessage("接続の調子はいかがですか？"),
    "rateConnectionDislike": MessageLookupByLibrary.simpleMessage("どこが気に入りませんでしたか？"),
    "rateConnectionLike": MessageLookupByLibrary.simpleMessage("どこが良かったですか？"),
    "recentLocations": MessageLookupByLibrary.simpleMessage("最近のロケーション"),
    "redeemDiscountCode": MessageLookupByLibrary.simpleMessage("割引コードを利用"),
    "redirectToLoginPage": MessageLookupByLibrary.simpleMessage(
      "アカウントを正常に削除しました。ログイン画面にリダイレクトされます。",
    ),
    "refresh": MessageLookupByLibrary.simpleMessage("更新"),
    "refreshIP": MessageLookupByLibrary.simpleMessage("IP を更新"),
    "refreshIPAddress": MessageLookupByLibrary.simpleMessage("IP アドレスを更新"),
    "refreshLocationsTooltip": m19,
    "resetAppDesc": MessageLookupByLibrary.simpleMessage("うまく動作しないときにリセット"),
    "resetAppDialogContent": MessageLookupByLibrary.simpleMessage(
      "アプリのリセットを続行すると、Mysterium VPN から切断されます。",
    ),
    "resetAppDialogTitle": MessageLookupByLibrary.simpleMessage("現在 VPN 接続がアクティブです"),
    "resetAppFailed": MessageLookupByLibrary.simpleMessage("アプリのリセットに失敗しました。もう一度お試しください。"),
    "resetAppSuccess": MessageLookupByLibrary.simpleMessage("アプリを正常にリセットしました。"),
    "resetAppTitle": MessageLookupByLibrary.simpleMessage("アプリをリセット"),
    "resetBtn": MessageLookupByLibrary.simpleMessage("リセット"),
    "residential": MessageLookupByLibrary.simpleMessage("レジデンシャル"),
    "residentialCentreComparisonCardItem1": MessageLookupByLibrary.simpleMessage("本物のユーザーに見える"),
    "residentialCentreComparisonCardItem2": MessageLookupByLibrary.simpleMessage("検出されにくい"),
    "residentialCentreComparisonCardItem3": MessageLookupByLibrary.simpleMessage("ブロックが少ない"),
    "residentialCentreComparisonCardLbl": MessageLookupByLibrary.simpleMessage("レジデンシャル IP"),
    "residentialEducationBlock1Body": MessageLookupByLibrary.simpleMessage(
      "レジデンシャル IP は実際の家庭用デバイスから提供されるため、トラフィックが通常のインターネット利用のように見えます。",
    ),
    "residentialEducationBlock1Title": MessageLookupByLibrary.simpleMessage("実際の家庭用デバイス"),
    "residentialEducationBlock2Body": MessageLookupByLibrary.simpleMessage(
      "これらの IP は実際のデバイスから提供されるため、一部のノードは時々オフラインになることがあります。",
    ),
    "residentialEducationBlock2Title": MessageLookupByLibrary.simpleMessage("利用可否は変わることがあります"),
    "residentialEducationBlock3Body": MessageLookupByLibrary.simpleMessage(
      "現在の IP が利用できなくなると、アプリは最寄りの利用可能な レジデンシャル IP に再接続します。",
    ),
    "residentialEducationBlock3Title": MessageLookupByLibrary.simpleMessage("自動再接続"),
    "residentialEducationGotIt": MessageLookupByLibrary.simpleMessage("わかりました"),
    "residentialEducationSubtitle": MessageLookupByLibrary.simpleMessage(
      "レジデンシャル IP はデータセンター IP とは異なります。知っておきたいポイントをご紹介します。",
    ),
    "residentialEducationTitle": MessageLookupByLibrary.simpleMessage("レジデンシャル IP の仕組み"),
    "retryBtn": MessageLookupByLibrary.simpleMessage("再試行"),
    "reviewLeaveReviewBtn": MessageLookupByLibrary.simpleMessage("レビューを書く"),
    "reviewPositiveTitle": MessageLookupByLibrary.simpleMessage("素晴らしいですね。よろしければレビューを書いていただけますか？"),
    "reviewSatisfactionTitle": MessageLookupByLibrary.simpleMessage("このアプリを他の人に勧めますか？"),
    "searchForLocations": MessageLookupByLibrary.simpleMessage("ロケーションを検索"),
    "seePlansBtn": MessageLookupByLibrary.simpleMessage("プランを見る"),
    "selectEmailApp": MessageLookupByLibrary.simpleMessage("続行するにはメールアプリを選択"),
    "semiAnnual": MessageLookupByLibrary.simpleMessage("半年ごと"),
    "sendAgain": m20,
    "serviceUnavailableError": MessageLookupByLibrary.simpleMessage(
      "一時的なネットワークの問題が発生しています。後でもう一度お試しください。",
    ),
    "settingManageBtn": MessageLookupByLibrary.simpleMessage("管理"),
    "settings": MessageLookupByLibrary.simpleMessage("設定"),
    "setupTunnerPermissionsDialogDesc": MessageLookupByLibrary.simpleMessage(
      "Mysterium VPN を使用するには、VPN プロファイルのインストール許可が必要です。",
    ),
    "setupTunnerPermissionsDialogDisclaimer": MessageLookupByLibrary.simpleMessage(
      "あなたの匿名性は保護されています。閲覧アクティビティを閲覧、収集、保存することはありません。",
    ),
    "setupTunnerPermissionsDialogTitle": MessageLookupByLibrary.simpleMessage("許可が必要です"),
    "signIn": MessageLookupByLibrary.simpleMessage("Mysterium VPN にサインイン"),
    "signInAbortedMsg": MessageLookupByLibrary.simpleMessage("サインインが中断されました"),
    "signInBtn": MessageLookupByLibrary.simpleMessage("サインイン"),
    "signInDisclaimer": MessageLookupByLibrary.simpleMessage(
      "Mysterium VPN はあなたのオンラインアクティビティを記録せず、あなた、デバイス、IP アドレス、メールに紐づく記録も残しません。サインインすると、以下に同意したものとみなされます",
    ),
    "sixMonths": MessageLookupByLibrary.simpleMessage("6 か月"),
    "skipBtn": MessageLookupByLibrary.simpleMessage("スキップ"),
    "somethingWentWrong": MessageLookupByLibrary.simpleMessage("問題が発生しました。もう一度お試しください。"),
    "stableConnectionReason": MessageLookupByLibrary.simpleMessage("安定した接続"),
    "status": MessageLookupByLibrary.simpleMessage("ステータス"),
    "stayButton": MessageLookupByLibrary.simpleMessage("残る"),
    "submitBtn": MessageLookupByLibrary.simpleMessage("送信"),
    "subscribeOnWebBtn": MessageLookupByLibrary.simpleMessage("ウェブで登録"),
    "subscriptionActive": MessageLookupByLibrary.simpleMessage("朗報です。サブスクリプションが有効になりました。"),
    "subscriptionAllPlansBackToPlans": MessageLookupByLibrary.simpleMessage("プランに戻る"),
    "subscriptionAllPlansCompareAll": MessageLookupByLibrary.simpleMessage("すべての機能を比較"),
    "subscriptionAllPlansCurrentPlan": MessageLookupByLibrary.simpleMessage("現在のプラン"),
    "subscriptionAllPlansPurchase": MessageLookupByLibrary.simpleMessage("プランを入手"),
    "subscriptionAllPlansTabMonth": MessageLookupByLibrary.simpleMessage("月額"),
    "subscriptionAllPlansTabYear": MessageLookupByLibrary.simpleMessage("1 年"),
    "subscriptionAllPlansTitle": MessageLookupByLibrary.simpleMessage("すべてのプラン"),
    "subscriptionAllPlansUpgrade": MessageLookupByLibrary.simpleMessage("プランをアップグレード"),
    "subscriptionOnboardingBoostProtectionDescription": MessageLookupByLibrary.simpleMessage(
      "VPN プロトコルやマルウェアブロックなどの高度な機能を活用しましょう。",
    ),
    "subscriptionOnboardingBoostProtectionTitle": MessageLookupByLibrary.simpleMessage("保護を強化"),
    "subscriptionOnboardingCancelTourLabel": MessageLookupByLibrary.simpleMessage("今はスキップ"),
    "subscriptionOnboardingConnectDescription": MessageLookupByLibrary.simpleMessage(
      "最適なサーバーに接続します。",
    ),
    "subscriptionOnboardingConnectTitle": MessageLookupByLibrary.simpleMessage("接続してプライバシーを守る"),
    "subscriptionOnboardingManagePlanDescription": MessageLookupByLibrary.simpleMessage(
      "アカウントのアクセス権に応じて、プランの購入、アップグレード、確認ができます。",
    ),
    "subscriptionOnboardingManagePlanTitle": MessageLookupByLibrary.simpleMessage("プランを管理"),
    "subscriptionOnboardingMapDesktopDescription": MessageLookupByLibrary.simpleMessage(
      "地図を見るか、サイドバーからロケーションを探索できます。",
    ),
    "subscriptionOnboardingMapDesktopTitle": MessageLookupByLibrary.simpleMessage(
      "好きな方法でロケーションを探索",
    ),
    "subscriptionOnboardingMapMobileDescription": MessageLookupByLibrary.simpleMessage(
      "地図を見て国を選び、すぐに接続できます。",
    ),
    "subscriptionOnboardingMapMobileTitle": MessageLookupByLibrary.simpleMessage("地図から接続"),
    "subscriptionOnboardingPromptDescription": MessageLookupByLibrary.simpleMessage(
      "アップデートされたアプリの使い方を覚え、主要な機能の場所を確認しましょう。",
    ),
    "subscriptionOnboardingPromptTitle": MessageLookupByLibrary.simpleMessage("簡単なツアーをどうぞ"),
    "subscriptionOnboardingSearchDescription": MessageLookupByLibrary.simpleMessage(
      "検索で国、都市、サーバーをすばやく見つけられます。",
    ),
    "subscriptionOnboardingSearchTitle": MessageLookupByLibrary.simpleMessage("検索でより速く接続"),
    "subscriptionOnboardingSetupCompleteDescription": MessageLookupByLibrary.simpleMessage(
      "ロケーションを選んで、よりプライベートな閲覧を始めましょう。",
    ),
    "subscriptionOnboardingSetupCompleteTitle": MessageLookupByLibrary.simpleMessage("セットアップ完了"),
    "subscriptionOnboardingStartTourLabel": MessageLookupByLibrary.simpleMessage("ツアーを開始"),
    "subscriptionOnboardingVPNLocationsDesktopDescription": MessageLookupByLibrary.simpleMessage(
      "国と都市を一か所で探索できます。",
    ),
    "subscriptionOnboardingVPNLocationsMobileDescription": MessageLookupByLibrary.simpleMessage(
      "国、都市、最近の接続、専用サーバーを一か所で探索できます。",
    ),
    "subscriptionOnboardingVPNLocationsTitle": MessageLookupByLibrary.simpleMessage(
      "VPN ロケーションを見る",
    ),
    "subscriptionPlanBestValue": MessageLookupByLibrary.simpleMessage("一番お得"),
    "subscriptionPlanCityLevel": MessageLookupByLibrary.simpleMessage("都市単位で選択"),
    "subscriptionPlanCityLevelDesc": MessageLookupByLibrary.simpleMessage(
      "ほとんどの VPN より精密なロケーション制御が可能です。一般的な VPN では国や州単位でしか選べません。",
    ),
    "subscriptionPlanDevicesSecured": MessageLookupByLibrary.simpleMessage("同時に保護できるデバイス数"),
    "subscriptionPlanDoubleVPN": MessageLookupByLibrary.simpleMessage("ダブル VPN"),
    "subscriptionPlanDoubleVPNDesc": MessageLookupByLibrary.simpleMessage(
      "セキュリティをさらに強化。インターネットトラフィックを 2 つの異なる VPN サーバー経由でルーティングし、データを二重に暗号化し、IP アドレスを 2 つ目のサーバーの背後に隠します",
    ),
    "subscriptionPlanMalwareBlocker": MessageLookupByLibrary.simpleMessage("マルウェアブロッカー"),
    "subscriptionPlanMalwareBlockerDesc": MessageLookupByLibrary.simpleMessage(
      "脅威がデバイスに届く前に阻止して保護します。バックグラウンドで静かに動作し、操作を妨げません。",
    ),
    "subscriptionPlanMoneyBack": MessageLookupByLibrary.simpleMessage("7 日間返金保証"),
    "subscriptionPlanNameBasic": MessageLookupByLibrary.simpleMessage("Basic"),
    "subscriptionPlanNamePlus": MessageLookupByLibrary.simpleMessage("Plus"),
    "subscriptionPlanNamePro": MessageLookupByLibrary.simpleMessage("Pro"),
    "subscriptionPlanPF1Basic": MessageLookupByLibrary.simpleMessage("同時に 6 台のデバイスを保護"),
    "subscriptionPlanPF1Plus": MessageLookupByLibrary.simpleMessage("同時に 10 台のデバイスを保護"),
    "subscriptionPlanPF2Basic": MessageLookupByLibrary.simpleMessage("57 か国に対応"),
    "subscriptionPlanPF2Plus": MessageLookupByLibrary.simpleMessage("100 か国以上に対応"),
    "subscriptionPlanPF3Basic": MessageLookupByLibrary.simpleMessage("10 サーバー"),
    "subscriptionPlanPF3Plus": MessageLookupByLibrary.simpleMessage("100 サーバー"),
    "subscriptionPlanPF4Basic": MessageLookupByLibrary.simpleMessage("VPN プロトコル"),
    "subscriptionPlanPF4Plus": MessageLookupByLibrary.simpleMessage("7,500 以上の レジデンシャル IP"),
    "subscriptionPlanPF5Plus": MessageLookupByLibrary.simpleMessage("VPN プロトコル"),
    "subscriptionPlanPF6Plus": MessageLookupByLibrary.simpleMessage("都市単位で選択"),
    "subscriptionPlanResidentialIPs": MessageLookupByLibrary.simpleMessage("レジデンシャル IP"),
    "subscriptionPlanResidentialIPsDesc": MessageLookupByLibrary.simpleMessage(
      "通常の家庭ユーザーのように見せることで、ストリーミングサービスにアクセスでき、VPN の検出を回避できます。",
    ),
    "subscriptionPlanSavePercent": m21,
    "subscriptionPlanSaveWith": m22,
    "subscriptionPlanServers": MessageLookupByLibrary.simpleMessage("サーバー"),
    "subscriptionPlanSupportedCountries": MessageLookupByLibrary.simpleMessage("対応国"),
    "subscriptionPlanWireGuard": MessageLookupByLibrary.simpleMessage("VPN プロトコル"),
    "subscriptionPlanWireGuardDesc": MessageLookupByLibrary.simpleMessage(
      "WireGuard - ゲームやストリーミングに最適な高速プロトコル\nOpenVPN - 他のプロトコルが機能しない環境でも動作する高度な設定が可能なプロトコル（Android では利用不可）",
    ),
    "subscriptionProcessCanceled": MessageLookupByLibrary.simpleMessage("サブスクリプションの変更が完了していません。"),
    "subscriptionUpgrade": MessageLookupByLibrary.simpleMessage("アップグレード"),
    "subscriptionUpgradeCTA": m23,
    "subscriptionUpgradeModalDescription": MessageLookupByLibrary.simpleMessage(
      "7,500 以上の レジデンシャル IP にアクセス",
    ),
    "subscriptionUpgradeModalTitle": m24,
    "subscriptionUpgradeSeeAllPlans": MessageLookupByLibrary.simpleMessage("すべてのプランを見る"),
    "subscriptionVerificationFailed": MessageLookupByLibrary.simpleMessage("確認を再試行"),
    "subscripton": MessageLookupByLibrary.simpleMessage("サブスクリプション"),
    "switchToLocationBtn": m25,
    "system": MessageLookupByLibrary.simpleMessage("システム"),
    "takeBackTheInternetLbl": MessageLookupByLibrary.simpleMessage("インターネットを取り戻そう。"),
    "termsAndConditions": MessageLookupByLibrary.simpleMessage("利用規約"),
    "title": MessageLookupByLibrary.simpleMessage("こんにちは"),
    "toManyRequestsErrorMsg": MessageLookupByLibrary.simpleMessage("リクエストが多すぎます。後でもう一度お試しください。"),
    "tokenAlreadyUsed": MessageLookupByLibrary.simpleMessage("トークンはすでに使用されています。もう一度お試しください。\n"),
    "tooManyConnectionsBannerCTADisconnect": MessageLookupByLibrary.simpleMessage("切断"),
    "tooManyConnectionsBannerCTAReconnect": MessageLookupByLibrary.simpleMessage("再接続"),
    "tooManyConnectionsBannerDesc": MessageLookupByLibrary.simpleMessage(
      "アカウントで接続できるデバイス 6 台の上限に達しました。VPN を使い続けるには、クリックして再接続してください。",
    ),
    "tooManyConnectionsBannerDescConnected": MessageLookupByLibrary.simpleMessage(
      "アカウントで接続できるデバイス 6 台の上限に達しました。VPN を使い続けるには、切断をクリックしてもう一度お試しください。",
    ),
    "tooManyConnectionsBannerTitle": MessageLookupByLibrary.simpleMessage("接続が切断されました"),
    "topLocations": MessageLookupByLibrary.simpleMessage("人気のロケーション"),
    "tr": MessageLookupByLibrary.simpleMessage("トルコ語"),
    "tryAgainBtn": MessageLookupByLibrary.simpleMessage("もう一度試す"),
    "tryAnotherLocation": MessageLookupByLibrary.simpleMessage("別のロケーションを検索してみてください"),
    "tunnelPermissionRequired": MessageLookupByLibrary.simpleMessage("VPNトンネルを開始するには許可が必要です。"),
    "tunnelSetupError": MessageLookupByLibrary.simpleMessage("トンネルの設定中にエラーが発生しました"),
    "typeDelete": m26,
    "typeFeedback": MessageLookupByLibrary.simpleMessage("ここにフィードバックを入力…"),
    "ukraine": MessageLookupByLibrary.simpleMessage("ウクライナ"),
    "unableToConnectToPaymentProcesor": MessageLookupByLibrary.simpleMessage(
      "決済プロセッサに接続できません。もう一度お試しください。",
    ),
    "unauthenticatedBannerTitle": MessageLookupByLibrary.simpleMessage("サインインしていません"),
    "unauthenticatedSettingSubtitle": MessageLookupByLibrary.simpleMessage(
      "サインインしてアカウントにアクセスし、すべての機能を利用しましょう",
    ),
    "unauthenticatedSettingTitle": MessageLookupByLibrary.simpleMessage("サインインしていません"),
    "unprotectedLbl": MessageLookupByLibrary.simpleMessage("未保護"),
    "unstableSpeedReason": MessageLookupByLibrary.simpleMessage("不安定な速度"),
    "updateBtn": MessageLookupByLibrary.simpleMessage("アップデート"),
    "userIntentBestSpeed": MessageLookupByLibrary.simpleMessage("最速"),
    "userIntentBestSpeedDesc": MessageLookupByLibrary.simpleMessage(
      "最適なパフォーマンスのため、利用可能な最速のサーバーに接続します",
    ),
    "userIntentLabel": MessageLookupByLibrary.simpleMessage("専用サーバー"),
    "userIntentLowLatency": MessageLookupByLibrary.simpleMessage("低遅延"),
    "userIntentLowLatencyDesc": MessageLookupByLibrary.simpleMessage(
      "安定して信頼できるアクセスのため、最寄りのサーバーに自動接続します",
    ),
    "userIntentMaxPrivacy": MessageLookupByLibrary.simpleMessage("最大限のプライバシー"),
    "userIntentMaxPrivacyDesc": MessageLookupByLibrary.simpleMessage(
      "国に応じて、言論の自由と速度に最適なサーバーを取得します",
    ),
    "userIntentNearestLocation": MessageLookupByLibrary.simpleMessage("最寄りのロケーション"),
    "userIntentNearestLocationDesc": MessageLookupByLibrary.simpleMessage(
      "現在地に基づき、最適な速度とパフォーマンスの最寄りの VPN IP に接続します",
    ),
    "userIntentP2P": MessageLookupByLibrary.simpleMessage("P2P"),
    "userIntentP2PDesc": MessageLookupByLibrary.simpleMessage(
      "安全な暗号取引、ファイル共有、ゲームホスティング、通信に最適なサーバーを選びます",
    ),
    "userIntentStreaming": MessageLookupByLibrary.simpleMessage("Streaming"),
    "userIntentStreamingDesc": MessageLookupByLibrary.simpleMessage(
      "地域限定のプラットフォームでお気に入りの番組や映画にアクセスできます",
    ),
    "viewAllFeaturesBtn": MessageLookupByLibrary.simpleMessage("すべての機能を見る"),
    "viewLessBtn": MessageLookupByLibrary.simpleMessage("折りたたむ"),
    "vodafoneLbl": MessageLookupByLibrary.simpleMessage("Vodafone Iberia"),
    "vpnProtocolSettingLbl": MessageLookupByLibrary.simpleMessage("VPN プロトコル"),
    "year": MessageLookupByLibrary.simpleMessage("年"),
    "yearly": MessageLookupByLibrary.simpleMessage("毎年"),
    "yes": MessageLookupByLibrary.simpleMessage("はい"),
    "zh": MessageLookupByLibrary.simpleMessage("中国語"),
  };
}
