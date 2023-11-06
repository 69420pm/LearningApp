// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'text_editor_bloc.dart';

abstract class TextEditorState extends Equatable {}

class TextEditorInitial extends TextEditorState {
  @override
  List<Object?> get props => [runtimeType];
}

class TextEditorKeyboardRowChanged extends TextEditorState {
  bool isBold;
  bool isItalic;
  bool isUnderlined;
  Color textColor;
  Color textBackgroundColor;
  TextEditorKeyboardRowChanged({
    required this.isBold,
    required this.isItalic,
    required this.isUnderlined,
    required this.textColor,
    required this.textBackgroundColor,
  });

  @override
  List<Object?> get props => [
        runtimeType,
        isBold,
        isItalic,
        isUnderlined,
        textColor,
        textBackgroundColor,
        ];
}

class TextEditorEditorTilesChanged extends TextEditorState {
  List<EditorTile> tiles;
  TextEditorEditorTilesChanged({
    required this.tiles,
  });
  @override
  List<Object?> get props {
    return [tiles];
  }


  @override
  int get hashCode => tiles.hashCode;
}
