// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'calendar_day.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CalendarDayAdapter extends TypeAdapter<CalendarDay> {
  @override
  final int typeId = 17;

  @override
  CalendarDay read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CalendarDay(
      uid: fields[0] as String,
      date: fields[1] as DateTime,
      learnedCardsIds: (fields[2] as List).cast<String>(),
      streakCompleted: fields[3] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, CalendarDay obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.date)
      ..writeByte(2)
      ..write(obj.learnedCardsIds)
      ..writeByte(3)
      ..write(obj.streakCompleted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalendarDayAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
