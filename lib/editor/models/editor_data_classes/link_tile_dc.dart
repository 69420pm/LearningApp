import 'package:hive/hive.dart';
import 'package:learning_app/editor/models/editor_data_classes/editor_tile_dc.dart';

part 'link_tile_dc.g.dart'; // Add this line

@HiveType(typeId: 16) // Change the typeId accordingly
class LinkTileDC extends EditorTileDC {
  LinkTileDC({
    required this.uid,
    required this.cardId,
  }) : super(uid:uid);
  @HiveField(0)
  String cardId;
@HiveField(1)
  @override
  String uid;

  @override
  List<Object?> get props => [cardId];
}
