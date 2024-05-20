// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:learning_app/core/errors/failures/failure.dart';
import 'package:learning_app/core/usecases/usecase.dart';
import 'package:learning_app/features/folder_system/domain/entities/file.dart';
import 'package:learning_app/features/folder_system/domain/repositories/file_system_repository.dart';

class MoveFile implements UseCase<void, MoveFileParams> {
  FileSystemRepository repository;
  MoveFile({
    required this.repository,
  });
  @override
  Future<Either<Failure, void>> call(MoveFileParams params) async {
    var getEither = await repository.getFile(params.fileUID);

    var delete = await repository.deleteFile(params.fileUID);

    return repository.saveFile((getEither as Right).value, params.newParentId);
  }
}

class MoveFileParams extends Equatable {
  final String fileUID;
  final String newParentId;

  const MoveFileParams({required this.fileUID, required this.newParentId});

  @override
  List<Object> get props => [fileUID, newParentId];
}
