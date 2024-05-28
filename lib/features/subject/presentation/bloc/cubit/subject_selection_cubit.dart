// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:learning_app/core/errors/failures/failure.dart';

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
  final Map<String, List<String>> _blockedIds = {};

  bool get inSelectionMode => _selectedIds.isNotEmpty;

  Future<void> selectListTile(String id) async {
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
    if (_selectedIds.contains(id)) {
      _selectedIds.remove(id);
      _blockedIds.remove(id);
      previouslySelectedIds.add(id);
    } else {
      _selectedIds.add(id);
      await _blockAndDeselectChildrenIds(id, previouslySelectedIds);
      // final childrenIdsToBlockEither = await blockChildrenSelection(id);
      // childrenIdsToBlockEither.match((failure) => null, (childrenIdsToBlock) {
      //   _blockedIds[id] = childrenIdsToBlock;
      // });
      // final potentialFolderIds =
      //     await potentiallySelectParentFolder(_selectedIds);
      // potentialFolderIds.match(
      //     (failure) =>
      //         emit(SubjectSelectionError(errorMessage: failure.errorMessage)),
      //     (checkCompleteChildReturns) {
      //   for (var childIdLists in checkCompleteChildReturns.values.toList()) {
      //     for (var childId in childIdLists) {
      //       _selectedIds.remove(childId);
      //       previouslySelectedIds.add(childId);
      //     }
      //   }
      //   for (var parentId in checkCompleteChildReturns.keys) {
      //     _selectedIds.add(parentId);
      //   }
      //   _blockedIds.addAll(checkCompleteChildReturns);
      // });
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
      _removeRec([id]);
      emit(
        SubjectSelectionSelectionChanged(
          selectedIds: List.from(_selectedIds),
          previouslySelectedIds: [id],
        ),
      );
    }
  }

  Future<Either<Failure, void>> _blockAndDeselectChildrenIds(
      String parentId, List<String> previouslySelectedIds) async {
    final childrenEither = await blockChildrenSelection(parentId);
    await childrenEither.match((l) async => left(l), (childrenIds) async {
      _blockedIds[parentId] = childrenIds;
      for (var childId in childrenIds) {
        _selectedIds.remove(childId);
        previouslySelectedIds.add(childId);
        await _blockAndDeselectChildrenIds(childId, previouslySelectedIds);
      }
    });
    return right(null);
  }

  void _removeRec(List<String> ids) {
    for (var id in ids) {
      if (!_blockedIds.containsKey(id) || _blockedIds[id] == null) {
        return;
      }
      _removeRec(_blockedIds[id]!);
      _blockedIds.remove(id);
    }
  }
}
