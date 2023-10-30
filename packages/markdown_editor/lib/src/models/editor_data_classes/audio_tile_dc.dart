import 'package:hive/hive.dart';
import 'package:markdown_editor/src/models/editor_data_classes/editor_tile_dc.dart';

part 'audio_tile_dc.g.dart'; // Add this line

@HiveType(typeId: 8) // Change the typeId accordingly
class AudioTileDC extends EditorTileDC {
  @HiveField(0)
  String filePath;
@HiveField(1)
  @override
  String uid;
  AudioTileDC({
    required this.uid,
    required this.filePath,
  }) : super(uid:uid);

  @override
  List<Object?> get props => [uid, filePath];
}