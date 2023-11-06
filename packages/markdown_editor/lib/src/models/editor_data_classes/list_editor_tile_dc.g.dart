// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'list_editor_tile_dc.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ListEditorTileDCAdapter extends TypeAdapter<ListEditorTileDC> {
  @override
  final int typeId = 13;

  @override
  ListEditorTileDC read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ListEditorTileDC(
      uid: fields[2] as String,
      charTiles: (fields[0] as List).cast<CharTileDC>(),
      orderNumber: fields[1] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ListEditorTileDC obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.charTiles)
      ..writeByte(1)
      ..write(obj.orderNumber)
      ..writeByte(2)
      ..write(obj.uid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ListEditorTileDCAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
