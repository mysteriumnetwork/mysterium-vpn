// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserDataAdapter extends TypeAdapter<UserData> {
  @override
  final int typeId = 1;

  @override
  UserData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserData(
      userId: fields[0] as String,
      recentLocations: (fields[2] as List).cast<String>(),
      emailCommunication: fields[1] as Approval,
      notifications: fields[3] as Approval,
      subscriptionPlan: fields[4] as String?,
      vpnConfigConsent: fields[6] as bool?,
      refreshIPConnection: fields[7] == null ? true : fields[7] as bool,
    )..subscriptionPurchaseId = fields[5] as String?;
  }

  @override
  void write(BinaryWriter writer, UserData obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.userId)
      ..writeByte(1)
      ..write(obj.emailCommunication)
      ..writeByte(2)
      ..write(obj.recentLocations)
      ..writeByte(3)
      ..write(obj.notifications)
      ..writeByte(4)
      ..write(obj.subscriptionPlan)
      ..writeByte(5)
      ..write(obj.subscriptionPurchaseId)
      ..writeByte(6)
      ..write(obj.vpnConfigConsent)
      ..writeByte(7)
      ..write(obj.refreshIPConnection);
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
  final int typeId = 2;

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
        break;
      case Approval.declined:
        writer.writeByte(1);
        break;
      case Approval.notSet:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ApprovalAdapter && runtimeType == other.runtimeType && typeId == other.typeId;
}
