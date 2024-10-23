// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fpdart/src/either.dart';

import 'package:learning_app/core/errors/failures/failure.dart';
import 'package:learning_app/core/id/uid.dart';
import 'package:learning_app/core/usecases/usecase.dart';
import 'package:learning_app/features/file_system/domain/entities/folder.dart';
import 'package:learning_app/features/file_system/domain/repositories/file_system_repository.dart';

class CreateFolder extends UseCase<void, CreateFolderParams> {
  FileSystemRepository repository;
  CreateFolder({
    required this.repository,
  });
  @override
  Future<Either<Failure, void>> call(CreateFolderParams params) {
    return repository.saveFile(
      Folder(
        id: Uid.uid(),
        name: params.name,
        dateCreated: DateTime.now(),
        lastChanged: DateTime.now(),
      ),
      params.parentId,
    );
  }
}

class CreateFolderParams {
  String name;
  String parentId;
  CreateFolderParams({
    required this.name,
    required this.parentId,
  });
}
