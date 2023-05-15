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
  bool isCode;
  bool isDefaultOnBackgroundTextColor;
  Color textColor;
  Color textBackgroundColor;
  TextEditorKeyboardRowChanged({
    required this.isBold,
    required this.isItalic,
    required this.isUnderlined,
    required this.isCode,
    required this.isDefaultOnBackgroundTextColor,
    required this.textColor,
    required this.textBackgroundColor,
  });

  @override
  List<Object?> get props => [
        runtimeType,
        isBold,
        isItalic,
        isUnderlined,
        isCode,
        textColor,
        textBackgroundColor
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

  // @override
  // bool operator ==(Object other) {
  //   // if (identical(this, other)) {
  //   //   return true;
  //   // }
  //   if (other is TextEditorEditorTilesChanged) {
  //     if (other.tiles.length == tiles.length) {
  //       for (var i = 0; i < tiles.length; i++) {
  //         if (other.tiles[i] != tiles[i]) {
  //           return false;
  //         }
  //       }
  //       return true;
  //     } else {
  //       return false;
  //     }
  //   } else {
  //     return false;
  //   }
  // }

  @override
  int get hashCode => tiles.hashCode;
}
