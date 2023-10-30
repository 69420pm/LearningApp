// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'char_tile_dc.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CharTileDCAdapter extends TypeAdapter<CharTileDC> {
  @override
  final int typeId = 5;

  @override
  CharTileDC read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CharTileDC(
      text: fields[0] as String,
      start: fields[1] as int,
      end: fields[2] as int,
      isBold: fields[3] as bool,
      isItalic: fields[4] as bool,
      isUnderlined: fields[5] as bool,
      color: fields[6] as int,
    );
  }

  @override
  void write(BinaryWriter writer, CharTileDC obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.text)
      ..writeByte(1)
      ..write(obj.start)
      ..writeByte(2)
      ..write(obj.end)
      ..writeByte(3)
      ..write(obj.isBold)
      ..writeByte(4)
      ..write(obj.isItalic)
      ..writeByte(5)
      ..write(obj.isUnderlined)
      ..writeByte(6)
      ..write(obj.color);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CharTileDCAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
