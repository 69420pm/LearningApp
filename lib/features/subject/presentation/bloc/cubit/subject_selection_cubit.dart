// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:learning_app/core/errors/failures/failure.dart';

import 'package:learning_app/features/file_system/domain/usecases/block_children_selection.dart';

part 'subject_selection_state.dart';

class SubjectSelectionCubit extends Cubit<SubjectSelectionState> {
  GetRelations blockChildrenSelection;
  SubjectSelectionCubit({
    required this.blockChildrenSelection,
  }) : super(
          const SubjectSelectionSelectionChanged(
            selectedIds: [],
            previouslySelectedIds: [],
          ),
        );

  /// List of all currently selected ids, which get also rendered, childrenIds
  /// of a folder are not included
  final List<String> _selectedIds = [];

  /// List of all "selected" ids which doesn't get rendered and also shouldn't
  /// get interacted with, like the children of a selected folder
  final Map<String, List<String>> _blockedIds = {};

  bool get inSelectionMode => _selectedIds.isNotEmpty;

  Future<void> selectListTile(String id) async {
    if (_selectedIds.contains(id)) {
      deselectListTile(id);
    } else {
      // if the id is blocked return and do nothing
      bool? returnEmpty;
      _blockedIds.forEach((key, value) {
        if (value.contains(id)) {
          returnEmpty = true;
        }
      });
      if (returnEmpty != null) {
        return;
      }

      final previouslySelectedIds = <String>[];
      _selectedIds.add(id);
      await _blockAndDeselectChildrenIdsRec(id, previouslySelectedIds);
      emit(
        SubjectSelectionSelectionChanged(
          selectedIds: List.from(_selectedIds),
          previouslySelectedIds: List.from(previouslySelectedIds),
        ),
      );
    }
  }

  void deselectListTile(String id) {
    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
      _removeBlockingRec([id]);
      emit(
        SubjectSelectionSelectionChanged(
          selectedIds: List.from(_selectedIds),
          previouslySelectedIds: [id],
        ),
      );
    }
  }

  //! recursive method to block and deselect all children from a selected folder
  Future<Either<Failure, void>> _blockAndDeselectChildrenIdsRec(
      String parentId, List<String> previouslySelectedIds) async {
    final childrenEither = await blockChildrenSelection(parentId);
    await childrenEither.match((l) async => left(l), (childrenIds) async {
      _blockedIds[parentId] = childrenIds;
      for (var childId in childrenIds) {
        _selectedIds.remove(childId);
        previouslySelectedIds.add(childId);
        await _blockAndDeselectChildrenIdsRec(childId, previouslySelectedIds);
      }
    });
    return right(null);
  }

  //! recursive method to remove the blocking from a deselected folder and all
  //! its children
  void _removeBlockingRec(List<String> ids) {
    for (var id in ids) {
      if (!_blockedIds.containsKey(id) || _blockedIds[id] == null) {
        return;
      }
      _removeBlockingRec(_blockedIds[id]!);
      _blockedIds.remove(id);
    }
  }
}
