import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cards_api/cards_api.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/cupertino.dart';
import 'package:learning_app/subject_overview/view/card_list_tile.dart';
import 'package:learning_app/subject_overview/view/folder_list_tile.dart';
import 'package:uuid/uuid.dart';

part 'subject_overview_event.dart';
part 'subject_overview_state.dart';

class EditSubjectBloc extends Bloc<EditSubjectEvent, EditSubjectState> {
  EditSubjectBloc(this._cardsRepository) : super(EditSubjectInitial()) {
    on<EditSubjectSaveSubject>(_saveSubject);
    // on<EditSubjectCardSubscriptionRequested>((event, emit) async {
    //   await _cardSubscriptionRequested(event, emit);
    // });
    // on<EditSubjectFolderSubscriptionRequested>((event, emit) async {
    //   await _folderSubscriptionRequested(event, emit);
    // });
    on<EditSubjectAddFolder>((event, emit) async {
      await _saveFolder(event, emit);
    });
    on<EditSubjectGetChildrenById>(
      _getChildren,
    );
    on<EditSubjectAddCard>(
      (event, emit) async => _saveCard(event, emit),
    );

    on<EditSubjectCloseStreamById>(
      _closeStream,
    );
  }

  final CardsRepository _cardsRepository;

  Future<void> _saveSubject(
    EditSubjectSaveSubject event,
    Emitter<EditSubjectState> emit,
  ) async {
    emit(EditSubjectLoading());
    try {
      await _cardsRepository.saveSubject(event.newSubject);
      emit(EditSubjectSuccess());
    } catch (e) {
      EditSubjectFailure(
        errorMessage: 'Subject saving failed, while communicating with hive',
      );
    }
  }



  Future<void> _getChildren(
    EditSubjectGetChildrenById event,
    Emitter<EditSubjectState> emit,
  ) async {
    emit(EditSubjectLoading());
    await emit.forEach(
      _cardsRepository.getChildrenById(event.id),
      onData: (data) {
        var childListTiles = <String, Widget>{};
        for (final element in data) {
          if (element is Folder) {
            childListTiles[element.id] = FolderListTile(
              folder: element,
              cardsRepository: _cardsRepository,
            );
          } else if (element is Card) {
            childListTiles[element.id] = CardListTile(card: element);
          }
        }
        return EditSubjectRetrieveChildren(childrenStream: childListTiles);
      },
      onError: (error, stackTrace) =>
          EditSubjectFailure(errorMessage: "backend broken"),
    );
  }

  Future<void> _saveFolder(
    EditSubjectAddFolder event,
    Emitter<EditSubjectState> emit,
  ) async {
    emit(EditSubjectLoading());
    final newFolder = Folder(
        id: Uuid().v4(),
        name: event.name,
        dateCreated: DateTime.now().toIso8601String(),
        parentId: event.parentId);
    await _cardsRepository.saveFolder(newFolder);
    emit(EditSubjectSuccess());
  }

  Future<void> _saveCard(
      EditSubjectAddCard event, Emitter<EditSubjectState> emit) async {
    emit(EditSubjectLoading());
    final newCard = Card(
        id: Uuid().v4(),
        front: event.front,
        back: event.back,
        dateCreated: DateTime.now().toIso8601String(),
        parentId: event.parentId,
        askCardsInverted: true,
        typeAnswer: true,
        dateToReview: "");
    await _cardsRepository.saveCard(newCard);
    emit(EditSubjectSuccess());
  }

  void _closeStream(
      EditSubjectCloseStreamById event, Emitter<EditSubjectState> emit) {
    _cardsRepository.closeStreamById(event.id);
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
}
