import 'package:fpdart/fpdart.dart';
import 'package:learning_app/core/errors/failures/failure.dart';
import 'package:learning_app/core/streams/stream_events.dart';
import 'package:learning_app/features/file_system/domain/entities/file.dart';

abstract class FileSystemRepository {
  Future<Either<Failure, void>> saveFile(File file, String parentId);
  Future<Either<Failure, File>> getFile(String id);
  Future<Either<Failure, void>> deleteFile(String id);

  Future<Either<Failure, List<String>>> getRelations(String parentId);

  /// gets a list of children ids as input and tries to find the highest
  ///  parent(folder) id/s for which all children ids were given
  Future<Either<Failure, Map<String, List<String>>>> checkCompleteChildren(
      List<String> childrenIds);

  Future<Either<Failure, void>> changeParentId(
    String fileId,
    String newParentId,
  );

  Future<Either<Failure, Stream<List<File>>>> watchChildren(String parentId);
  Either<Failure, Stream<StreamEvent<File?>>> watchFile(String id);
  Future<Either<Failure, Stream<List<String>>>> watchChildrenIds(
    String parentId,
  );
}

class CheckCompleteChildrenReturns {
  final List<String> parentIds;
  final List<String> childrenToRemove;
  CheckCompleteChildrenReturns({
    required this.parentIds,
    required this.childrenToRemove,
  });
}
