// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fpdart/src/either.dart';

import 'package:learning_app/core/errors/failures/failure.dart';
import 'package:learning_app/core/id/uid.dart';
import 'package:learning_app/core/usecases/usecase.dart';
import 'package:learning_app/features/folder_system/domain/entities/card.dart';
import 'package:learning_app/features/folder_system/domain/entities/folder.dart';
import 'package:learning_app/features/folder_system/domain/repositories/file_system_repository.dart';

class CreateCard extends UseCase<void, CreateCardParams> {
  FileSystemRepository repository;
  CreateCard({
    required this.repository,
  });
  @override
  Future<Either<Failure, void>> call(CreateCardParams params) {
    return repository.saveFile(
      Card(
        id: Uid.uid(),
        name: "420card",
        dateCreated: DateTime.now(),
        lastChanged: DateTime.now(),
        recallScore: 0,
        dateToReview: DateTime.now(),
        typeAnswer: false,
        askCardsBothSided: false,
      ),
      params.parentId,
    );
  }
}

class CreateCardParams {
  String parentId;
  CreateCardParams({required this.parentId});
}
