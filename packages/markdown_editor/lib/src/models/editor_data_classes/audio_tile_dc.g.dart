// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'audio_tile_dc.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class AudioTileDCAdapter extends TypeAdapter<AudioTileDC> {
  @override
  final int typeId = 8;

  @override
  AudioTileDC read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return AudioTileDC(
      uid: fields[1] as String,
      filePath: fields[0] as String,
    );
  }

  @override
  void write(BinaryWriter writer, AudioTileDC obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.filePath)
      ..writeByte(1)
      ..write(obj.uid);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is AudioTileDCAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
