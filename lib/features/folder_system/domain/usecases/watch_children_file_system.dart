// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fpdart/src/either.dart';
import 'package:learning_app_clone/core/errors/failures/failure.dart';
import 'package:learning_app_clone/core/usecases/usecase.dart';
import 'package:learning_app_clone/features/folder_system/domain/repositories/file_system_repository.dart';

class WatchChildrenFileSystem
    implements UseCase<Stream<List<String>?>, String> {
  FileSystemRepository repository;
  WatchChildrenFileSystem({
    required this.repository,
  });

  @override
  Future<Either<Failure, Stream<List<String>>>> call(String params) async {
    return await repository.watchChildrenIds(params);
  }
}
