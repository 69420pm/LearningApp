import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'editor_state.dart';

class EditorCubit extends Cubit<EditorState> {
  EditorCubit() : super(EditorInitial());

  bool isBold = false;
  bool isItalic = false;
  bool isUnderlined = false;

  void changeFormatting(Set<FormatType> set) {
    if (set.contains(FormatType.bold)) {
      isBold = true;
    } else {
      isBold = false;
    }

    if (set.contains(FormatType.italic)) {
      isItalic = true;
    } else {
      isItalic = false;
    }

    if (set.contains(FormatType.underlined)) {
      isUnderlined = true;
    } else {
      isUnderlined = false;
    }
  }
}

enum FormatType { bold, italic, underlined, strikethrough }
