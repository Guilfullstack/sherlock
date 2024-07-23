// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'stage.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class StageAdapter extends TypeAdapter<Stage> {
  @override
  final int typeId = 1;

  @override
  Stage read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Stage(
      id: fields[0] as String?,
      token: fields[1] as String?,
      category: fields[2] as Category?,
      description: fields[3] as String?,
      puzzle: fields[4] as String?,
      date: fields[5] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Stage obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.token)
      ..writeByte(2)
      ..write(obj.category)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.puzzle)
      ..writeByte(5)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is StageAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
