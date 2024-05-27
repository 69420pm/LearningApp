// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:learning_app/features/file_system/domain/usecases/block_children_selection.dart';
import 'package:learning_app/features/file_system/domain/usecases/potentially_select_parent_folder.dart';

part 'subject_selection_state.dart';

class SubjectSelectionCubit extends Cubit<SubjectSelectionState> {
  PotentiallySelectParentFolder potentiallySelectParentFolder;
  BlockChildrenSelection blockChildrenSelection;
  SubjectSelectionCubit({
    required this.potentiallySelectParentFolder,
    required this.blockChildrenSelection,
  }) : super(
          const SubjectSelectionSelectionChanged(
            selectedIds: [],
            previouslySelectedIds: [],
          ),
        );

  final List<String> _selectedIds = [];

  bool get inSelectionMode => _selectedIds.isNotEmpty;

  Future<void> selectListTile(String id) async {
    final previouslySelectedIds = <String>[];
    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
      previouslySelectedIds.add(id);
    } else {
      _selectedIds.add(id);
      final potentialFolderIds =
          await potentiallySelectParentFolder(_selectedIds);
      potentialFolderIds.match(
          (failure) =>
              emit(SubjectSelectionError(errorMessage: failure.errorMessage)),
          (checkCompleteChildReturns) {
        for (var childId in checkCompleteChildReturns.childrenToRemove) {
          _selectedIds.remove(childId);
          previouslySelectedIds.add(childId);
        }
        for (var parentId in checkCompleteChildReturns.parentIds) {
          _selectedIds.add(parentId);
        }
      });
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
