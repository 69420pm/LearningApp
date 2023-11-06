// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'quote_tile_dc.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class QuoteTileDCAdapter extends TypeAdapter<QuoteTileDC> {
  @override
  final int typeId = 14;

  @override
  QuoteTileDC read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return QuoteTileDC(
      uid: fields[1] as String,
      charTiles: (fields[0] as List).cast<CharTileDC>(),
    );
  }

  @override
  void write(BinaryWriter writer, QuoteTileDC obj) {
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
      other is QuoteTileDCAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
