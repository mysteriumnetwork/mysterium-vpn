import 'package:hive/hive.dart';

part 'user_data.g.dart';

@HiveType(typeId: 1)
class UserData {
  UserData({
    required this.userId,
    required this.recentLocations,
    this.emailCommunication = Approval.notSet,
    this.notifications = Approval.notSet,
    this.subscriptionPlan,
    this.refreshIPConnection = true,
    this.malwareBlocker = false,
    this.notSafeContentBlocker = false,
    this.vpnPrivacyPolicyConsent = false,
  });
  @HiveField(0)
  String userId;

  @HiveField(1)
  Approval emailCommunication;

  @HiveField(2)
  List<String> recentLocations;

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

  @override
  String toString() => '''
UserData : 
userId: $userId,
emailCommunicationApproval: ${emailCommunication.name},
recentLocations: $recentLocations,
notificationsApproval: ${notifications.name},
subscriptionPlan: $subscriptionPlan,
subscriptionPurchaseId: $subscriptionPurchaseId
resetConnection: $refreshIPConnection
malwareBlocker: $malwareBlocker
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
