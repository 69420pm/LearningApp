import 'package:markdown_editor/src/models/char_tile.dart';
import 'package:markdown_editor/src/models/editor_data_classes/editor_tile_dc.dart';
import 'package:hive/hive.dart';

part 'text_tile_dc.g.dart';
/// matching data class to TextTile
@HiveType(typeId: 6)
class TextTileDC extends EditorTileDC {
  TextTileDC({required this.uid, required this.charTiles}) : super(uid:uid);


  /// charTiles of text
  @HiveField(0)
  List<CharTile> charTiles;

  @HiveField(1)
  @override
  String uid;


  @override
  List<Object?> get props => [charTiles];
}
