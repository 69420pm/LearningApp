import 'package:hive/hive.dart';
import 'package:learning_app/editor/models/editor_data_classes/editor_tile_dc.dart';

part 'latex_tile_dc.g.dart'; // Add this line

@HiveType(typeId: 12) // Change the typeId accordingly
class LatexTileDC extends EditorTileDC {
  LatexTileDC({
    required this.uid,
    required this.latexText,
  }) : super(uid:uid);
  @HiveField(0)
  String latexText;
@HiveField(1)
  @override
  String uid;

  @override
  List<Object?> get props => [latexText];
}