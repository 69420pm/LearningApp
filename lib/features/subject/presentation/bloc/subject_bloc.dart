// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:learning_app/features/file_system/domain/usecases/create_card.dart';

import 'package:learning_app/features/file_system/domain/usecases/create_folder.dart';
import 'package:learning_app/features/file_system/domain/usecases/get_parent_ids.dart';
import 'package:learning_app/features/file_system/domain/usecases/move_file.dart';

part 'subject_event.dart';
part 'subject_state.dart';

class SubjectBloc extends Bloc<SubjectEvent, SubjectState> {
  CreateFolder createFolderUseCase;
  CreateCard cerateCardUseCase;
  MoveFiles moveFileUseCase;
  GetParentIds getParentIdsUseCase;

  final String subjectId;
  SubjectBloc(
      {required this.createFolderUseCase,
      required this.moveFileUseCase,
      required this.cerateCardUseCase,
      required this.getParentIdsUseCase,
      required this.subjectId})
      : super(SubjectInitial()) {
    on<SubjectCreateFolder>(createFolder);
    on<SubjectCreateCard>(createCard);
    on<SubjectMoveFiles>(moveFiles);
  }

  FutureOr<void> createFolder(
      SubjectCreateFolder event, Emitter<SubjectState> emit) {
    createFolderUseCase(
      CreateFolderParams(name: event.name, parentId: subjectId),
    );
  }

  FutureOr<void> createCard(
      SubjectCreateCard event, Emitter<SubjectState> emit) {
    cerateCardUseCase(CreateCardParams(
        parentId: subjectId, name: DateTime.now().toIso8601String()));
  }

  FutureOr<void> moveFiles(
      SubjectMoveFiles event, Emitter<SubjectState> emit) async {
    //to avoid circles in file paths, while moving files from one folder to another,
    //all files to move which have the new parent folder currently as child folder
    //don't get moved.

    final getParentIds = await getParentIdsUseCase(event.parentId);
    getParentIds.match(
      (l) => print(l.errorMessage),
      (r) {
        for (var parentId in r) {
          if (event.fileIds.contains(parentId)) {
            event.fileIds.remove(parentId);
          }
        }
      },
    );

    await moveFileUseCase(
        MoveFilesParams(fileIds: event.fileIds, newParentId: event.parentId));
  }
}
