// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'divider_tile_dc.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DividerTileDCAdapter extends TypeAdapter<DividerTileDC> {
  @override
  final int typeId = 10;

  @override
  DividerTileDC read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DividerTileDC(
      uid: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DividerTileDC obj) {
    writer
      ..writeByte(1)
      ..writeByte(0)
      ..write(obj.uid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DividerTileDCAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
