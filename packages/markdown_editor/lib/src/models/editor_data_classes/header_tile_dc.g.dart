// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'header_tile_dc.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HeaderTileDCAdapter extends TypeAdapter<HeaderTileDC> {
  @override
  final int typeId = 7;

  @override
  HeaderTileDC read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HeaderTileDC(
      uid: fields[2] as String,
      charTiles: (fields[0] as List).cast<CharTile>(),
      headerSize: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, HeaderTileDC obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.charTiles)
      ..writeByte(1)
      ..write(obj.headerSize)
      ..writeByte(2)
      ..write(obj.uid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HeaderTileDCAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
