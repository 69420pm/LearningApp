import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cards_api/cards_api.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart' hide Card;
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:learning_app/app/helper/uid.dart';

part 'subject_event.dart';
part 'subject_state.dart';

class SubjectBloc extends Bloc<SubjectEvent, SubjectState> {
  SubjectBloc(this.cardsRepository) : super(SubjectInitial()) {
    on<SubjectSaveSubject>(_saveSubject);
    on<SubjectAddFolder>((event, emit) async {
      await _saveFolder(event, emit);
    });
    on<SubjectGetChildrenById>(
      _getChildren,
    );
    on<SubjectAddCard>(
      (event, emit) async => _saveCard(event, emit),
    );

    on<SubjectCloseStreamById>(
      _closeStream,
    );
    on<SubjectSetFileParent>(_setParent);
  }

  final CardsRepository cardsRepository;

  Future<void> _saveSubject(
    SubjectSaveSubject event,
    Emitter<SubjectState> emit,
  ) async {
    emit(SubjectLoading());
    try {
      await cardsRepository.saveSubject(event.newSubject);
      emit(SubjectSuccess());
    } catch (e) {
      SubjectFailure(
        errorMessage: 'Subject saving failed, while communicating with hive',
      );
    }
  }

  Future<void> _getChildren(
    SubjectGetChildrenById event,
    Emitter<SubjectState> emit,
  ) async {
    emit(SubjectLoading());
    // await cardsRepository.closeStreamById(event.id);

    // await emit.forEach(
    //   cardsRepository.getChildrenById(event.id),
    //   onData: (data) {
    //     final childListTiles = <String, Widget>{};
    //     final widgetsToRemove = <Removed>[];
    //     for (final element in data) {
    //       if (element is Folder) {
    //         childListTiles[element.id] = FolderListTileParent(
    //           folder: element,
    //           // cardsRepository: cardsRepository,
    //         );
    //       } else if (element is Card) {
    //         childListTiles[element.id] = CardListTile(
    //           card: element,
    //           isCardSelected: false,
    //           isInSelectMode: false,
    //         );
    //       } else if (element is Removed) {
    //         widgetsToRemove.add(element);
    //       }
    //     }

    //     // if (childListTiles.isNotEmpty || widgetsToRemove.isNotEmpty) {
    //     return SubjectRetrieveChildren(
    //       childrenStream: childListTiles,
    //       removedWidgets: widgetsToRemove,
    //     );
    //     // }
    //     // return EditSubjectSuccess();
    //   },
    //   onError: (error, stackTrace) =>
    //       SubjectFailure(errorMessage: 'backend broken'),
    // );
  }

  Future<void> _saveFolder(
    SubjectAddFolder event,
    Emitter<SubjectState> emit,
  ) async {
    emit(SubjectLoading());
    final newFolder = Folder(
      uid: event.folderId ?? Uid().uid(),
      name: event.name,
      dateCreated: DateTime.now(),
    );
    await cardsRepository.saveFolder(newFolder, event.parentId);
    emit(SubjectSuccess());
  }

  Future<void> _saveCard(
    SubjectAddCard event,
    Emitter<SubjectState> emit,
  ) async {
    emit(SubjectLoading());
    final newCard = Card(
      uid: Uid().uid(),
      // front: event.front,
      // back: event.back,
      dateCreated: DateTime.now(),
      recallScore: 0,
      // parentId: event.parentId,
      askCardsInverted: true,
      typeAnswer: true,
      dateToReview: DateTime.now(),
      name: '',
      // tags: const [],
    );
    await cardsRepository.saveCard(newCard, null, event.parentId);
    emit(SubjectSuccess());
  }

  void _closeStream(
    SubjectCloseStreamById event,
    Emitter<SubjectState> emit,
  ) {
    // cardsRepository.closeStreamById(event.id, deleteChildren: true);
  }

  // Future<void> _saveFolder(
  //   EditSubjectAddFolder event,
  //   Emitter<EditSubjectState> emit,
  // ) async {
  //   emit(EditSubjectLoading());
  //   final String parentId;
  //   if (event.parentFolder != null) {
  //     parentId = event.parentFolder!.id;
  //   } else if (event.parentSubject != null) {
  //     parentId = event.parentSubject!.id;
  //   } else {
  //     emit(EditSubjectFailure(errorMessage: "no parent was given"));
  //     return;
  //   }
  //   final newFolder = Folder(
  //       id: const Uuid().v4(),
  //       name: event.name,
  //       parentId: parentId,
  //       dateCreated: DateTime.now().toIso8601String(),
  //       childCards: List.empty(growable: true),
  //       childFolders: List.empty(growable: true));
  //   try {
  //     if (event.parentFolder != null) {
  //       event.parentFolder!.childFolders.add(newFolder);
  //     } else if (event.parentSubject != null) {
  //       event.parentSubject!.childFolders.add(newFolder);
  //     }
  //     await _cardsRepository.saveFolder(newFolder);
  //     emit(EditSubjectFoldersCardsFetchingSuccess());
  //   } catch (e) {
  //     emit(
  //       EditSubjectFailure(
  //           errorMessage:
  //               'Subject saving failed, while communicating with hive'),
  //     );
  //   }
  // }

  // Future<void> _saveCard(
  //     EditSubjectAddCard event,
  //   Emitter<EditSubjectState> emit,) async {
  //   emit(EditSubjectLoading());
  //   final String parentId;
  //   if (event.parentFolder != null) {
  //     parentId = event.parentFolder!.id;
  //   } else if (event.parentSubject != null) {
  //     parentId = event.parentSubject!.id;
  //   } else {
  //     emit(EditSubjectFailure(errorMessage: "no parent was given"));
  //     return;
  //   }
  //   final newCard = Card(
  //       id: const Uuid().v4(),
  //       front: event.front,
  //       back: event.back,
  //       dateCreated: DateTime.now().toIso8601String(),
  //       parentId: parentId,
  //       askCardsInverted: false,
  //       typeAnswer: true,
  //       dateToReview: DateTime.thursday.toString());
  //   try {
  //     if(event.parentFolder != null){
  //       event.parentFolder!.childCards.add(newCard);
  //     }else if(event.parentSubject != null){
  //       event.parentSubject!.childCards.add(newCard);
  //     }
  //     await _cardsRepository.saveCard(newCard);
  //     emit(EditSubjectFoldersCardsFetchingSuccess());
  //   } catch (e) {
  //     emit(
  //       EditSubjectFailure(
  //           errorMessage: 'Card saving failed, while communicating with hive'),
  //     );
  //   }
  // }

  Future<FutureOr<void>> _setParent(
    SubjectSetFileParent event,
    Emitter<SubjectState> emit,
  ) async {
    await cardsRepository.moveFiles([event.fileUID], event.parentId);
    emit(SubjectSuccess());
  }
}
