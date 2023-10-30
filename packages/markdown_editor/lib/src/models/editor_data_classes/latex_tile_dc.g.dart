// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'latex_tile_dc.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LatexTileDCAdapter extends TypeAdapter<LatexTileDC> {
  @override
  final int typeId = 12;

  @override
  LatexTileDC read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LatexTileDC(
      uid: fields[1] as String,
      latexText: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, LatexTileDC obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.latexText)
      ..writeByte(1)
      ..write(obj.uid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LatexTileDCAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
