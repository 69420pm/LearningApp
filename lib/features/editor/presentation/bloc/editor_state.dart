part of 'editor_bloc.dart';

sealed class EditorState extends Equatable {
  const EditorState();
  
  @override
  List<Object> get props => [];
}

final class EditorInitial extends EditorState {}
