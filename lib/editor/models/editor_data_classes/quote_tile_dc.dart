import 'package:hive/hive.dart';
import 'package:learning_app/editor/models/editor_data_classes/char_tile_dc.dart';
import 'package:learning_app/editor/models/editor_data_classes/editor_tile_dc.dart';

part 'quote_tile_dc.g.dart'; // Add this line

@HiveType(typeId: 14) // Change the typeId accordingly
class QuoteTileDC extends EditorTileDC {
  QuoteTileDC({
    required this.uid,
    required this.charTiles,
  }) : super(uid:uid);
  @HiveField(0)
  List<CharTileDC> charTiles;
@HiveField(1)
  @override
  String uid;

  @override
  List<Object?> get props => [charTiles];
}
