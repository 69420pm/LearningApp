import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:learning_app/features/file_system/data/models/card_model.dart';

part 'learn_event.dart';
part 'learn_state.dart';

class LearnBloc extends Bloc<LearnEvent, LearnState> {
  LearnBloc() : super(LearnInitial()) {
    on<LearnEvent>((event, emit) {
      // TODO: implement event handler
    });
  }
}
