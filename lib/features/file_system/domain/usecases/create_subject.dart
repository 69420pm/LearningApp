// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:fpdart/src/either.dart';

import 'package:learning_app/core/errors/failures/failure.dart';
import 'package:learning_app/core/id/uid.dart';
import 'package:learning_app/core/usecases/usecase.dart';
import 'package:learning_app/features/file_system/domain/entities/subject.dart';
import 'package:learning_app/features/file_system/domain/repositories/file_system_repository.dart';

class CreateSubject implements UseCase<void, CreateSubjectParams> {
  FileSystemRepository repository;
  CreateSubject({
    required this.repository,
  });
  @override
  Future<Either<Failure, void>> call(params) {
    return repository.saveFile(
        Subject(
            id: Uid.uid(),
            name: params.name,
            dateCreated: DateTime.now(),
            lastChanged: DateTime.now(),
            icon: params.icon,
            streakRelevant: true,
            disabled: false),
        "/");
  }
}

class CreateSubjectParams {
  String name;
  int icon;
  CreateSubjectParams({
    required this.name,
    required this.icon,
  });
}
