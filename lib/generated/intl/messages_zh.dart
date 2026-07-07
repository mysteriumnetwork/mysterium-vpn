// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a zh locale. All the
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
  String get localeName => 'zh';

  static String m0(store) => "你已通过 ${store} 付费订阅。请在 ${store} 中管理。";

  static String m1(amount, period) => "${amount} /${period}";

  static String m2(amount, period) => "${amount}/月 — 按${period}计费";

  static String m3(couponCode) => "${couponCode} 已复制到剪贴板！";

  static String m4(email) => "我们已向 ${email} 发送了一封电子邮件";

  static String m5(email) => "你可能已使用“${email}”购买了付费订阅";

  static String m6(errorCode) => "连接失败。请重试 [错误：${errorCode}]";

  static String m7(plan) => "获取 ${plan}";

  static String m8(plan) => "获取 ${plan} 套餐";

  static String m9(location) => "${location} 没有其他可用的 IP。请选择其他国家/地区或城市，下次即可获得不同的 IP。";

  static String m10(location) => "${location} 没有其他可用的 IP。请选择其他国家/地区，下次即可获得不同的 IP。";

  static String m11(count) => "${Intl.plural(count, other: '${count} 个城市')}";

  static String m12(count) => "${Intl.plural(count, other: '${count} 个 IP')}";

  static String m13(count) => "${Intl.plural(count, other: '${count} 个州')}";

  static String m14(location) => "${location} 当前不可用";

  static String m15(location) => "无法更新 ${location}";

  static String m16(location) => "${location} 已更新";

  static String m17(date) => "下次计费：${date}";

  static String m18(protocol, label) => "${protocol}（${label}）";

  static String m19(location) => "刷新 ${location}";

  static String m20(count) => "${Intl.plural(count, other: '重新发送 (${count})')}";

  static String m21(percent) => "节省 ${percent}%";

  static String m22(percent, planId) => "选择 ${planId} 套餐可节省 ${percent}%";

  static String m23(plan) => "升级到 ${plan}";

  static String m24(plan) => "升级到 ${plan} 套餐";

  static String m25(location) => "切换到 ${location}";

  static String m26(word) => "输入 ${word}";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static Map<String, Function> _notInlinedMessages(_) => <String, Function>{
    "LoggingYouIn": MessageLookupByLibrary.simpleMessage("正在为你登录…"),
    "accessBlockedSitesReason": MessageLookupByLibrary.simpleMessage("无法访问被屏蔽的网站"),
    "account": MessageLookupByLibrary.simpleMessage("账户"),
    "accountSuccessfullyDeleted": MessageLookupByLibrary.simpleMessage("账户已删除"),
    "activeSubsPaidVia": m0,
    "allLocations": MessageLookupByLibrary.simpleMessage("所有地点"),
    "allowBtn": MessageLookupByLibrary.simpleMessage("允许"),
    "allowNotificationsBtn": MessageLookupByLibrary.simpleMessage("允许通知"),
    "allowPushNotificationsBtn": MessageLookupByLibrary.simpleMessage("允许通知"),
    "and": MessageLookupByLibrary.simpleMessage(" 和 "),
    "appUpdateAvailableDesc": MessageLookupByLibrary.simpleMessage("新版本已上线！立即更新，获取最新功能和改进。"),
    "appUpdateAvailableSetting": MessageLookupByLibrary.simpleMessage("有可用更新！"),
    "appUpdateAvailableTitle": MessageLookupByLibrary.simpleMessage("有可用更新"),
    "appearanceSettingLbl": MessageLookupByLibrary.simpleMessage("外观"),
    "ar": MessageLookupByLibrary.simpleMessage("阿拉伯语"),
    "austria": MessageLookupByLibrary.simpleMessage("奥地利"),
    "authenticationFailed": MessageLookupByLibrary.simpleMessage("无法登录。请重试。"),
    "back": MessageLookupByLibrary.simpleMessage("返回"),
    "backToSettingsLbl": MessageLookupByLibrary.simpleMessage("返回设置"),
    "batterySaverLabel": MessageLookupByLibrary.simpleMessage("省电"),
    "berlinLbl": MessageLookupByLibrary.simpleMessage("德国柏林 🇩🇪"),
    "billedInTotal": m1,
    "billedPerMonth": m2,
    "blockerSettingLbl": MessageLookupByLibrary.simpleMessage("拦截器"),
    "buttonUpdateApp": MessageLookupByLibrary.simpleMessage("立即更新"),
    "bypassRestrictionsReason": MessageLookupByLibrary.simpleMessage("绕过限制"),
    "cancelBtn": MessageLookupByLibrary.simpleMessage("取消"),
    "cancelSurveyFeedbackHint": MessageLookupByLibrary.simpleMessage("请填写更多详情…"),
    "cancelSurveyTitle": MessageLookupByLibrary.simpleMessage("取消原因"),
    "cancelYourSubsMess": MessageLookupByLibrary.simpleMessage("删除账户前，请先在 App Store 订阅中取消你的订阅。"),
    "checkSubsStatusFailedDesc": MessageLookupByLibrary.simpleMessage("我们无法获取你的套餐信息。"),
    "checkSubsStatusFailedTitle": MessageLookupByLibrary.simpleMessage("套餐信息不可用"),
    "checkSubsStatusTitle": MessageLookupByLibrary.simpleMessage("正在获取套餐信息…"),
    "checkYourEmail": MessageLookupByLibrary.simpleMessage("查看你的电子邮件"),
    "clearSearchBtn": MessageLookupByLibrary.simpleMessage("清除搜索"),
    "closeBtn": MessageLookupByLibrary.simpleMessage("关闭"),
    "communicationLbl": MessageLookupByLibrary.simpleMessage("通讯"),
    "communicationLblDesktop": MessageLookupByLibrary.simpleMessage("通讯"),
    "completeBtn": MessageLookupByLibrary.simpleMessage("完成"),
    "confirm": MessageLookupByLibrary.simpleMessage("确认"),
    "connect": MessageLookupByLibrary.simpleMessage("连接"),
    "connectBestServer": MessageLookupByLibrary.simpleMessage("最佳服务器"),
    "connected": MessageLookupByLibrary.simpleMessage("已连接"),
    "connecting": MessageLookupByLibrary.simpleMessage("正在连接"),
    "connectingToPaymentProcesor": MessageLookupByLibrary.simpleMessage("正在连接支付处理器…"),
    "connection": MessageLookupByLibrary.simpleMessage("连接"),
    "connectionSettingLbl": MessageLookupByLibrary.simpleMessage("连接与保护"),
    "connectionTimeout": MessageLookupByLibrary.simpleMessage("连接超时。请稍后重试。若问题持续，请联系支持团队"),
    "consistentSpeedReason": MessageLookupByLibrary.simpleMessage("速度稳定"),
    "consumeLink": MessageLookupByLibrary.simpleMessage("它只能在发出请求的设备上使用——请点击电子邮件中的链接继续。"),
    "continueBtn": MessageLookupByLibrary.simpleMessage("继续"),
    "continueWithApple": MessageLookupByLibrary.simpleMessage("使用 Apple 继续"),
    "continueWithEmail": MessageLookupByLibrary.simpleMessage("使用电子邮件继续"),
    "continueWithGoogle": MessageLookupByLibrary.simpleMessage("使用 Google 继续"),
    "copyLink": MessageLookupByLibrary.simpleMessage("复制链接并粘贴到浏览器中"),
    "couponCodeCopied": m3,
    "dark": MessageLookupByLibrary.simpleMessage("深色"),
    "dataCentreComparisonCardItem1": MessageLookupByLibrary.simpleMessage("易被检测"),
    "dataCentreComparisonCardItem2": MessageLookupByLibrary.simpleMessage("常被网站屏蔽"),
    "dataCentreComparisonCardItem3": MessageLookupByLibrary.simpleMessage("隐私性较低"),
    "dataCentreComparisonCardLbl": MessageLookupByLibrary.simpleMessage("数据中心 IP"),
    "dataCentreComparisonCardTitle": MessageLookupByLibrary.simpleMessage("大多数 VPN"),
    "de": MessageLookupByLibrary.simpleMessage("德语"),
    "deleteAccount": MessageLookupByLibrary.simpleMessage("删除账户"),
    "deleteAccountQuestion": MessageLookupByLibrary.simpleMessage("删除账户？"),
    "deleteBtn": MessageLookupByLibrary.simpleMessage("删除"),
    "deviceLimitReachedDesc": MessageLookupByLibrary.simpleMessage(
      "你已达到连接设备数量上限。要添加新设备，请先从账户中移除现有设备。",
    ),
    "deviceLimitReachedOpenDashboard": MessageLookupByLibrary.simpleMessage("打开控制台"),
    "deviceLimitReachedTitle": MessageLookupByLibrary.simpleMessage("已达设备上限"),
    "disconnect": MessageLookupByLibrary.simpleMessage("断开连接"),
    "disconnected": MessageLookupByLibrary.simpleMessage("已断开连接"),
    "disconnecting": MessageLookupByLibrary.simpleMessage("正在断开连接"),
    "discountedPriceLabel": MessageLookupByLibrary.simpleMessage("仅需"),
    "dns": MessageLookupByLibrary.simpleMessage("DNS 保护"),
    "dnsDesc": MessageLookupByLibrary.simpleMessage("防止 DNS 泄漏"),
    "duration": MessageLookupByLibrary.simpleMessage("时长"),
    "email": MessageLookupByLibrary.simpleMessage("电子邮件地址"),
    "emailIsNotValid": MessageLookupByLibrary.simpleMessage("电子邮件地址无效"),
    "emailIsRequired": MessageLookupByLibrary.simpleMessage("电子邮件地址为必填项"),
    "emailNotificationsSetting": MessageLookupByLibrary.simpleMessage("电子邮件通知"),
    "emailSentTo": m4,
    "en": MessageLookupByLibrary.simpleMessage("英语"),
    "es": MessageLookupByLibrary.simpleMessage("西班牙语"),
    "existingSubscriptionDesc": m5,
    "existingSubscriptionTitle": MessageLookupByLibrary.simpleMessage("你可以登出并改用你的电子邮件，或忽略此警告"),
    "failedToConnectError": m6,
    "failedToSubmitFeedback": MessageLookupByLibrary.simpleMessage("反馈提交失败。请重试。"),
    "failedToSubscribe": MessageLookupByLibrary.simpleMessage("你的订阅出现问题。请重试！"),
    "failedToVerifySubs": MessageLookupByLibrary.simpleMessage("我们无法验证你上次的订阅购买。请点击下方按钮重试。"),
    "fastLabel": MessageLookupByLibrary.simpleMessage("快速"),
    "featureToggleMinVersionNotSatisfied": MessageLookupByLibrary.simpleMessage(
      "你的应用版本过旧。请更新应用后继续使用。",
    ),
    "formValidationError": MessageLookupByLibrary.simpleMessage("表单数据无效。请检查各字段后重试。"),
    "fr": MessageLookupByLibrary.simpleMessage("法语"),
    "france": MessageLookupByLibrary.simpleMessage("法国"),
    "frequentDisconnectsReason": MessageLookupByLibrary.simpleMessage("频繁断开连接"),
    "fullPriceLabel": MessageLookupByLibrary.simpleMessage("原价："),
    "germany": MessageLookupByLibrary.simpleMessage("德国"),
    "getNewIPAddress": MessageLookupByLibrary.simpleMessage("刷新时获取新的 IP 地址"),
    "getSubscriptionModalDesc": MessageLookupByLibrary.simpleMessage("保护你的连接，立即享受私密浏览"),
    "getSubscriptionModalTitle": m7,
    "getSubscriptionPlanBtn": m8,
    "gettingIPAddress": MessageLookupByLibrary.simpleMessage("正在获取 IP 地址…"),
    "goBackButton": MessageLookupByLibrary.simpleMessage("返回"),
    "goToLoginBtn": MessageLookupByLibrary.simpleMessage("前往登录"),
    "helpSupportLbl": MessageLookupByLibrary.simpleMessage("帮助与支持"),
    "hi": MessageLookupByLibrary.simpleMessage("印地语"),
    "hiddenLbl": MessageLookupByLibrary.simpleMessage("已隐藏"),
    "highLatencyReason": MessageLookupByLibrary.simpleMessage("延迟高"),
    "highSpeed": MessageLookupByLibrary.simpleMessage("高速"),
    "homeLbl": MessageLookupByLibrary.simpleMessage("首页"),
    "id": MessageLookupByLibrary.simpleMessage("印度尼西亚语"),
    "incorrectLocationReason": MessageLookupByLibrary.simpleMessage("位置不正确"),
    "incorrectMagicLink": MessageLookupByLibrary.simpleMessage("魔法链接错误。请重试。"),
    "ipAddressLbl": MessageLookupByLibrary.simpleMessage("IP 地址"),
    "ipRefreshExhaustedCity": m9,
    "ipRefreshExhaustedCountry": m10,
    "ipTypeDataCenter": MessageLookupByLibrary.simpleMessage("高速 IP"),
    "ipTypeDataCenterDisclaimer": MessageLookupByLibrary.simpleMessage("数据中心 IP，针对速度和性能进行了优化。"),
    "ipTypeResidential": MessageLookupByLibrary.simpleMessage("Residential IPs"),
    "ipTypeResidentialDisclaimer": MessageLookupByLibrary.simpleMessage("由真实家庭提供。几乎无法被检测，但稳定性较差。"),
    "ipTypeResidentialTooltipBody": MessageLookupByLibrary.simpleMessage(
      "Residential IPs 由真实家用设备提供，因此可用性可能随时间变化。\n\n若某个节点离线，应用会将你重新连接到最近的可用 Residential IP。",
    ),
    "ipTypeResidentialTooltipTitle": MessageLookupByLibrary.simpleMessage("为什么我的 IP 会变化？"),
    "it": MessageLookupByLibrary.simpleMessage("意大利语"),
    "italy": MessageLookupByLibrary.simpleMessage("意大利"),
    "ja": MessageLookupByLibrary.simpleMessage("日语"),
    "killSwitch": MessageLookupByLibrary.simpleMessage("Kill switch"),
    "killSwitchDesc": MessageLookupByLibrary.simpleMessage("VPN 连接断开时阻断互联网流量"),
    "languageSettingLbl": MessageLookupByLibrary.simpleMessage("语言"),
    "light": MessageLookupByLibrary.simpleMessage("浅色"),
    "linkCopied": MessageLookupByLibrary.simpleMessage("链接已复制到剪贴板！"),
    "linkExpires": MessageLookupByLibrary.simpleMessage("该链接将在 30 分钟后失效，且只能使用一次。"),
    "location": MessageLookupByLibrary.simpleMessage("地点"),
    "locationItemCityCount": m11,
    "locationItemNodeCount": m12,
    "locationItemStatesCount": m13,
    "locationLbl": MessageLookupByLibrary.simpleMessage("地点"),
    "locationUnavailableAction": MessageLookupByLibrary.simpleMessage("连接到最近的 IP"),
    "locationUnavailableSubtitle": MessageLookupByLibrary.simpleMessage("连接到最近的 IP，或手动选择"),
    "locationUnavailableTitle": m14,
    "locationsUpdateFailed": m15,
    "locationsUpdated": m16,
    "loginSessionExpired": MessageLookupByLibrary.simpleMessage("你的会话已过期。请重新登录。"),
    "loginSignupLabel": MessageLookupByLibrary.simpleMessage("登录或注册"),
    "logout": MessageLookupByLibrary.simpleMessage("登出"),
    "logoutConfirmationDesc": MessageLookupByLibrary.simpleMessage("你即将登出。确定吗？"),
    "logoutConfirmationTitle": MessageLookupByLibrary.simpleMessage("登出"),
    "logoutVPNConnectedDesc": MessageLookupByLibrary.simpleMessage(
      "VPN 已开启。如果继续退出登录，你将与 VPN 服务器断开连接。",
    ),
    "lowLatencyReason": MessageLookupByLibrary.simpleMessage("延迟低"),
    "madridLbl": MessageLookupByLibrary.simpleMessage("西班牙马德里 🇪🇸"),
    "malwareLbl": MessageLookupByLibrary.simpleMessage("恶意软件"),
    "manageOnWebBtn": MessageLookupByLibrary.simpleMessage("在网页上管理"),
    "marketingConsentPopupDesc": MessageLookupByLibrary.simpleMessage(
      "你是否愿意接收来自 Mysterium Network 的电子邮件更新、隐私技巧和特别优惠？",
    ),
    "marketingConsentPopupTitle": MessageLookupByLibrary.simpleMessage("通过电子邮件了解最新动态"),
    "month": MessageLookupByLibrary.simpleMessage("月"),
    "monthly": MessageLookupByLibrary.simpleMessage("每月"),
    "navLocations": MessageLookupByLibrary.simpleMessage("地点"),
    "navMap": MessageLookupByLibrary.simpleMessage("地图"),
    "navProducts": MessageLookupByLibrary.simpleMessage("产品"),
    "nextBilling": m17,
    "no": MessageLookupByLibrary.simpleMessage("否"),
    "noActiveSubsDesc": MessageLookupByLibrary.simpleMessage("你没有有效的订阅"),
    "noEmailApp": MessageLookupByLibrary.simpleMessage("你的设备上没有电子邮件应用。"),
    "noLocationsFound": MessageLookupByLibrary.simpleMessage("未找到地点"),
    "noServersAvailable": MessageLookupByLibrary.simpleMessage("没有可用的服务器"),
    "noServersAvailableSub": MessageLookupByLibrary.simpleMessage("网络连接出现问题，没有可用的服务器。请稍后重试。"),
    "noSubscriptionAction": MessageLookupByLibrary.simpleMessage("获取套餐"),
    "noSubscriptionTitle": MessageLookupByLibrary.simpleMessage("暂无有效套餐"),
    "noneLbl": MessageLookupByLibrary.simpleMessage("无"),
    "notAvailableMsg": MessageLookupByLibrary.simpleMessage("不可用"),
    "notNowBtn": MessageLookupByLibrary.simpleMessage("暂不"),
    "nsfwLbl": MessageLookupByLibrary.simpleMessage("NSFW 与恶意软件"),
    "onboardingStep1Desc": MessageLookupByLibrary.simpleMessage("网站、追踪器和公共 Wi-Fi 网络都能看到你的 IP 和位置。"),
    "onboardingStep1Title": MessageLookupByLibrary.simpleMessage("你的连接已暴露"),
    "onboardingStep2Desc": MessageLookupByLibrary.simpleMessage(
      "Mysterium VPN 会隐藏你的 IP、ISP 和位置，让你真正私密地浏览。",
    ),
    "onboardingStep2Title": MessageLookupByLibrary.simpleMessage("一键隐藏你的真实身份"),
    "onboardingStep3Desc": MessageLookupByLibrary.simpleMessage(
      "使用 Residential IPs，你的连接看起来自然——不像典型的 VPN 流量。",
    ),
    "onboardingStep3Title": MessageLookupByLibrary.simpleMessage("并非所有 VPN 都一样"),
    "openEmailApp": MessageLookupByLibrary.simpleMessage("打开电子邮件应用"),
    "openSystemSettingsBtn": MessageLookupByLibrary.simpleMessage("打开系统设置"),
    "or": MessageLookupByLibrary.simpleMessage("或"),
    "orSelectCountryManually": MessageLookupByLibrary.simpleMessage(
      "我们会为你连接到最佳服务器——或者你可以手动选择国家/地区。",
    ),
    "otherReason": MessageLookupByLibrary.simpleMessage("其他…"),
    "pendingTransactionMessage": MessageLookupByLibrary.simpleMessage("你已有一笔进行中的付款交易。请先完成后再发起新交易。"),
    "perMonth": MessageLookupByLibrary.simpleMessage("月"),
    "pl": MessageLookupByLibrary.simpleMessage("波兰语"),
    "planAlreadyPurchasedMsg": MessageLookupByLibrary.simpleMessage("一切就绪！你已激活此套餐。"),
    "plan_2_years": MessageLookupByLibrary.simpleMessage("2 年套餐"),
    "plan_2_years_basic": MessageLookupByLibrary.simpleMessage("Basic 2 年"),
    "plan_2_years_pro": MessageLookupByLibrary.simpleMessage("Pro 2 年"),
    "plan_6_months": MessageLookupByLibrary.simpleMessage("6 个月套餐"),
    "plan_monthly": MessageLookupByLibrary.simpleMessage("月度套餐"),
    "plan_monthly_basic": MessageLookupByLibrary.simpleMessage("Basic 月度"),
    "plan_monthly_plus": MessageLookupByLibrary.simpleMessage("Plus 月度"),
    "plan_monthly_pro": MessageLookupByLibrary.simpleMessage("Pro 月度"),
    "plan_yearly": MessageLookupByLibrary.simpleMessage("年度套餐"),
    "plan_yearly_basic": MessageLookupByLibrary.simpleMessage("Basic 年度"),
    "plan_yearly_plus": MessageLookupByLibrary.simpleMessage("Plus 年度"),
    "plan_yearly_pro": MessageLookupByLibrary.simpleMessage("Pro 年度"),
    "poland": MessageLookupByLibrary.simpleMessage("波兰"),
    "preferences": MessageLookupByLibrary.simpleMessage("偏好设置"),
    "pricingPlanSeePlansBtn": MessageLookupByLibrary.simpleMessage("查看所有套餐"),
    "privacyPolicy": MessageLookupByLibrary.simpleMessage("隐私政策"),
    "processingPayment": MessageLookupByLibrary.simpleMessage("我们正在处理你的付款。很快就好…"),
    "productsActivePlanWebSyncAlert": MessageLookupByLibrary.simpleMessage(
      "你已有有效套餐。请在网页上升级——更改会自动同步",
    ),
    "productsAllPlansLbl": MessageLookupByLibrary.simpleMessage("所有套餐："),
    "productsBasicDescription": MessageLookupByLibrary.simpleMessage("日常隐私必备"),
    "productsDuration1Month": MessageLookupByLibrary.simpleMessage("1 个月"),
    "productsDuration1Year": MessageLookupByLibrary.simpleMessage("1 年"),
    "productsDuration2Year": MessageLookupByLibrary.simpleMessage("2 年"),
    "productsExploreSubtitle": MessageLookupByLibrary.simpleMessage("探索套餐和功能"),
    "productsManageSubtitle": MessageLookupByLibrary.simpleMessage("在网页上管理和升级"),
    "productsMaxPlanAlert": MessageLookupByLibrary.simpleMessage("你已是最高级别的套餐。"),
    "productsNotAvailable": MessageLookupByLibrary.simpleMessage("当前没有可用的产品。请稍后重试。"),
    "productsPlusDescription": MessageLookupByLibrary.simpleMessage("更多设备，更多地点"),
    "productsProDescription": MessageLookupByLibrary.simpleMessage("为重度用户提供最强保护"),
    "productsSubscribeWebAlert": MessageLookupByLibrary.simpleMessage("订阅在网页上管理。你的套餐将自动同步到应用。"),
    "productsSubscribeWebSubtitle": MessageLookupByLibrary.simpleMessage("在网页上订阅"),
    "productsTitle": MessageLookupByLibrary.simpleMessage("VPN 产品"),
    "protectedLbl": MessageLookupByLibrary.simpleMessage("受保护"),
    "protocol": MessageLookupByLibrary.simpleMessage("协议"),
    "protocolLabel": m18,
    "protocolPickerSettingDesc": MessageLookupByLibrary.simpleMessage("切换 VPN 协议会断开你的连接。之后需要重新连接。"),
    "protocolPickerSettingTitle": MessageLookupByLibrary.simpleMessage("切换 VPN 协议"),
    "pt": MessageLookupByLibrary.simpleMessage("葡萄牙语"),
    "ptBR": MessageLookupByLibrary.simpleMessage("巴西葡萄牙语"),
    "pushNotificationsConsentPopupDesc": MessageLookupByLibrary.simpleMessage(
      "获取新功能、实用技巧和专属优惠的通知——只发有用的更新。",
    ),
    "pushNotificationsConsentPopupTitle": MessageLookupByLibrary.simpleMessage("通过推送通知随时了解最新动态"),
    "pushNotificationsSetting": MessageLookupByLibrary.simpleMessage("推送通知"),
    "pushNotificationsSettingDesc": MessageLookupByLibrary.simpleMessage("产品更新、技巧和特别优惠"),
    "qaToolboxLbl": MessageLookupByLibrary.simpleMessage("QA Toolbox"),
    "rateConnection": MessageLookupByLibrary.simpleMessage("你的连接如何？"),
    "rateConnectionDislike": MessageLookupByLibrary.simpleMessage("你不喜欢什么？"),
    "rateConnectionLike": MessageLookupByLibrary.simpleMessage("你喜欢什么？"),
    "recentLocations": MessageLookupByLibrary.simpleMessage("最近的地点"),
    "redeemDiscountCode": MessageLookupByLibrary.simpleMessage("兑换折扣码"),
    "redirectToLoginPage": MessageLookupByLibrary.simpleMessage("你的账户已成功删除。你将被重定向到登录页面。"),
    "refresh": MessageLookupByLibrary.simpleMessage("刷新"),
    "refreshIP": MessageLookupByLibrary.simpleMessage("刷新 IP"),
    "refreshIPAddress": MessageLookupByLibrary.simpleMessage("刷新 IP 地址"),
    "refreshLocationsTooltip": m19,
    "resetAppDesc": MessageLookupByLibrary.simpleMessage("出现异常时进行重置"),
    "resetAppDialogContent": MessageLookupByLibrary.simpleMessage(
      "若继续重置应用，你将与 Mysterium VPN 断开连接。",
    ),
    "resetAppDialogTitle": MessageLookupByLibrary.simpleMessage("VPN 连接当前处于活动状态"),
    "resetAppFailed": MessageLookupByLibrary.simpleMessage("重置应用失败。请重试。"),
    "resetAppSuccess": MessageLookupByLibrary.simpleMessage("应用已成功重置。"),
    "resetAppTitle": MessageLookupByLibrary.simpleMessage("重置应用"),
    "resetBtn": MessageLookupByLibrary.simpleMessage("重置"),
    "residential": MessageLookupByLibrary.simpleMessage("Residential"),
    "residentialCentreComparisonCardItem1": MessageLookupByLibrary.simpleMessage("看起来像真实用户"),
    "residentialCentreComparisonCardItem2": MessageLookupByLibrary.simpleMessage("更难被检测"),
    "residentialCentreComparisonCardItem3": MessageLookupByLibrary.simpleMessage("更少被屏蔽"),
    "residentialCentreComparisonCardLbl": MessageLookupByLibrary.simpleMessage("RESIDENTIAL IPS"),
    "residentialEducationBlock1Body": MessageLookupByLibrary.simpleMessage(
      "Residential IPs 来自真实家用设备，使你的流量看起来像普通的互联网使用。",
    ),
    "residentialEducationBlock1Title": MessageLookupByLibrary.simpleMessage("真实家用设备"),
    "residentialEducationBlock2Body": MessageLookupByLibrary.simpleMessage(
      "由于这些 IP 来自真实设备，部分节点可能会不时离线。",
    ),
    "residentialEducationBlock2Title": MessageLookupByLibrary.simpleMessage("可用性可能变化"),
    "residentialEducationBlock3Body": MessageLookupByLibrary.simpleMessage(
      "若你当前的 IP 不可用，应用会将你重新连接到最近的可用 Residential IP。",
    ),
    "residentialEducationBlock3Title": MessageLookupByLibrary.simpleMessage("自动重新连接"),
    "residentialEducationGotIt": MessageLookupByLibrary.simpleMessage("知道了"),
    "residentialEducationSubtitle": MessageLookupByLibrary.simpleMessage(
      "Residential IPs 与高速 IP 不同。以下是你需要了解的内容。",
    ),
    "residentialEducationTitle": MessageLookupByLibrary.simpleMessage("Residential IPs 的工作原理"),
    "retryBtn": MessageLookupByLibrary.simpleMessage("重试"),
    "reviewLeaveReviewBtn": MessageLookupByLibrary.simpleMessage("留下评价"),
    "reviewPositiveTitle": MessageLookupByLibrary.simpleMessage("太好了！方便给我们留个评价吗？"),
    "reviewSatisfactionTitle": MessageLookupByLibrary.simpleMessage("你会向他人推荐这款应用吗？"),
    "searchForLocations": MessageLookupByLibrary.simpleMessage("搜索地点"),
    "seePlansBtn": MessageLookupByLibrary.simpleMessage("查看套餐"),
    "selectEmailApp": MessageLookupByLibrary.simpleMessage("选择电子邮件应用以继续"),
    "semiAnnual": MessageLookupByLibrary.simpleMessage("每半年"),
    "sendAgain": m20,
    "serviceUnavailableError": MessageLookupByLibrary.simpleMessage("我们遇到临时网络问题。请稍后重试。"),
    "settingManageBtn": MessageLookupByLibrary.simpleMessage("管理"),
    "settings": MessageLookupByLibrary.simpleMessage("设置"),
    "setupTunnerPermissionsDialogDesc": MessageLookupByLibrary.simpleMessage(
      "要使用 Mysterium VPN，我们需要你的授权以安装 VPN 配置文件。",
    ),
    "setupTunnerPermissionsDialogDisclaimer": MessageLookupByLibrary.simpleMessage(
      "你的匿名性是安全的。我们不会查看、收集或存储你的任何浏览活动。",
    ),
    "setupTunnerPermissionsDialogTitle": MessageLookupByLibrary.simpleMessage("我们需要你的授权"),
    "signIn": MessageLookupByLibrary.simpleMessage("登录 Mysterium VPN"),
    "signInAbortedMsg": MessageLookupByLibrary.simpleMessage("登录已中止"),
    "signInBtn": MessageLookupByLibrary.simpleMessage("登录"),
    "signInDisclaimer": MessageLookupByLibrary.simpleMessage(
      "Mysterium VPN 不会记录你的在线活动，也不会将任何记录与你、你的设备、你的 IP 地址或电子邮件关联。登录即表示你同意我们的",
    ),
    "sixMonths": MessageLookupByLibrary.simpleMessage("6 个月"),
    "skipBtn": MessageLookupByLibrary.simpleMessage("跳过"),
    "somethingWentWrong": MessageLookupByLibrary.simpleMessage("出错了。请重试！"),
    "stableConnectionReason": MessageLookupByLibrary.simpleMessage("连接稳定"),
    "status": MessageLookupByLibrary.simpleMessage("状态"),
    "stayButton": MessageLookupByLibrary.simpleMessage("留下"),
    "submitBtn": MessageLookupByLibrary.simpleMessage("提交"),
    "subscribeOnWebBtn": MessageLookupByLibrary.simpleMessage("在网页上订阅"),
    "subscriptionActive": MessageLookupByLibrary.simpleMessage("好消息！你的订阅现已激活。"),
    "subscriptionAllPlansBackToPlans": MessageLookupByLibrary.simpleMessage("返回套餐"),
    "subscriptionAllPlansCompareAll": MessageLookupByLibrary.simpleMessage("比较所有功能"),
    "subscriptionAllPlansCurrentPlan": MessageLookupByLibrary.simpleMessage("当前套餐"),
    "subscriptionAllPlansPurchase": MessageLookupByLibrary.simpleMessage("获取套餐"),
    "subscriptionAllPlansTabMonth": MessageLookupByLibrary.simpleMessage("每月"),
    "subscriptionAllPlansTabYear": MessageLookupByLibrary.simpleMessage("1 年"),
    "subscriptionAllPlansTitle": MessageLookupByLibrary.simpleMessage("所有套餐"),
    "subscriptionAllPlansUpgrade": MessageLookupByLibrary.simpleMessage("升级你的套餐"),
    "subscriptionOnboardingBoostProtectionDescription": MessageLookupByLibrary.simpleMessage(
      "探索 VPN 协议和恶意软件拦截等高级功能。",
    ),
    "subscriptionOnboardingBoostProtectionTitle": MessageLookupByLibrary.simpleMessage("增强你的防护"),
    "subscriptionOnboardingCancelTourLabel": MessageLookupByLibrary.simpleMessage("暂时跳过"),
    "subscriptionOnboardingConnectDescription": MessageLookupByLibrary.simpleMessage(
      "我们会为你连接到最佳服务器。",
    ),
    "subscriptionOnboardingConnectTitle": MessageLookupByLibrary.simpleMessage("连接以保持私密"),
    "subscriptionOnboardingManagePlanDescription": MessageLookupByLibrary.simpleMessage(
      "根据你的账户权限购买、升级或查看可用套餐。",
    ),
    "subscriptionOnboardingManagePlanTitle": MessageLookupByLibrary.simpleMessage("管理你的套餐"),
    "subscriptionOnboardingMapDesktopDescription": MessageLookupByLibrary.simpleMessage(
      "浏览地图，或从侧边栏探索地点。",
    ),
    "subscriptionOnboardingMapDesktopTitle": MessageLookupByLibrary.simpleMessage("以你的方式探索地点"),
    "subscriptionOnboardingMapMobileDescription": MessageLookupByLibrary.simpleMessage(
      "浏览地图选择国家/地区，即刻连接。",
    ),
    "subscriptionOnboardingMapMobileTitle": MessageLookupByLibrary.simpleMessage("从地图连接"),
    "subscriptionOnboardingPromptDescription": MessageLookupByLibrary.simpleMessage(
      "熟悉更新后的应用，了解主要功能现在的位置。",
    ),
    "subscriptionOnboardingPromptTitle": MessageLookupByLibrary.simpleMessage("快速浏览一下"),
    "subscriptionOnboardingSearchDescription": MessageLookupByLibrary.simpleMessage(
      "通过搜索快速查找国家/地区、城市和服务器。",
    ),
    "subscriptionOnboardingSearchTitle": MessageLookupByLibrary.simpleMessage("搜索并更快连接"),
    "subscriptionOnboardingSetupCompleteDescription": MessageLookupByLibrary.simpleMessage(
      "选择一个地点，开始更私密地浏览。",
    ),
    "subscriptionOnboardingSetupCompleteTitle": MessageLookupByLibrary.simpleMessage("设置完成"),
    "subscriptionOnboardingStartTourLabel": MessageLookupByLibrary.simpleMessage("开始浏览"),
    "subscriptionOnboardingVPNLocationsDesktopDescription": MessageLookupByLibrary.simpleMessage(
      "在一处探索各国家/地区和城市。",
    ),
    "subscriptionOnboardingVPNLocationsMobileDescription": MessageLookupByLibrary.simpleMessage(
      "在一处探索国家/地区、城市、最近连接和专用服务器。",
    ),
    "subscriptionOnboardingVPNLocationsTitle": MessageLookupByLibrary.simpleMessage("浏览 VPN 地点"),
    "subscriptionPlanBestValue": MessageLookupByLibrary.simpleMessage("超值之选"),
    "subscriptionPlanCityLevel": MessageLookupByLibrary.simpleMessage("城市级选择"),
    "subscriptionPlanCityLevelDesc": MessageLookupByLibrary.simpleMessage(
      "提供比大多数 VPN 更精确的位置控制，后者通常只能选择整个国家/地区或州。",
    ),
    "subscriptionPlanDevicesSecured": MessageLookupByLibrary.simpleMessage("同时保护的设备"),
    "subscriptionPlanDoubleVPN": MessageLookupByLibrary.simpleMessage("双重 VPN"),
    "subscriptionPlanDoubleVPNDesc": MessageLookupByLibrary.simpleMessage(
      "额外的安全层。将你的网络流量经过两台不同的 VPN 服务器路由，对数据进行双重加密，并将你的 IP 地址隐藏在第二台服务器之后",
    ),
    "subscriptionPlanMalwareBlocker": MessageLookupByLibrary.simpleMessage("恶意软件拦截器"),
    "subscriptionPlanMalwareBlockerDesc": MessageLookupByLibrary.simpleMessage(
      "在威胁到达设备前将其拦截，保护你的设备，并在后台静默运行，不会打扰你。",
    ),
    "subscriptionPlanMoneyBack": MessageLookupByLibrary.simpleMessage("7 天退款保证"),
    "subscriptionPlanNameBasic": MessageLookupByLibrary.simpleMessage("Basic"),
    "subscriptionPlanNamePlus": MessageLookupByLibrary.simpleMessage("Plus"),
    "subscriptionPlanNamePro": MessageLookupByLibrary.simpleMessage("Pro"),
    "subscriptionPlanPF1Basic": MessageLookupByLibrary.simpleMessage("同时保护 6 台设备"),
    "subscriptionPlanPF1Plus": MessageLookupByLibrary.simpleMessage("同时保护 10 台设备"),
    "subscriptionPlanPF2Basic": MessageLookupByLibrary.simpleMessage("支持 57 个国家/地区"),
    "subscriptionPlanPF2Plus": MessageLookupByLibrary.simpleMessage("支持 100+ 个国家/地区"),
    "subscriptionPlanPF3Basic": MessageLookupByLibrary.simpleMessage("10 台服务器"),
    "subscriptionPlanPF3Plus": MessageLookupByLibrary.simpleMessage("100 台服务器"),
    "subscriptionPlanPF4Basic": MessageLookupByLibrary.simpleMessage("VPN 协议"),
    "subscriptionPlanPF4Plus": MessageLookupByLibrary.simpleMessage("7,500+ 个 Residential IPs"),
    "subscriptionPlanPF5Plus": MessageLookupByLibrary.simpleMessage("VPN 协议"),
    "subscriptionPlanPF6Plus": MessageLookupByLibrary.simpleMessage("城市级选择"),
    "subscriptionPlanResidentialIPs": MessageLookupByLibrary.simpleMessage("Residential IPs"),
    "subscriptionPlanResidentialIPsDesc": MessageLookupByLibrary.simpleMessage(
      "让你看起来像普通家庭用户，从而访问流媒体服务并避免被检测为 VPN。",
    ),
    "subscriptionPlanSavePercent": m21,
    "subscriptionPlanSaveWith": m22,
    "subscriptionPlanServers": MessageLookupByLibrary.simpleMessage("服务器"),
    "subscriptionPlanSupportedCountries": MessageLookupByLibrary.simpleMessage("支持的国家/地区"),
    "subscriptionPlanWireGuard": MessageLookupByLibrary.simpleMessage("VPN 协议"),
    "subscriptionPlanWireGuardDesc": MessageLookupByLibrary.simpleMessage(
      "WireGuard - 快速协议，最适合游戏和流媒体\nOpenVPN - 高度可配置的协议，在其他协议失效时仍可用（Android 不支持）",
    ),
    "subscriptionProcessCanceled": MessageLookupByLibrary.simpleMessage("你尚未完成订阅更改。"),
    "subscriptionUpgrade": MessageLookupByLibrary.simpleMessage("升级"),
    "subscriptionUpgradeCTA": m23,
    "subscriptionUpgradeModalDescription": MessageLookupByLibrary.simpleMessage(
      "以访问 7,500+ 个 Residential IPs",
    ),
    "subscriptionUpgradeModalTitle": m24,
    "subscriptionUpgradeSeeAllPlans": MessageLookupByLibrary.simpleMessage("查看所有套餐"),
    "subscriptionVerificationFailed": MessageLookupByLibrary.simpleMessage("重试验证"),
    "subscripton": MessageLookupByLibrary.simpleMessage("订阅"),
    "switchToLocationBtn": m25,
    "system": MessageLookupByLibrary.simpleMessage("系统"),
    "takeBackTheInternetLbl": MessageLookupByLibrary.simpleMessage("夺回互联网。"),
    "termsAndConditions": MessageLookupByLibrary.simpleMessage("条款和条件"),
    "title": MessageLookupByLibrary.simpleMessage("你好先生"),
    "toManyRequestsErrorMsg": MessageLookupByLibrary.simpleMessage("请求过多。请稍后重试。"),
    "tokenAlreadyUsed": MessageLookupByLibrary.simpleMessage("令牌已被使用。请重试。\n"),
    "tooManyConnectionsBannerCTADisconnect": MessageLookupByLibrary.simpleMessage("断开连接"),
    "tooManyConnectionsBannerCTAReconnect": MessageLookupByLibrary.simpleMessage("重新连接"),
    "tooManyConnectionsBannerDesc": MessageLookupByLibrary.simpleMessage(
      "你的账户已达到 6 台连接设备的上限。要继续使用 VPN，请点击重新连接。",
    ),
    "tooManyConnectionsBannerDescConnected": MessageLookupByLibrary.simpleMessage(
      "你的账户已达到 6 台连接设备的上限。要继续使用 VPN，请点击断开连接后重试。",
    ),
    "tooManyConnectionsBannerTitle": MessageLookupByLibrary.simpleMessage("你已断开连接"),
    "topLocations": MessageLookupByLibrary.simpleMessage("热门地点"),
    "tr": MessageLookupByLibrary.simpleMessage("土耳其语"),
    "tryAgainBtn": MessageLookupByLibrary.simpleMessage("重试"),
    "tryAnotherLocation": MessageLookupByLibrary.simpleMessage("尝试搜索其他地点"),
    "tunnelPermissionRequired": MessageLookupByLibrary.simpleMessage("启动 VPN 隧道需要授予权限。"),
    "tunnelSetupError": MessageLookupByLibrary.simpleMessage("设置隧道时发生错误"),
    "typeDelete": m26,
    "typeFeedback": MessageLookupByLibrary.simpleMessage("在此输入你的反馈…"),
    "ukraine": MessageLookupByLibrary.simpleMessage("乌克兰"),
    "unableToConnectToPaymentProcesor": MessageLookupByLibrary.simpleMessage("无法连接支付处理器！请重试。"),
    "unauthenticatedBannerTitle": MessageLookupByLibrary.simpleMessage("你尚未登录"),
    "unauthenticatedSettingSubtitle": MessageLookupByLibrary.simpleMessage("登录以访问账户并解锁所有功能"),
    "unauthenticatedSettingTitle": MessageLookupByLibrary.simpleMessage("你尚未登录"),
    "unprotectedLbl": MessageLookupByLibrary.simpleMessage("未受保护"),
    "unstableSpeedReason": MessageLookupByLibrary.simpleMessage("速度不稳定"),
    "updateBtn": MessageLookupByLibrary.simpleMessage("更新"),
    "userIntentBestSpeed": MessageLookupByLibrary.simpleMessage("最佳速度"),
    "userIntentBestSpeedDesc": MessageLookupByLibrary.simpleMessage("连接到最快的可用服务器，获得最佳性能"),
    "userIntentLabel": MessageLookupByLibrary.simpleMessage("专用服务器"),
    "userIntentLowLatency": MessageLookupByLibrary.simpleMessage("低延迟"),
    "userIntentLowLatencyDesc": MessageLookupByLibrary.simpleMessage("自动为你连接到最近的服务器，实现稳定可靠的访问"),
    "userIntentMaxPrivacy": MessageLookupByLibrary.simpleMessage("最大隐私"),
    "userIntentMaxPrivacyDesc": MessageLookupByLibrary.simpleMessage("根据国家/地区获取言论自由和速度选项最佳的服务器"),
    "userIntentNearestLocation": MessageLookupByLibrary.simpleMessage("最近的位置"),
    "userIntentNearestLocationDesc": MessageLookupByLibrary.simpleMessage(
      "根据你当前位置，为你连接到最近的可用 VPN IP，获得最佳速度和性能",
    ),
    "userIntentP2P": MessageLookupByLibrary.simpleMessage("P2P"),
    "userIntentP2PDesc": MessageLookupByLibrary.simpleMessage("选择最适合安全加密交易、文件共享、游戏主机和通信的服务器"),
    "userIntentStreaming": MessageLookupByLibrary.simpleMessage("Streaming"),
    "userIntentStreamingDesc": MessageLookupByLibrary.simpleMessage("访问特定地区平台上你喜爱的节目和电影"),
    "viewAllFeaturesBtn": MessageLookupByLibrary.simpleMessage("查看所有功能"),
    "viewLessBtn": MessageLookupByLibrary.simpleMessage("收起"),
    "vodafoneLbl": MessageLookupByLibrary.simpleMessage("Vodafone Iberia"),
    "vpnProtocolSettingLbl": MessageLookupByLibrary.simpleMessage("VPN 协议"),
    "year": MessageLookupByLibrary.simpleMessage("年"),
    "yearly": MessageLookupByLibrary.simpleMessage("每年"),
    "yes": MessageLookupByLibrary.simpleMessage("是"),
    "zh": MessageLookupByLibrary.simpleMessage("中文"),
  };
}
