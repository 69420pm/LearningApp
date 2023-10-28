// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'subject.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SubjectAdapter extends TypeAdapter<Subject> {
  @override
  final int typeId = 0;

  @override
  Subject read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Subject(
      uid: fields[0] as String,
      name: fields[1] as String,
      dateCreated: fields[2] as DateTime,
      icon: fields[3] as int,
      scheduledDays: (fields[4] as List).cast<bool>(),
      classTests: (fields[5] as List).cast<ClassTest>(),
      streakRelevant: fields[6] as bool,
      disabled: fields[7] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, Subject obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.dateCreated)
      ..writeByte(3)
      ..write(obj.icon)
      ..writeByte(4)
      ..write(obj.scheduledDays)
      ..writeByte(5)
      ..write(obj.classTests)
      ..writeByte(6)
      ..write(obj.streakRelevant)
      ..writeByte(7)
      ..write(obj.disabled);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SubjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
