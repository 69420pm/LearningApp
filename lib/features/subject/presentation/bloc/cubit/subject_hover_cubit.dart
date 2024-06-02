import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:learning_app/features/subject/presentation/bloc/cubit/subject_selection_cubit.dart';

part 'subject_hover_state.dart';

class SubjectHoverCubit extends Cubit<SubjectHoverState> {
  SubjectHoverCubit()
      : super(
          const SubjectHoverChanged(
            newId: "",
          ),
        );

  void changeHover(String newId) {
    emit(
      SubjectHoverChanged(
        newId: newId,
      ),
    );
  }
}
