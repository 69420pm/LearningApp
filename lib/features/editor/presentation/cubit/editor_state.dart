part of 'editor_cubit.dart';

sealed class EditorState extends Equatable {
  const EditorState();

  @override
  List<Object> get props => [];
}

final class EditorInitial extends EditorState {}

final class EditorTextFormattingChanged extends EditorState {
  final Set<TextFormatType> textFormatSelection;

  EditorTextFormattingChanged({required this.textFormatSelection});
  @override
  List<Object> get props => [textFormatSelection];
}

final class EditorLineFormattingChanged extends EditorState {
  final LineFormatType lineFormatType;
  EditorLineFormattingChanged({required this.lineFormatType});
  @override
  // TODO: implement props
  List<Object> get props => [lineFormatType];
}
