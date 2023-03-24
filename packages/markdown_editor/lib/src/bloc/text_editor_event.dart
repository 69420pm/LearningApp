// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'text_editor_bloc.dart';

@immutable
abstract class TextEditorEvent {}

class TextEditorKeyboardRowChange extends TextEditorEvent {
  bool isBold;
  bool isItalic;
  bool isUnderlined;
  TextEditorKeyboardRowChange({
    required this.isBold,
    required this.isItalic,
    required this.isUnderlined,
  });
}





