import 'package:hive/hive.dart';
import 'package:markdown_editor/src/models/editor_data_classes/editor_tile_dc.dart';

part 'image_tile_dc.g.dart'; // Add this line

@HiveType(typeId: 11) // Change the typeId accordingly
class ImageTileDC extends EditorTileDC {

  ImageTileDC({
    required this.uid,
    required this.filePath,
    required this.scale,
    required this.alignment,
  }) : super(uid:uid);
  @HiveField(0)
  String filePath;

  @HiveField(1)
  double scale;

  @HiveField(2)
  int alignment;

@HiveField(3)
  @override
  String uid;

  @override
  List<Object?> get props => [filePath, scale, alignment];
}