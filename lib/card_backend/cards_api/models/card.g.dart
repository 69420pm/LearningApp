// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'card.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CardAdapter extends TypeAdapter<Card> {
  @override
  final int typeId = 4;

  @override
  Card read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Card(
      uid: fields[0] as String,
      dateCreated: fields[1] as DateTime,
      askCardsInverted: fields[2] as bool,
      typeAnswer: fields[3] as bool,
      recallScore: fields[4] as int,
      dateToReview: fields[5] as DateTime,
      name: fields[6] as String,
    );
  }

  @override
  void write(BinaryWriter writer, Card obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.uid)
      ..writeByte(1)
      ..write(obj.dateCreated)
      ..writeByte(2)
      ..write(obj.askCardsInverted)
      ..writeByte(3)
      ..write(obj.typeAnswer)
      ..writeByte(4)
      ..write(obj.recallScore)
      ..writeByte(5)
      ..write(obj.dateToReview)
      ..writeByte(6)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CardAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
