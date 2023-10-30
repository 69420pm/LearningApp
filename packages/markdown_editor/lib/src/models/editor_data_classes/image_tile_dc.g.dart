// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'image_tile_dc.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ImageTileDCAdapter extends TypeAdapter<ImageTileDC> {
  @override
  final int typeId = 11;

  @override
  ImageTileDC read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ImageTileDC(
      uid: fields[3] as String,
      filePath: fields[0] as String,
      scale: fields[1] as double,
      alignment: fields[2] as int,
    );
  }

  @override
  void write(BinaryWriter writer, ImageTileDC obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.filePath)
      ..writeByte(1)
      ..write(obj.scale)
      ..writeByte(2)
      ..write(obj.alignment)
      ..writeByte(3)
      ..write(obj.uid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ImageTileDCAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
