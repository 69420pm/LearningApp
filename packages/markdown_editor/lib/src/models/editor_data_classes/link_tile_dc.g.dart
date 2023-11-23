// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'link_tile_dc.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LinkTileDCAdapter extends TypeAdapter<LinkTileDC> {
  @override
  final int typeId = 16;

  @override
  LinkTileDC read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LinkTileDC(
      uid: fields[1] as String,
      cardId: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LinkTileDC obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.cardId)
      ..writeByte(1)
      ..write(obj.uid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LinkTileDCAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
