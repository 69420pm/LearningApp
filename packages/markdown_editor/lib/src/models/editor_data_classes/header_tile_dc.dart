import 'package:hive/hive.dart';
import 'package:markdown_editor/src/models/char_tile.dart';
import 'package:markdown_editor/src/models/editor_data_classes/char_tile_dc.dart';
import 'package:markdown_editor/src/models/editor_data_classes/editor_tile_dc.dart';

part 'header_tile_dc.g.dart'; // Add this line

@HiveType(typeId: 7) // Add this line
class HeaderTileDC extends EditorTileDC {
  @HiveField(0)
  List<CharTileDC> charTiles;

  /// whether it is heading big or heading small, 0 is small 1 is big
  @HiveField(1)
  int headerSize;
  
  @HiveField(2)
  @override
  String uid;

  HeaderTileDC({
    required this.uid,
    required this.charTiles,
    required this.headerSize,
  }) : super(uid: uid);

  @override
  List<Object?> get props => [charTiles, headerSize];
}
