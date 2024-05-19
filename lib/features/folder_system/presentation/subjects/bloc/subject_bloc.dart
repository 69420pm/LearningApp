// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:learning_app_clone/features/folder_system/domain/usecases/add_folder.dart';

import 'package:learning_app_clone/features/folder_system/domain/usecases/watch_children_file_system.dart';
import 'package:learning_app_clone/features/folder_system/domain/usecases/watch_file.dart';

part 'subject_event.dart';
part 'subject_state.dart';

class SubjectBloc extends Bloc<SubjectEvent, SubjectState> {
  final String subjectId;
  WatchChildrenFileSystem watchChildren;
  WatchFile watchFile;
  CreateFolder createFolderUseCase;
  SubjectBloc(
      {required this.subjectId,
      required this.watchChildren,
      required this.watchFile,
      required this.createFolderUseCase})
      : super(SubjectLoading()) {
    on<SubjectEvent>((event, emit) {});
    on<SubjectWatchChildrenIds>(watchChildrenIds);
    on<SubjectCreateFolder>(createFolder);
  }

  Future<FutureOr<void>> watchChildrenIds(
      SubjectWatchChildrenIds event, Emitter<SubjectState> emit) async {
    emit(SubjectLoading());
    final streamEither = await watchChildren(event.parentId);
    await streamEither.match((failure) async {
      emit(SubjectError(errorMessage: failure.errorMessage));
    }, (stream) async {
      await emit.forEach(
        stream,
        onData: (childrenIds) {
          return SubjectSuccess(ids: List.from(childrenIds));
        },
        onError: (error, stackTrace) {
          return SubjectError(errorMessage: "stream returned error");
        },
      );
    });
  }

  FutureOr<void> createFolder(
      SubjectCreateFolder event, Emitter<SubjectState> emit) {
    createFolderUseCase(
        CreateFolderParams(name: event.name, parentId: subjectId));
  }
}
