// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:learning_app/core/errors/failures/failure.dart';
import 'package:learning_app/core/usecases/usecase.dart';
import 'package:learning_app/features/file_system/domain/repositories/file_system_repository.dart';

class MoveFiles implements UseCase<void, MoveFilesParams> {
  FileSystemRepository repository;
  MoveFiles({
    required this.repository,
  });
  @override
  Future<Either<Failure, void>> call(MoveFilesParams params) async {
    for (var id in params.fileIds) {
      final either = await repository.changeParentId(id, params.newParentId);
      if (either.isLeft()) {
        return either;
      }
    }
    return right(null);
    // final getEither = await repository.getFile(params.fileId);
    // return getEither.match((failure) => left(failure), (file) async {
    //   return (await repository.deleteFile(params.fileId))
    //       .match((failure) => left(failure), (r) {
    //     return repository.saveFile(file, params.newParentId);
    //   });
    // });
    // var delete = await repository.deleteFile(params.fileUID);

    // return repository.saveFile((getEither as Right).value, params.newParentId);
  }
}

class MoveFilesParams extends Equatable {
  final List<String> fileIds;
  final String newParentId;

  const MoveFilesParams({required this.fileIds, required this.newParentId});

  @override
  List<Object> get props => [fileIds, newParentId];
}
