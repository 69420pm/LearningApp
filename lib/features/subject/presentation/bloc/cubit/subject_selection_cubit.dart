import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'subject_selection_state.dart';

class SubjectSelectionCubit extends Cubit<SubjectSelectionState> {
  SubjectSelectionCubit()
      : super(
          SubjectSelectionSelectionChanged(
            selectedIds: [],
            previouslySelectedIds: [],
          ),
        );

  final List<String> _selectedIds = [];

  bool get inSelectionMode => _selectedIds.isNotEmpty;

  void selectListTile(String id) {
    final previouslySelectedIds = <String>[];
    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
      previouslySelectedIds.add(id);
    } else {
      _selectedIds.add(id);
    }

    emit(
      SubjectSelectionSelectionChanged(
        selectedIds: List.from(_selectedIds),
        previouslySelectedIds: List.from(previouslySelectedIds),
      ),
    );
  }

  void deselectListTile(String id) {
    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
      emit(
        SubjectSelectionSelectionChanged(
          selectedIds: List.from(_selectedIds),
          previouslySelectedIds: [id],
        ),
      );
    }
  }
}
