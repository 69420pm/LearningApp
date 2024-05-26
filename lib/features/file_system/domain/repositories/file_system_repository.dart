import 'package:fpdart/fpdart.dart';
import 'package:learning_app/core/errors/failures/failure.dart';
import 'package:learning_app/core/streams/stream_events.dart';
import 'package:learning_app/features/file_system/domain/entities/file.dart';

abstract class FileSystemRepository {
  Future<Either<Failure, void>> saveFile(File file, String parentId);
  Future<Either<Failure, File>> getFile(String id);
  Future<Either<Failure, void>> deleteFile(String id);

  Future<Either<Failure, void>> changeParentId(
      String fileId, String newParentId);

  Future<Either<Failure, Stream<List<File>>>> watchChildren(String parentId);
  Either<Failure, Stream<StreamEvent<File?>>> watchFile(String id);
  Future<Either<Failure, Stream<List<String>>>> watchChildrenIds(
    String parentId,
  );
}
