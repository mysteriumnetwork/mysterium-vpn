// ignore_for_file: deprecated_member_use_from_same_package

import 'package:flutter/widgets.dart';
import 'package:hive/hive.dart';
import 'package:mysterium_vpn/common/enums/banner_type.dart';
import 'package:mysterium_vpn/models/location.dart';

part 'user_data.g.dart';

@HiveType(typeId: 1)
class UserData {
  UserData({
    required this.userId,
    // TODO(david): remove at a certain point
    // ignore: deprecated_consistency
    required this.recentLocationCodes,
    required this.recentVPNLocations,
    this.emailCommunication = Approval.notSet,
    this.notifications = Approval.notSet,
    this.subscriptionPlan,
    this.refreshIPConnection = true,
    this.malwareBlocker = false,
    this.notSafeContentBlocker = false,
    this.vpnPrivacyPolicyConsent = false,
    this.subscriptionPurchaseId,
    this.shownBanners = const [],
  });
  @HiveField(0)
  String userId;

  @HiveField(1)
  Approval emailCommunication;

  @HiveField(2)
  @Deprecated('use recentLocations instead')
  @protected
  List<String> recentLocationCodes;

  @HiveField(3)
  Approval notifications;

  @HiveField(4)
  String? subscriptionPlan;

  @HiveField(5)
  String? subscriptionPurchaseId;

  @HiveField(7, defaultValue: true)
  bool refreshIPConnection;

  @HiveField(8, defaultValue: false)
  bool malwareBlocker;

  @HiveField(9, defaultValue: false)
  bool notSafeContentBlocker;

  @HiveField(10, defaultValue: false)
  bool vpnPrivacyPolicyConsent;

  @HiveField(11, defaultValue: <VPNLocation>[])
  @protected
  List<VPNLocation> recentVPNLocations;

  @HiveField(12, defaultValue: <BannerType>[])
  List<BannerType> shownBanners;

  set recentLocations(List<VPNLocation> locations) {
    recentVPNLocations = [
      ...locations,
      if (recentLocationCodes.isNotEmpty)
        ...recentLocationCodes.map((code) => VPNLocation(code: code)),
    ];
    recentLocationCodes = [];
  }

  List<VPNLocation> get recentLocations => {
        ...recentLocationCodes.map((code) => VPNLocation(code: code)),
        ...recentVPNLocations,
      }.toList();

  @override
  String toString() => '''
UserData : 
userId: $userId,
emailCommunicationApproval: ${emailCommunication.name},
recentLocations: $recentLocationCodes,
notificationsApproval: ${notifications.name},
subscriptionPlan: $subscriptionPlan,
subscriptionPurchaseId: $subscriptionPurchaseId
resetConnection: $refreshIPConnection
malwareBlocker: $malwareBlocker
notSafeContentBlocker: $notSafeContentBlocker,
recentVPNLocations: $recentVPNLocations,
shownBanners: $shownBanners
notSafeContentBlocker: $notSafeContentBlocker
vpnPrivacyPolicyConsent: $vpnPrivacyPolicyConsent
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
