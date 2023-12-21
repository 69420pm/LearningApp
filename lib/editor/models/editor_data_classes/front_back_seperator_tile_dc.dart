import 'package:hive/hive.dart';
import 'package:learning_app/editor/models/editor_data_classes/editor_tile_dc.dart';

part 'front_back_seperator_tile_dc.g.dart'; // Add this line

@HiveType(typeId: 15) // Change the typeId accordingly
class FrontBackSeparatorTileDC extends EditorTileDC {
  FrontBackSeparatorTileDC({required this.uid}) : super(uid:uid);
@HiveField(0)
  @override
  String uid;
  @override
  List<Object?> get props => [];
}
