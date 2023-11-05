// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'front_back_seperator_tile_dc.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class FrontBackSeparatorTileDCAdapter
    extends TypeAdapter<FrontBackSeparatorTileDC> {
  @override
  final int typeId = 15;

  @override
  FrontBackSeparatorTileDC read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FrontBackSeparatorTileDC(
      uid: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, FrontBackSeparatorTileDC obj) {
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
      other is FrontBackSeparatorTileDCAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
