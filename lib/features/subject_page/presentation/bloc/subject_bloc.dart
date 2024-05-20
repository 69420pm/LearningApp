// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:learning_app/features/folder_system/domain/usecases/create_card.dart';

import 'package:learning_app/features/folder_system/domain/usecases/create_folder.dart';

part 'subject_event.dart';
part 'subject_state.dart';

class SubjectBloc extends Bloc<SubjectEvent, SubjectState> {
  CreateFolder createFolderUseCase;
  CreateCard cerateCardUseCase;
  final String subjectId;
  SubjectBloc(
      {required this.createFolderUseCase,
      required this.cerateCardUseCase,
      required this.subjectId})
      : super(SubjectInitial()) {
    on<SubjectCreateFolder>(createFolder);
    on<SubjectCreateCard>(createCard);
  }

  FutureOr<void> createFolder(
      SubjectCreateFolder event, Emitter<SubjectState> emit) {
    createFolderUseCase(
      CreateFolderParams(name: event.name, parentId: subjectId),
    );
  }

  FutureOr<void> createCard(
      SubjectCreateCard event, Emitter<SubjectState> emit) {
    cerateCardUseCase(CreateCardParams(parentId: subjectId));
  }
}
