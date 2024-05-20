// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:fpdart/src/either.dart';

import 'package:learning_app/core/errors/failures/failure.dart';
import 'package:learning_app/core/usecases/usecase.dart';
import 'package:learning_app/features/folder_system/domain/entities/file.dart';
import 'package:learning_app/features/folder_system/domain/repositories/file_system_repository.dart';

class SaveFile implements UseCase<void, SaveFileParams> {
  FileSystemRepository repository;
  SaveFile({
    required this.repository,
  });
  @override
  Future<Either<Failure, void>> call(SaveFileParams params) {
    return repository.saveFile(params.file, params.parentId);
  }
}

class SaveFileParams extends Equatable {
  final File file;
  final String parentId;

  SaveFileParams({required this.file, required this.parentId});

  @override
  List<Object> get props => [file, parentId];
}
