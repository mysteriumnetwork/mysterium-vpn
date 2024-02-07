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
    this.vpnConfigConsent,
    this.refreshIPConnection = true,
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

  @HiveField(6)
  bool? vpnConfigConsent;

  @HiveField(7, defaultValue: true)
  bool refreshIPConnection;

  @override
  String toString() => '''
UserData : 
userId: $userId,
emailCommunicationApproval: ${emailCommunication.name},
recentLocations: $recentLocations,
notificationsApproval: ${notifications.name},
subscriptionPlan: $subscriptionPlan,
subscriptionPurchaseId: $subscriptionPurchaseId
vpnConfigConsent: $vpnConfigConsent
resetConnection: $refreshIPConnection
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
