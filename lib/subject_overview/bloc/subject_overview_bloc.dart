import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cards_api/cards_api.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/cupertino.dart';
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
    on<EditSubjectUpdateFoldersCards>(
      (event, emit) => _updateState(event, emit),
    );
    on<EditSubjectAddFolder>((event, emit) async {
      await _saveFolder(event, emit);
    });
    on<EditSubjectGetChildrenById>(
      (event, emit) => _getChildren(event, emit),
    );
    on<EditSubjectAddCard>(
      (event, emit) async => _saveCard(event, emit),
    );
  }

  final CardsRepository _cardsRepository;

  void _updateState(event, emit) {
    emit(EditSubjectFoldersCardsFetchingSuccess());
  }

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

  // Future<void> _cardSubscriptionRequested(
  //   EditSubjectCardSubscriptionRequested event,
  //   Emitter<EditSubjectState> emit,
  // ) async {
  //   emit(EditSubjectFolderFetchingLoading());
  //   await emit.forEach<List<Card>>(_cardsRepository.getCards(),
  //       onData: (cards) {
  //         final subjectId = event.currentSubjectId;
  //         final cardsToSendFurther = List<Card>.empty(growable: true);
  //         for (final element in cards) {
  //           if (element.parentId == subjectId) {
  //             cardsToSendFurther.add(element);
  //           }
  //         }
  //         return EditSubjectCardFetchingSuccess(cards: cardsToSendFurther);
  //       },
  //       onError: (_, __) => EditSubjectFolderFetchingFailure(
  //           errorMessage: 'fetching cards from hive failed'));
  // }

  // Future<void> _folderSubscriptionRequested(
  //   EditSubjectFolderSubscriptionRequested event,
  //   Emitter<EditSubjectState> emit,
  // ) async {
  //   emit(EditSubjectFolderFetchingLoading());
  //   await emit.forEach(_cardsRepository.getSubjects(), onData: (subjects) {
  //     final subjectId = event.currentSubjectId;
  //     final subjectsToSendFurther = List<Subject>.empty(growable: true);
  //     for (final element in subjects) {
  //       // if(element.parentId == subjectId){
  //       //   subjectsToSendFurther.add(element);
  //       // }
  //     }
  //     return EditSubjectFolderFetchingSuccess(subjects: subjects);
  //   });
  // }

  Future<void> _getChildren(
    EditSubjectGetChildrenById event,
    Emitter<EditSubjectState> emit,
  ) async {
    emit(EditSubjectLoading());
    await emit.forEach(
      _cardsRepository.getChildrenById(event.id),
      onData: (data) {
        print("stream update");
        // print(data);
        return EditSubjectRetrieveChildren(childrenStream: data);
      },
      onError: (error, stackTrace) => EditSubjectFailure(errorMessage: "backend broken"),
    );
  }

  Future<void> _saveFolder(
    EditSubjectAddFolder event,
    Emitter<EditSubjectState> emit,
  ) async {
    emit(EditSubjectLoading());
    final newFolder = Folder(
        id: Uuid().v4(),
        name: event.name + "fdsf",
        dateCreated: DateTime.now().toIso8601String(),
        parentId: event.parentId);
    await _cardsRepository.saveFolder(newFolder);
    emit(EditSubjectSuccess());
  }

  _saveCard(EditSubjectAddCard event, Emitter<EditSubjectState> emit) async {
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
