import 'package:bloc/bloc.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/add_edit_class_test/cubit/add_edit_class_test_cubit.dart';
import 'package:learning_app/card_backend/cards_api/models/card.dart';
import 'package:learning_app/card_backend/cards_api/models/class_test.dart';
import 'package:learning_app/card_backend/cards_api/models/folder.dart';
import 'package:learning_app/card_backend/cards_api/models/subject.dart';
import 'package:learning_app/card_backend/cards_repository.dart';
import 'package:learning_app/edit_subject/cubit/edit_subject_cubit.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

part 'relevant_folders_state.dart';

class RelevantFoldersCubit extends Cubit<RelevantFoldersState> {
  RelevantFoldersCubit(this._cardsRepository, this._subject, this._classTest)
      : super(RelevantFoldersInitial()) {
    final ids = _cardsRepository.getChildrenList(_subject.uid);

    for (final id in ids) {
      if (_classTest.folderIds.contains(id)) {
        _updateParentFolders(id, true);
      } else {
        _updateParentFolders(id, false);
      }
    }
    emit(RelevantFoldersUpdateCheckbox(files: Map.of(files)));
  }

  final Subject _subject;
  ClassTest _classTest;
  final CardsRepository _cardsRepository;

  Map<String, bool?> files = {};

  void changeCheckbox(String id, bool? value, BuildContext context) {
    files[id] = value;
    _updateParentFolders(id, value);
    _updateChildren(id, value);
    _saveClassTest(context);
    emit(RelevantFoldersUpdateCheckbox(files: Map.of(files)));
  }

  void _saveClassTest(BuildContext context) {
    final storeList = <String>[];
    files.forEach((key, value) {
      if (value == true && _cardsRepository.objectFromId(key) is Card) {
        storeList.add(key);
      }
    });
    _classTest = _classTest.copyWith(folderIds: storeList);
    context.read<AddEditClassTestCubit>().changeRelevantCards(storeList);
  }
  // void _saveSubject() {
  //   final storeList = <String>[];
  //   files.forEach((key, value) {
  //     if (value == true && _cardsRepository.objectFromId(key) is Card) {
  //       storeList.add(key);
  //     }
  //   });
  //   _classTest = _classTest.copyWith(folderIds: storeList);
  //   _cardsRepository.saveSubject(_subject);
  // }

  void _updateParentFolders(String id, bool? value) {
    files[id] = value;
    try {
      final parentId = _cardsRepository.getParentIdFromChildId(id);
      final parentPreviousValue = files[parentId];
      final parentChildrenIds =
          _cardsRepository.getChildrenDirectlyBelow(parentId);
      var allTrue = true;
      var allFalse = true;
      for (final childrenId in parentChildrenIds) {
        if (files[childrenId] == false) {
          allTrue = false;
        } else if (files[childrenId] == true) {
          allFalse = false;
        }
      }
      if (allTrue && parentPreviousValue != true) {
        return _updateParentFolders(parentId, true);
      } else if (allFalse && parentPreviousValue != false) {
        return _updateParentFolders(parentId, false);
      } else if (parentPreviousValue != null) {
        return _updateParentFolders(parentId, null);
      }
    } catch (e) {}
  }

  void _updateChildren(String id, bool? value) {
    files[id] = value;
    final childrenIds = _cardsRepository.getChildrenDirectlyBelow(id);
    if (value != null) {
      for (final childrenId in childrenIds) {
        if (files[childrenId] != value) {
          _updateChildren(childrenId, value);
        }
      }
    }
  }
}
