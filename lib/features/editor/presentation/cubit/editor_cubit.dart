import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:learning_app/features/editor/presentation/editor_input_formatter.dart';
import 'package:learning_app/features/editor/presentation/editor_text_field_manager.dart';

part 'editor_state.dart';

class EditorCubit extends Cubit<EditorState> {
  EditorCubit() : super(EditorInitial());

  bool isBold = false;
  bool isItalic = false;
  bool isUnderlined = false;

  // EditorTextFieldManager editorTextFieldManager = EditorTextFieldManager();
  // EditorInputFormatter inputFormatter = EditorInputFormatter(em: editorTextFieldManager, editorCubit: this);

  LineFormatType currentLineFormat = LineFormatType.body;
  late EditorInputFormatter inputFormatter;

  void changeFormatting(Set<SpanFormatType> set) {
    List<SpanFormatType> newStyle = [];
    if (set.contains(SpanFormatType.bold)) {
      newStyle.add(SpanFormatType.bold);
    }
    if (set.contains(SpanFormatType.italic)) {
      newStyle.add(SpanFormatType.italic);
    }
    if (set.contains(SpanFormatType.underlined)) {
      newStyle.add(SpanFormatType.underlined);
    }
    if (set.contains(SpanFormatType.strikethrough)) {
      newStyle.add(SpanFormatType.strikethrough);
    }
    if (set.contains(SpanFormatType.subscript)) {
      newStyle.add(SpanFormatType.subscript);
    } else if (set.contains(SpanFormatType.superscript)) {
      newStyle.add(SpanFormatType.superscript);
    }
    if (inputFormatter.currentStyle == newStyle) {
      return;
    }
    inputFormatter.currentStyle = newStyle;
    inputFormatter.changeLineFormat();
    emit(EditorTextFormattingChanged(textFormatSelection: set));
  }

  void changeLineFormat(LineFormatType lineFormatType,
      {bool updateCurrentLine = true}) {
    if (currentLineFormat == lineFormatType) {
      return;
    }
    currentLineFormat = lineFormatType;
    if (updateCurrentLine) {
      inputFormatter.changeLineStyleAccordingToSelection(lineFormatType);
    }
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
