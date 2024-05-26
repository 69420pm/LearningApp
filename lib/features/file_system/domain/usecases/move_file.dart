// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:learning_app/core/errors/failures/failure.dart';
import 'package:learning_app/core/usecases/usecase.dart';
import 'package:learning_app/features/file_system/domain/repositories/file_system_repository.dart';

class MoveFile implements UseCase<void, MoveFileParams> {
  FileSystemRepository repository;
  MoveFile({
    required this.repository,
  });
  @override
  Future<Either<Failure, void>> call(MoveFileParams params) {
    return repository.changeParentId(params.fileId, params.newParentId);
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

class MoveFileParams extends Equatable {
  final String fileId;
  final String newParentId;

  const MoveFileParams({required this.fileId, required this.newParentId});

  @override
  List<Object> get props => [fileId, newParentId];
}
