// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:learning_app/core/streams/stream_events.dart';
import 'package:learning_app/features/folder_system/domain/entities/file.dart';

import 'package:learning_app/features/folder_system/domain/usecases/watch_children_file_system.dart';
import 'package:learning_app/features/folder_system/domain/usecases/watch_file.dart';

part 'file_event.dart';
part 'file_state.dart';

class FileBloc extends Bloc<FileEvent, FileState> {
  final String subjectId;
  WatchChildrenFileSystem watchChildren;
  WatchFile watchFile;
  FileBloc({
    required this.subjectId,
    required this.watchChildren,
    required this.watchFile,
  }) : super(FileLoading()) {
    on<FileEvent>((event, emit) {});
    on<FileWatchChildrenIds>(watchChildrenIds);
  }

  Map<String, Stream<StreamEvent<File?>>> subscribedStreams = {};

  Future<FutureOr<void>> watchChildrenIds(
    FileWatchChildrenIds event,
    Emitter<FileState> emit,
  ) async {
    emit(FileLoading());
    final streamEither = await watchChildren(event.parentId);
    await streamEither.match((failure) async {
      emit(FileError(errorMessage: failure.errorMessage));
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
                      emit(FileError(errorMessage: failure.errorMessage)),
                  (stream) => subscribedStreams[childrenId] = stream,
                );
              }
            },
          );
          return FileSuccess(ids: List.from(data));
        },
        onError: (error, stackTrace) {
          return FileError(errorMessage: "stream returned error");
        },
      );
    });
  }
}
