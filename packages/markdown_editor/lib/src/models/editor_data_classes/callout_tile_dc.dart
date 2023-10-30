import 'package:hive/hive.dart';
import 'package:markdown_editor/src/models/char_tile.dart';
import 'package:markdown_editor/src/models/editor_data_classes/editor_tile_dc.dart';

part 'callout_tile_dc.g.dart'; // Add this line

@HiveType(typeId: 9) // Change the typeId accordingly
class CalloutTileDC extends EditorTileDC {
  @HiveField(0)
  List<CharTile> charTiles;

  @HiveField(1)
  int tileColor;

  @HiveField(2)
  String iconString;
@HiveField(3)
  @override
  String uid;
  CalloutTileDC({
    required this.uid,
    required this.charTiles,
    required this.tileColor,
    required this.iconString,
  }) : super(uid:uid);

  @override
  List<Object?> get props => [charTiles, tileColor, iconString];
}