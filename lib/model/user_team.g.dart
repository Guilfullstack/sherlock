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
    );
  }

  @override
  void write(BinaryWriter writer, UserTeam obj) {
    writer
      ..writeByte(7)
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
      ..write(obj.credit);
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
        return Status.Conjelado;
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
      case Status.Conjelado:
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
