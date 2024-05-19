import 'package:fpdart/src/either.dart';
import 'package:learning_app_clone/core/errors/failures/failure.dart';
import 'package:learning_app_clone/core/usecases/usecase.dart';
import 'package:learning_app_clone/features/folder_system/domain/entities/file.dart';
import 'package:learning_app_clone/features/folder_system/domain/repositories/file_system_repository.dart';

class GetFile implements UseCase<File, String> {
  final FileSystemRepository repository;

  GetFile({required this.repository});

  @override
  Future<Either<Failure, File>> call(String id) {
    return repository.getFile(id);
  }
}
