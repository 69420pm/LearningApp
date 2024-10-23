// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import 'package:learning_app/core/errors/failures/failure.dart';
import 'package:learning_app/features/file_system/domain/usecases/block_children_selection.dart';
import 'package:learning_app/features/file_system/domain/usecases/get_parent_ids.dart';
import 'package:learning_app/features/file_system/domain/usecases/get_parentid.dart';

part 'subject_selection_state.dart';

class SubjectSelectionCubit extends Cubit<SubjectSelectionState> {
  GetRelations getRelationUseCase;
  GetParentId getParentIdUseCase;

  SubjectSelectionCubit({
    required this.getRelationUseCase,
    required this.getParentIdUseCase,
  }) : super(
          const SubjectSelectionSelectionChanged(
            changedIds: [],
            selectedIds: [],
          ),
        );

  /// List of all currently selected ids,
  /// childrenIds of selected Ids are not included
  final List<String> _selectedIds = [];

  List<String> get selectedIds => _selectedIds;
  bool get inSelectionMode => _selectedIds.isNotEmpty;

  /// Automatically changes selection of item with [id].
  ///
  /// If [id] is already selected, it will be deselected.
  ///
  /// If [id] is not selected and no parent is selected, it will be selected.
  ///
  /// If [id] is not selected and parent is selected, it will be deselected and other children will be deselected.
  ///
  /// Only items with changed selection will be updated.
  void changeSelection(String id) async {
    // Saving previous selection
    final prevSelectedIds = [..._selectedIds];

    if (_selectedIds.contains(id)) {
      // id is selected (all childs should be deselected)
      _selectedIds.remove(id);
    } else {
      // id is not directly selected (could be selected if parent is selected)
      if (await _checkIfParentSelectedRec(id)) {
        // some nth-parent is selected => select all other children in all nth-parents and deselect parent
        await _deselectParentRec(id);
      } else {
        // no parent is not selected
        _selectedIds.add(id);
        //deselect every children
        await _deselectEveryChildRec(id);
      }
    }

    // List of all ids with changed selection
    var differences = [
      ...prevSelectedIds.where((item) => !_selectedIds.contains(item)),
      ..._selectedIds.where((item) => !prevSelectedIds.contains(item)),
    ];

    // updating state
    emit(
      SubjectSelectionSelectionChanged(
        changedIds: List.from(differences),
        selectedIds: List.from(_selectedIds),
      ),
    );
  }

  /// Deselects every child of [id]
  Future<void> _deselectEveryChildRec(String id) async {
    // needs to traverse hole tree to check for selected children, recursion ends if no child is found
    final childrenEither = await getRelationUseCase(id);
    await childrenEither.match((_) => null, (childIds) async {
      for (var childId in childIds) {
        _selectedIds.remove(childId);
        await _deselectEveryChildRec(childId);
      }
    });
  }

  /// Recursively selects all other ids and deselects parent
  Future<void> _deselectParentRec(String id) async {
    final parentIdEither = await getParentIdUseCase(id);
    await parentIdEither.match((_) => null, (parentId) async {
      // all other children are selected
      final childrenEither = await getRelationUseCase(parentId);
      childrenEither.match((_) => null, (childIds) {
        for (var childId in childIds) {
          if (childId != id) _selectedIds.add(childId);
        }
      });

      if (_selectedIds.contains(parentId)) {
        // parent is selected, any parents above should not be selected => recursion ends
        _selectedIds.remove(parentId);
      } else {
        // check if a parent higher is selected, recursion ends when selected parent is found
        await _deselectParentRec(parentId);
      }
    });
  }

  /// Checks if any parent of [id] is selected
  Future<bool> _checkIfParentSelectedRec(String id) async {
    final parentIdEither = await getParentIdUseCase(id);
    return await parentIdEither.match<FutureOr<bool>>((_) => false,
        (parentId) async {
      if (_selectedIds.contains(parentId)) return true;
      return await _checkIfParentSelectedRec(parentId);
    });
  }

  void deselectAll() {
    final prevSelectedIds = [..._selectedIds];
    _selectedIds.clear();
    emit(
      SubjectSelectionSelectionChanged(
        changedIds: prevSelectedIds,
        selectedIds: [],
      ),
    );
  }
}
