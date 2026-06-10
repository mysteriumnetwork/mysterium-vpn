// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserDataAdapter extends TypeAdapter<UserData> {
  @override
  final typeId = 1;

  @override
  UserData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserData(
      userId: fields[0] as String,
      recentVPNLocations: fields[11] == null ? [] : (fields[11] as List).cast<VPNLocation>(),
      emailCommunication: fields[1] == null ? Approval.notSet : fields[1] as Approval,
      notifications: fields[3] == null ? Approval.notSet : fields[3] as Approval,
      subscriptionPlan: fields[4] as String?,
      refreshIPConnection: fields[7] == null ? true : fields[7] as bool,
      malwareContentBlocker: fields[8] == null ? false : fields[8] as bool,
      notSafeContentBlocker: fields[9] == null ? false : fields[9] as bool,
      vpnPrivacyPolicyConsent: fields[10] == null ? false : fields[10] as bool,
      subscriptionPurchaseId: fields[5] as String?,
      shownBanners: fields[12] == null ? [] : (fields[12] as List).cast<BannerType>(),
      recentLocationCodes: fields[2] == null ? const [] : (fields[2] as List).cast<String>(),
      marketingConsentShown: fields[13] == null ? false : fields[13] as bool,
      protocolType: fields[14] == null ? ProtocolType.wireguard : fields[14] as ProtocolType,
      pushNotificationsPromptLastShownAt: fields[15] as DateTime?,
      appOpenCount: fields[16] == null ? 0 : (fields[16] as num).toInt(),
      noneSubsOnboardingCompleted: fields[17] == null ? false : fields[17] as bool,
      noneSubsOnboardingStep: fields[18] == null ? 0 : (fields[18] as num).toInt(),
      residentialEducationModalShown: fields[19] == null ? false : fields[19] as bool,
      residentialReminderShownAt: fields[20] as DateTime?,
      residentialConnectCount: fields[21] == null ? 0 : (fields[21] as num).toInt(),
    );
  }

  @override
  void write(BinaryWriter writer, UserData obj) {
    writer
      ..writeByte(21)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.emailCommunication)
      ..writeByte(2)
      ..write(obj.recentLocationCodes)
      ..writeByte(3)
      ..write(obj.notifications)
      ..writeByte(4)
      ..write(obj.subscriptionPlan)
      ..writeByte(5)
      ..write(obj.subscriptionPurchaseId)
      ..writeByte(7)
      ..write(obj.refreshIPConnection)
      ..writeByte(8)
      ..write(obj.malwareContentBlocker)
      ..writeByte(9)
      ..write(obj.notSafeContentBlocker)
      ..writeByte(10)
      ..write(obj.vpnPrivacyPolicyConsent)
      ..writeByte(11)
      ..write(obj.recentVPNLocations)
      ..writeByte(12)
      ..write(obj.shownBanners)
      ..writeByte(13)
      ..write(obj.marketingConsentShown)
      ..writeByte(14)
      ..write(obj.protocolType)
      ..writeByte(15)
      ..write(obj.pushNotificationsPromptLastShownAt)
      ..writeByte(16)
      ..write(obj.appOpenCount)
      ..writeByte(17)
      ..write(obj.noneSubsOnboardingCompleted)
      ..writeByte(18)
      ..write(obj.noneSubsOnboardingStep)
      ..writeByte(19)
      ..write(obj.residentialEducationModalShown)
      ..writeByte(20)
      ..write(obj.residentialReminderShownAt)
      ..writeByte(21)
      ..write(obj.residentialConnectCount);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserDataAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}

class ApprovalAdapter extends TypeAdapter<Approval> {
  @override
  final typeId = 2;

  @override
  Approval read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Approval.approved;
      case 1:
        return Approval.declined;
      case 2:
        return Approval.notSet;
      default:
        return Approval.approved;
    }
  }

  @override
  void write(BinaryWriter writer, Approval obj) {
    switch (obj) {
      case Approval.approved:
        writer.writeByte(0);
      case Approval.declined:
        writer.writeByte(1);
      case Approval.notSet:
        writer.writeByte(2);
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApprovalAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
