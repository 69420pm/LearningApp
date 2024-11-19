import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'editor_event.dart';
part 'editor_state.dart';

class EditorBloc extends Bloc<EditorEvent, EditorState> {
  EditorBloc() : super(EditorInitial()) {
    on<EditorEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
