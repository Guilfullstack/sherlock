// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'code.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CodeAdapter extends TypeAdapter<Code> {
  @override
  final int typeId = 2;

  @override
  Code read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Code(
      id: fields[0] as String?,
      token: fields[1] as String?,
      category: fields[2] as Category?,
      description: fields[3] as String?,
      puzzle: fields[4] as String?,
      value: fields[5] as double?,
      date: fields[6] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, Code obj) {
    writer
      ..writeByte(7)
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
      ..write(obj.value)
      ..writeByte(6)
      ..write(obj.date);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CodeAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class CategoryAdapter extends TypeAdapter<Category> {
  @override
  final int typeId = 3;

  @override
  Category read(BinaryReader reader) {
    switch (reader.readByte()) {
      case 0:
        return Category.freezing;
      case 1:
        return Category.protect;
      case 2:
        return Category.pay;
      case 3:
        return Category.receive;
      case 4:
        return Category.stage;
      default:
        return Category.freezing;
    }
  }

  @override
  void write(BinaryWriter writer, Category obj) {
    switch (obj) {
      case Category.freezing:
        writer.writeByte(0);
        break;
      case Category.protect:
        writer.writeByte(1);
        break;
      case Category.pay:
        writer.writeByte(2);
        break;
      case Category.receive:
        writer.writeByte(3);
        break;
      case Category.stage:
        writer.writeByte(4);
        break;
    }
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
