import 'package:fpdart/src/either.dart';
import 'package:learning_app/core/errors/failures/failure.dart';
import 'package:learning_app/core/usecases/usecase.dart';
import 'package:learning_app/features/file_system/domain/repositories/file_system_repository.dart';

class PotentiallySelectParentFolder
    extends UseCase<Map<String, List<String>>, List<String>> {
  final FileSystemRepository repository;

  PotentiallySelectParentFolder({required this.repository});
  @override
  Future<Either<Failure, Map<String, List<String>>>> call(
      List<String> childrenIds) {
    return repository.checkCompleteChildren(childrenIds);
  }
}
