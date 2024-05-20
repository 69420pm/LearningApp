// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fpdart/src/either.dart';

import 'package:learning_app/core/errors/failures/failure.dart';
import 'package:learning_app/core/streams/stream_events.dart';
import 'package:learning_app/core/usecases/usecase.dart';
import 'package:learning_app/features/folder_system/domain/entities/file.dart';
import 'package:learning_app/features/folder_system/domain/repositories/file_system_repository.dart';
import 'package:rxdart/rxdart.dart';

class WatchFile implements UseCase<Stream<StreamEvent<File?>>, String> {
  FileSystemRepository repository;
  WatchFile({
    required this.repository,
  });
  @override
  Future<Either<Failure, Stream<StreamEvent<File?>>>> call(
      String params) async {
    final streamEither = repository.watchFile(params);
    switch (streamEither) {
      case Left(value: final failure):
        return left(failure);
      case Right(value: final stream):
        final fileEither = await repository.getFile(params);
        switch (fileEither) {
          case Left(value: final failure):
            return left(failure);
          case Right(value: final file):
            final newStream = BehaviorSubject<StreamEvent<File?>>();
            newStream
                .add(StreamEvent(id: file.id, value: file, deleted: false));
            stream.listen(
              (event) {
                if (event.value != null) {
                  newStream.add(event);
                }
              },
            );
            return right(newStream.stream);
        }
    }
  }
}
