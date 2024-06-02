// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';

import 'package:learning_app/core/errors/failures/failure.dart';
import 'package:learning_app/features/file_system/domain/usecases/block_children_selection.dart';
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

  /// List of all currently selected ids, childrenIds
  /// of selected Ids are not included
  final List<String> _selectedIds = [];

  bool get inSelectionMode => _selectedIds.isNotEmpty;

  void changeSelection(String id) async {
    final oldSelectedIds = [..._selectedIds];
    if (_selectedIds.contains(id)) {
      //! id is selected (all childs should be deselected)
      _selectedIds.remove(id);
    } else {
      //! id is not directly selected (could be selected if parent is selected)
      if (await _checkIfParentSelectedRec(id)) {
        await _deselectParentRec(id);
      } else {
        _selectedIds.add(id);
        await _deselectEveryChildRec(id);
      }
    }

    var differences = [
      ...oldSelectedIds.where((item) => !_selectedIds.contains(item)),
      ..._selectedIds.where((item) => !oldSelectedIds.contains(item)),
    ];

    emit(
      SubjectSelectionSelectionChanged(
        changedIds: List.from(differences),
        selectedIds: List.from(_selectedIds),
      ),
    );
  }

  Future<void> _deselectEveryChildRec(String id) async {
    //! needs to traverse hole tree to check for selected children, recursion ends if no child is found
    final childrenEither = await getRelationUseCase(id);
    await childrenEither.match((_) => null, (childIds) async {
      for (var childId in childIds) {
        _selectedIds.remove(childId);
        await _deselectEveryChildRec(childId);
      }
    });
  }

  Future<void> _deselectParentRec(String id) async {
    final parentIdEither = await getParentIdUseCase(id);
    await parentIdEither.match((_) => null, (parentId) async {
      final childrenEither = await getRelationUseCase(parentId);
      childrenEither.match((_) => null, (childIds) {
        for (var childId in childIds) {
          if (childId != id) _selectedIds.add(childId);
        }
      });

      if (_selectedIds.contains(parentId)) {
        //! parent is selected, any parents above should not be selected => recursion ends
        _selectedIds.remove(parentId);
      } else {
        //! check if a parent higher is selected, recursion ends if no parent is found anymore (subjectId?!)
        await _deselectParentRec(parentId);
      }
    });
  }

  Future<bool> _checkIfParentSelectedRec(String id) async {
    final parentIdEither = await getParentIdUseCase(id);
    return await parentIdEither.match<FutureOr<bool>>((_) => false,
        (parentId) async {
      if (_selectedIds.contains(parentId)) return true;
      return await _checkIfParentSelectedRec(parentId);
    });
  }

  // Future<void> _checkIfAllChildrenSelected(String parentId) async {
  //   final childrenEither = await getRelationUseCase(parentId);
  //   await childrenEither.match((_) => null, (childIds) async {
  //     for (var childId in childIds) {
  //       if (!_selectedIds.contains(childId)) {
  //         return null;
  //       }
  //     }
  //     //all children are selected
  //     _selectedIds.add(parentId);
  //     for (var childId in childIds) {
  //       _selectedIds.remove(childId);
  //     }
  //     final parentEither = await getParentIdUseCase(parentId);

  //     await parentEither.match((_) => null, (parentParentId) async {
  //       await _checkIfAllChildrenSelected(parentParentId);
  //     });
  //   });
  // }
}
