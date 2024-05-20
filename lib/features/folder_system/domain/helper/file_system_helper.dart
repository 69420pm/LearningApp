import 'package:fpdart/fpdart.dart';
import 'package:learning_app/core/errors/exceptions/exceptions.dart';
import 'package:learning_app/core/errors/failures/failure.dart';
import 'package:learning_app/features/folder_system/data/datasources/file_system_local_data_source.dart';
import 'package:learning_app/features/folder_system/domain/entities/card.dart';
import 'package:learning_app/features/folder_system/domain/entities/class_test.dart';
import 'package:learning_app/features/folder_system/domain/entities/file.dart';
import 'package:learning_app/features/folder_system/domain/entities/folder.dart';
import 'package:learning_app/features/folder_system/domain/entities/subject.dart';

enum FileType { card, folder, subject, classTest }

abstract class FileSystemHelper {
  static Either<Failure, FileType> getTypeFromId(
    String id,
    FileSystemLocalDataSource lds,
  ) {
    if (lds.cardKeys.contains(id)) {
      return right(FileType.card);
    } else if (lds.folderKeys.contains(id)) {
      return right(FileType.folder);
    } else if (lds.subjectKeys.contains(id)) {
      return right(FileType.subject);
    } else if (lds.classTestKeys.contains(id)) {
      return right(FileType.classTest);
    }
    return left(FileNotFoundFailure(errorMessage: "type for ${id} not found"));
  }

  static Either<Failure, FileType> getTypeFromFile(
    File file,
    FileSystemLocalDataSource lds,
  ) {
    if (file is Card) {
      return right(FileType.card);
    } else if (file is Folder) {
      return right(FileType.folder);
    } else if (file is Subject) {
      return right(FileType.subject);
    } else if (file is ClassTest) {
      return right(FileType.classTest);
    }
    return left(
      FileNotFoundFailure(
        errorMessage: "type for ${file.toString()} not found",
      ),
    );
  }

  static Future<Either<Failure, String>> getParentId(
    String id,
    FileSystemLocalDataSource lds,
  ) async {
    if (lds.subjectKeys.contains(id)) {
      return right("/");
    }
    List<String> potentialParentIds = lds.subjectKeys + lds.folderKeys;
    //! recursion
    return _getParentIdRec(potentialParentIds, lds, id);
    for (String parentId in potentialParentIds) {
      try {
        final valueIds = await lds.getRelation(parentId);
        for (var valueId in valueIds) {
          if (id == valueId) {
            return right(parentId);
          } else if (lds.folderKeys.contains(valueId)) {
            potentialParentIds.add(valueId);
          }
        }
      } on FileNotFoundException {
        return left(
          FileNotFoundFailure(
            errorMessage: "relation not saved for $parentId",
          ),
        );
      }
    }
    return left(
      ParentIdNotFoundFailure(errorMessage: "parent id for $id not found"),
    );
  }

  static Future<Either<Failure, String>> _getParentIdRec(
      List<String> potentialParentIds,
      FileSystemLocalDataSource lds,
      String id) async {
    List<String> newPotentialParentIds = [];
    for (final parentId in potentialParentIds) {
      try {
        final valueIds = await lds.getRelation(parentId);
        for (var valueId in valueIds) {
          if (id == valueId) {
            return right(parentId);
          } else if (lds.folderKeys.contains(valueId)) {
            newPotentialParentIds.add(valueId);
          }
        }
      } on FileNotFoundException {
        return left(
          FileNotFoundFailure(
            errorMessage: "relation not saved for $parentId",
          ),
        );
      }
    }
    return _getParentIdRec(newPotentialParentIds, lds, id);
  }
}
