// ignore_for_file: deprecated_member_use_from_same_package, deprecated_consistency

import 'package:flutter/widgets.dart';
import 'package:hive_ce/hive.dart';
import 'package:mysterium_vpn/common/enums/enums.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';
import 'package:mysterium_vpn/models/models.dart';

part 'user_data.g.dart';

@HiveType(typeId: 1)
class UserData {
  UserData({
    required this.userId,
    // TODO(david): remove at a certain point
    required this.recentVPNLocations,
    this.emailCommunication = Approval.notSet,
    this.notifications = Approval.notSet,
    this.subscriptionPlan,
    this.refreshIPConnection = true,
    this.malwareContentBlocker = false,
    this.notSafeContentBlocker = false,
    this.vpnPrivacyPolicyConsent = false,
    this.subscriptionPurchaseId,
    this.shownBanners = const [],
    this.recentLocationCodes = const [],
    this.marketingConsentShown = false,
    this.protocolType = ProtocolType.wireguard,
    this.pushNotificationsPromptLastShownAt,
    this.appOpenCount = 0,
    this.noneSubsOnboardingShown = false,
  });

  @HiveField(0)
  String userId;

  @Deprecated('Removed')
  @HiveField(1)
  Approval emailCommunication;

  @HiveField(2)
  @Deprecated('use recentLocations instead')
  @protected
  List<String> recentLocationCodes;

  @Deprecated('Removed')
  @HiveField(3)
  Approval notifications;

  @HiveField(4)
  String? subscriptionPlan;

  @HiveField(5)
  String? subscriptionPurchaseId;

  @HiveField(7, defaultValue: true)
  bool refreshIPConnection;

  @HiveField(8, defaultValue: false)
  bool malwareContentBlocker;

  @HiveField(9, defaultValue: false)
  bool notSafeContentBlocker;

  @HiveField(10, defaultValue: false)
  bool vpnPrivacyPolicyConsent;

  @HiveField(11, defaultValue: <VPNLocation>[])
  @protected
  List<VPNLocation> recentVPNLocations;

  @HiveField(12, defaultValue: <BannerType>[])
  List<BannerType> shownBanners;

  @HiveField(13, defaultValue: false)
  bool marketingConsentShown;

  @HiveField(14, defaultValue: ProtocolType.wireguard)
  ProtocolType protocolType;

  @HiveField(15)
  DateTime? pushNotificationsPromptLastShownAt;

  @HiveField(16, defaultValue: 0)
  int appOpenCount;

  @HiveField(17, defaultValue: false)
  bool noneSubsOnboardingShown;

  set recentLocations(List<VPNLocation> locations) {
    recentVPNLocations = [
      ...locations,
      if (recentLocationCodes.isNotEmpty) ...recentLocationCodes.map(VPNLocation.fromCode),
    ].distinctBy((it) => (it.id, it.ipType)).toList();
    recentLocationCodes = [];
  }

  List<VPNLocation> get recentLocations => [
    ...recentLocationCodes.map(VPNLocation.fromCode),
    ...recentVPNLocations,
  ].distinctBy((it) => (it.id, it.ipType)).toList();

  @override
  String toString() =>
      '''
UserData : 
userId: $userId,
subscriptionPlan: $subscriptionPlan,
subscriptionPurchaseId: $subscriptionPurchaseId
resetConnection: $refreshIPConnection
malwareBlocker: $malwareContentBlocker
notSafeContentBlocker: $notSafeContentBlocker,
recentVPNLocations: $recentVPNLocations,
shownBanners: $shownBanners
notSafeContentBlocker: $notSafeContentBlocker
vpnPrivacyPolicyConsent: $vpnPrivacyPolicyConsent
recentLocationCodes: $recentLocationCodes
marketingConsentShown: $marketingConsentShown
protocolType: $protocolType
pushNotificationsPromptLastShownAt: $pushNotificationsPromptLastShownAt
noneSubsOnboardingShown: $noneSubsOnboardingShown
''';
}

@HiveType(typeId: 2)
enum Approval {
  @HiveField(0)
  approved,
  @HiveField(1)
  declined,
  @HiveField(2)
  notSet,
}
