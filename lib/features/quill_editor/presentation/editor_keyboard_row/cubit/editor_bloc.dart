import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_quill/flutter_quill.dart';
part 'editor_event.dart';
part 'editor_state.dart';

class EditorBloc extends Bloc<EditorEvent, EditorState> {
  EditorBloc({required this.controller}) : super(EditorInitial());
  QuillController controller;
  String? imagePath;
}
