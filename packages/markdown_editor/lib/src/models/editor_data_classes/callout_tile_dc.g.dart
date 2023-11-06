// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'callout_tile_dc.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class CalloutTileDCAdapter extends TypeAdapter<CalloutTileDC> {
  @override
  final int typeId = 9;

  @override
  CalloutTileDC read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return CalloutTileDC(
      uid: fields[3] as String,
      charTiles: (fields[0] as List).cast<CharTileDC>(),
      tileColor: fields[1] as int,
      iconString: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, CalloutTileDC obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.charTiles)
      ..writeByte(1)
      ..write(obj.tileColor)
      ..writeByte(2)
      ..write(obj.iconString)
      ..writeByte(3)
      ..write(obj.uid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CalloutTileDCAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
