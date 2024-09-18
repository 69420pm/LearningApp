import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/features/file_system/domain/usecases/get_parent_ids.dart';

import 'package:learning_app/features/subject/presentation/bloc/cubit/subject_selection_cubit.dart';

part 'subject_hover_state.dart';

class SubjectHoverCubit extends Cubit<SubjectHoverState> {
  SubjectHoverCubit()
      : super(
          const SubjectHoverChanged(
            newId: "",
          ),
        );
  var _isDragging = false;
  bool get isDragging => _isDragging;

  void endDrag() {
    _isDragging = false;
    emit(
      const SubjectHoverChanged(
        newId: "",
      ),
    );
  }

  Future<void> changeHover(String newId, String fileId) async {
    if (newId == (state as SubjectHoverChanged).newId) return;
    if (newId != "") {
      _isDragging = true;
    }
    emit(
      SubjectHoverChanged(
        newId: newId,
      ),
    );
  }
}
