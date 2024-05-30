// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import 'package:learning_app/core/streams/stream_events.dart';
import 'package:learning_app/features/file_system/domain/entities/file.dart';
import 'package:learning_app/features/file_system/domain/usecases/move_file.dart';
import 'package:learning_app/features/file_system/domain/usecases/watch_children_file_system.dart';
import 'package:learning_app/features/file_system/domain/usecases/watch_file.dart';

part 'folder_event.dart';
part 'folder_state.dart';

class FolderBloc extends Bloc<FolderEvent, FolderState> {
  final String parentId;
  MoveFile moveFileUseCase;
  WatchChildrenFileSystem watchChildren;
  WatchFile watchFile;
  FolderBloc({
    required this.parentId,
    required this.moveFileUseCase,
    required this.watchChildren,
    required this.watchFile,
  }) : super(FolderLoading()) {
    on<FolderEvent>((event, emit) {});
    on<FolderWatchChildrenIds>(watchChildrenIds);
    on<FolderMoveFile>(moveFile);
  }

  Map<String, Stream<StreamEvent<File?>>> subscribedStreams = {};

  Future<FutureOr<void>> watchChildrenIds(
    FolderWatchChildrenIds event,
    Emitter<FolderState> emit,
  ) async {
    emit(FolderLoading());
    final streamEither = await watchChildren(event.parentId);
    await streamEither.match((failure) async {
      emit(FolderError(errorMessage: failure.errorMessage));
    }, (stream) async {
      await emit.forEach(
        stream,
        onData: (data) {
          data.forEach(
            (childrenId) async {
              if (!subscribedStreams.keys.contains(childrenId)) {
                final watchFileEither = await watchFile(childrenId);
                watchFileEither.match(
                  (failure) =>
                      emit(FolderError(errorMessage: failure.errorMessage)),
                  (stream) => subscribedStreams[childrenId] = stream,
                );
              }
            },
          );
          return FolderSuccess(ids: List.from(data));
        },
        onError: (error, stackTrace) {
          return FolderError(errorMessage: "stream returned error");
        },
      );
    });
  }

  Future<FutureOr<void>> moveFile(
      FolderMoveFile event, Emitter<FolderState> emit) async {
    final moveEither = await moveFileUseCase(
        MoveFileParams(fileId: event.fileId, newParentId: event.parentId));

    moveEither.match(
      (failure) => emit(FolderError(errorMessage: failure.errorMessage)),
      (stream) => null,
    );
  }
}
