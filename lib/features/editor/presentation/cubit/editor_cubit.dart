import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:learning_app/features/editor/presentation/editor_text_field_manager.dart';

part 'editor_state.dart';

class EditorCubit extends Cubit<EditorState> {
  EditorCubit() : super(EditorInitial());

  bool isBold = false;
  bool isItalic = false;
  bool isUnderlined = false;

  LineFormatType currentLineFormat = LineFormatType.body;

  void changeFormatting(Set<SpanFormatType> set) {
    if (set.contains(SpanFormatType.bold)) {
      isBold = true;
    } else {
      isBold = false;
    }

    if (set.contains(SpanFormatType.italic)) {
      isItalic = true;
    } else {
      isItalic = false;
    }

    if (set.contains(SpanFormatType.underlined)) {
      isUnderlined = true;
    } else {
      isUnderlined = false;
    }
    emit(EditorTextFormattingChanged(textFormatSelection: set));
  }

  void changeLineFormat(LineFormatType lineFormatType) {
    currentLineFormat = lineFormatType;
    emit(EditorLineFormattingChanged(lineFormatType: lineFormatType));
  }
}

// enum TextFormatType { bold, italic, underlined, strikethrough }

// enum LineFormatType {
//   heading,
//   subheading,
//   body,
//   monostyled,
//   bulleted_list,
//   numbered_list,
//   dashed_list
// }
