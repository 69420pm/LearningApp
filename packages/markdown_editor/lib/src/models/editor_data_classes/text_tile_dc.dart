import 'package:markdown_editor/src/models/char_tile.dart';
import 'package:markdown_editor/src/models/editor_data_classes/editor_tile_dc.dart';

/// matching data class to TextTile
class TextTileDC extends EditorTileDC {
  TextTileDC({required super.uid});

  // charTiles of text
  Map<int, CharTile> charTiles = {};

  @override
  List<Object?> get props => [charTiles];
}
