// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'class_test.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ClassTestAdapter extends TypeAdapter<ClassTest> {
  @override
  final int typeId = 3;

  @override
  ClassTest read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ClassTest(
      uid: fields[0] as String,
      name: fields[1] as String,
      date: fields[2] as DateTime,
      folderIds: (fields[3] as List).cast<String>(),
    );
  }

  @override
  void write(BinaryWriter writer, ClassTest obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.folderIds);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ClassTestAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
