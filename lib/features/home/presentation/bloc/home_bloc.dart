import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:fpdart/fpdart.dart';
import 'package:learning_app_clone/core/streams/stream_events.dart';
import 'package:learning_app_clone/features/folder_system/domain/entities/file.dart';
import 'package:learning_app_clone/features/folder_system/domain/usecases/create_subject.dart';
import 'package:learning_app_clone/features/folder_system/domain/usecases/watch_children_file_system.dart';
import 'package:learning_app_clone/features/folder_system/domain/usecases/watch_file.dart';

part 'home_event.dart';
part 'home_state.dart';

class HomeBloc extends Bloc<HomeEvent, HomeState> {
  final WatchChildrenFileSystem watchChildrenFileSystem;
  final CreateSubject createSubject;
  final WatchFile watchFile;
  HomeBloc(
      {required this.watchChildrenFileSystem,
      required this.createSubject,
      required this.watchFile})
      : super(HomeLoading()) {
    on<HomeSubjectWatchChildrenIds>(watchChildrenIds);
    on<HomeSubjectAddSubject>(addSubject);
  }

  Map<String, Stream<StreamEvent<File?>>> subscribedStreams = {};

  Future<void> watchChildrenIds(event, emit) async {
    emit(HomeLoading());
    final streamEither = await watchChildrenFileSystem("/");
    switch (streamEither) {
      case (Right(value: final stream)):
        await emit.forEach<List<String>>(
          stream,
          onData: (data) {
            data.forEach(
              (element) async {
                if (!subscribedStreams.keys.contains(element)) {
                  await subscribeWatchFile(element);
                }
              },
            );
            return HomeSuccess(subjectIds: List.from(data));
          },
          // onError: (data) => HomeError(),
        );
      case (Left()):
        emit(HomeError());
    }
  }

  FutureOr<void> addSubject(
    HomeSubjectAddSubject event,
    Emitter<HomeState> emit,
  ) {
    createSubject(CreateSubjectParams(name: event.name, icon: 1));
  }

  Future<void> subscribeWatchFile(String subjectId) async {
    final watchFileEither = await watchFile(subjectId);
    switch (watchFileEither) {
      case Right(value: final stream):
        subscribedStreams[subjectId] = stream;
      case Left():
    }
  }
}
