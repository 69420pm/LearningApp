// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'text_editor_bloc.dart';

abstract class TextEditorState  extends Equatable  {}

class TextEditorInitial extends TextEditorState {
  @override
  List<Object?> get props => [runtimeType];
}

class TextEditorKeyboardRowChanged extends TextEditorState {
  @override
  List<Object?> get props => [runtimeType];
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

enum TextColor {
  white,
  white60,
  white38,
  brown,
  orange,
  yellow,
  green,
  blue,
  purple,
  pink,
  red,
}

enum TextBackgroundColor {
  noBG,
  white60BG,
  white38BG,
  brownBG,
  orangeBG,
  yellowBG,
  greenBG,
  blueBG,
  purpleBG,
  pinkBG,
  redBG
}
