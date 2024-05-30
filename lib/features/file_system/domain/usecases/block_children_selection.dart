// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fpdart/src/either.dart';

import 'package:learning_app/core/errors/failures/failure.dart';
import 'package:learning_app/core/usecases/usecase.dart';
import 'package:learning_app/features/file_system/domain/repositories/file_system_repository.dart';

class GetRelations extends UseCase<List<String>, String> {
  FileSystemRepository repository;
  GetRelations({
    required this.repository,
  });
  @override
  Future<Either<Failure, List<String>>> call(String parentId) {
    return repository.getRelations(parentId);
  }
}
