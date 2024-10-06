// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_team.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserTeamAdapter extends TypeAdapter<UserTeam> {
  @override
  final int typeId = 0;

  @override
  UserTeam read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserTeam(
      id: fields[0] as String?,
      login: fields[1] as String?,
      password: fields[2] as String?,
      name: fields[3] as String?,
      date: fields[4] as DateTime?,
      status: fields[5] as Status?,
      credit: fields[6] as double?,
      listTokenDesbloqued: (fields[7] as List?)?.cast<String>(),
      listMembers: (fields[8] as List?)?.cast<dynamic>(),
      useCardFrezee: fields[9] as bool?,
      useCardProtect: fields[10] as bool?,
      isLoged: fields[11] as bool?,
      isPrisionBreak: fields[12] as bool?,
      isPayCardFrezee: fields[13] as bool?,
      isPayCardProtected: fields[14] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, UserTeam obj) {
    writer
      ..writeByte(15)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.login)
      ..writeByte(2)
      ..write(obj.password)
      ..writeByte(3)
      ..write(obj.name)
      ..writeByte(4)
      ..write(obj.date)
      ..writeByte(5)
      ..write(obj.status)
      ..writeByte(6)
      ..write(obj.credit)
      ..writeByte(7)
      ..write(obj.listTokenDesbloqued)
      ..writeByte(8)
      ..write(obj.listMembers)
      ..writeByte(9)
      ..write(obj.useCardFrezee)
      ..writeByte(10)
      ..write(obj.useCardProtect)
      ..writeByte(11)
      ..write(obj.isLoged)
      ..writeByte(12)
      ..write(obj.isPrisionBreak)
      ..writeByte(13)
      ..write(obj.isPayCardFrezee)
      ..writeByte(14)
      ..write(obj.isPayCardProtected);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserTeamAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class StatusAdapter extends TypeAdapter<Status> {
  @override
  final int typeId = 1;

  @override
  Status read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Status.Jogando;
      case 1:
        return Status.Congelado;
      case 2:
        return Status.Protegido;
      default:
        return Status.Jogando;
    }
  }

  @override
  void write(BinaryWriter writer, Status obj) {
    switch (obj) {
      case Status.Jogando:
        writer.writeByte(0);
        break;
      case Status.Congelado:
        writer.writeByte(1);
        break;
      case Status.Protegido:
        writer.writeByte(2);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StatusAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
