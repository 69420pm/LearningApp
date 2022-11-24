import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:cards_repository/cards_repository.dart';
import 'package:flutter/cupertino.dart';

part 'subject_overview_event.dart';
part 'subject_overview_state.dart';

class EditSubjectBloc extends Bloc<EditSubjectEvent, EditSubjectState> {
  EditSubjectBloc(this._cardsRepository) : super(EditSubjectInitial()) {
    on<EditSubjectSaveSubject>(_saveSubject);
    on<EditSubjectCardSubscriptionRequested>((event, emit) async {
      await _cardSubscriptionRequested(event, emit);
    });
    on<EditSubjectFolderSubscriptionRequested>((event, emit) async {
      await _folderSubscriptionRequested(event, emit);
    });
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

  Future<void> _cardSubscriptionRequested(
    EditSubjectCardSubscriptionRequested event,
    Emitter<EditSubjectState> emit,
  ) async {
    emit(EditSubjectFolderFetchingLoading());
    await emit.forEach<List<Card>>(_cardsRepository.getCards(),
        onData: (cards) {
          final subjectId = event.currentSubjectId;
          final cardsToSendFurther = List<Card>.empty(growable: true);
          for (final element in cards) {
            if (element.parentId == subjectId) {
              cardsToSendFurther.add(element);
            }
          }
          return EditSubjectCardFetchingSuccess(cards: cardsToSendFurther);
        },
        onError: (_, __) => EditSubjectFolderFetchingFailure(
            errorMessage: 'fetching cards from hive failed'));
  }

  Future<void> _folderSubscriptionRequested(
    EditSubjectFolderSubscriptionRequested event,
    Emitter<EditSubjectState> emit,
  ) async {
    emit(EditSubjectFolderFetchingLoading());
    await emit.forEach(_cardsRepository.getSubjects(), onData: 
    (subjects) {
      final subjectId = event.currentSubjectId;
      final subjectsToSendFurther = List<Subject>.empty(growable: true);
      for(final element in subjects){
        // if(element.parentId == subjectId){
        //   subjectsToSendFurther.add(element);
        // }
      }
      return EditSubjectFolderFetchingSuccess(subjects: subjects);
    }
    );
  }
}
