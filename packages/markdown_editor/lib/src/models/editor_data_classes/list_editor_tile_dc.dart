import 'package:hive/hive.dart';
import 'package:markdown_editor/src/models/char_tile.dart';
import 'package:markdown_editor/src/models/editor_data_classes/char_tile_dc.dart';
import 'package:markdown_editor/src/models/editor_data_classes/editor_tile_dc.dart';

part 'list_editor_tile_dc.g.dart'; // Add this line

@HiveType(typeId: 13) // Change the typeId accordingly
class ListEditorTileDC extends EditorTileDC {
  @HiveField(0)
  List<CharTileDC> charTiles;

  @HiveField(1)
  int orderNumber;
@HiveField(2)
  @override
  String uid;
  ListEditorTileDC({
    required this.uid,
    required this.charTiles,
    required this.orderNumber,
  }) : super(uid:uid);

  @override
  List<Object?> get props => [charTiles, orderNumber];
}