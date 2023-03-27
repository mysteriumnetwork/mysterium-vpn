import 'package:hive/hive.dart';
import 'package:mysterium_vpn/common/extensions/extensions.dart';

part 'user_data.g.dart';

@HiveType(typeId: 1)
class UserData {
  UserData({
    required this.userId,
    required this.recentLocations,
    this.emailCommunication = Approval.notSet,
    this.notifications = Approval.notSet,
    this.subscriptionPlan,
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

  @override
  String toString() => '''
UserData : 
userId: $userId,
emailCommunicationApproval: ${emailCommunication.value},
recentLocations: $recentLocations,
notificationsApproval: ${notifications.value},
subscriptionPlan: $subscriptionPlan,
subscriptionPurchaseId: $subscriptionPurchaseId''';
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
