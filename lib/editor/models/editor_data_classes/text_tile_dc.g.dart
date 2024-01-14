// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_tile_dc.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class TextTileDCAdapter extends TypeAdapter<TextTileDC> {
  @override
  final int typeId = 6;

  @override
  TextTileDC read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return TextTileDC(
      uid: fields[1] as String,
      charTiles: (fields[0] as List).cast<CharTileDC>(),
    );
  }

  @override
  void write(BinaryWriter writer, TextTileDC obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.charTiles)
      ..writeByte(1)
      ..write(obj.uid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is TextTileDCAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
