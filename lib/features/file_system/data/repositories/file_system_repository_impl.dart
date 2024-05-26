import 'dart:async';

import 'package:fpdart/src/either.dart';
import 'package:learning_app/core/errors/exceptions/exceptions.dart';
import 'package:learning_app/core/errors/failures/failure.dart';
import 'package:learning_app/core/streams/stream_events.dart';
import 'package:learning_app/features/file_system/data/datasources/file_system_local_data_source.dart';
import 'package:learning_app/features/file_system/data/models/card_model.dart';
import 'package:learning_app/features/file_system/data/models/class_test_model.dart';
import 'package:learning_app/features/file_system/data/models/folder_model.dart';
import 'package:learning_app/features/file_system/data/models/subject_model.dart';
import 'package:learning_app/features/file_system/domain/entities/file.dart';
import 'package:learning_app/features/file_system/domain/repositories/file_system_repository.dart';
import 'package:learning_app/features/file_system/domain/helper/file_system_helper.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class FileSystemRepositoryImpl implements FileSystemRepository {
  final FileSystemLocalDataSource lds;

  FileSystemRepositoryImpl({required this.lds});

  @override
  Future<Either<Failure, File>> getFile(String id) async {
    Future<Either<Failure, File>> get(
      Future<File> Function(String) saveFunction,
      String id,
    ) async {
      try {
        return right(await saveFunction(id));
      } on FileNotFoundException {
        return left(
          FileNotFoundFailure(
            errorMessage:
                "for get file: ${saveFunction.toString()} with id: $id was a file not found failure thrown",
          ),
        );
      }
    }

    final fileType = FileSystemHelper.getTypeFromId(id, lds);
    return fileType.match((error) {
      return left(error);
    }, (type) {
      switch (type) {
        case FileType.card:
          return get(lds.getCard, id);
        case FileType.folder:
          return get(lds.getFolder, id);
        case FileType.subject:
          return get(lds.getSubject, id);
        case FileType.classTest:
          return get(lds.getClassTest, id);
      }
    });
  }

  @override
  Future<Either<Failure, void>> deleteFile(String id) async {
    Future<Either<Failure, void>> delete(
      Future<void> Function(String) deleteFunction,
      String id,
    ) async {
      try {
        return right(await deleteFunction(id));
      } on FileNotFoundException {
        return left(
          FileNotFoundFailure(
            errorMessage:
                "for delete file: ${deleteFunction.toString()} with id: $id was a file not found failure thrown",
          ),
        );
      }
    }

    Future<Either<Failure, void>> deleteDirectly(
      String id,
      FileType type,
    ) async {
      switch (type) {
        case FileType.card:
          return delete(lds.deleteCard, id);
        case FileType.folder:
          return delete(lds.deleteFolder, id);
        case FileType.subject:
          return delete(lds.deleteSubject, id);
        case FileType.classTest:
          return delete(lds.deleteClassTest, id);
        default:
          return left(
            FileNotFoundFailure(
              errorMessage:
                  "for id: $id with fileType: $type is deletion to possible",
            ),
          );
      }
    }

    Future<Either<Failure, void>> deleteDependencies(
      String id,
      FileType type,
    ) async {
      final parentId = await FileSystemHelper.getParentId(id, lds);
      parentId.match((failure) => left(failure), (parentId) async {
        final valueIds = await lds.getRelation(parentId);
        valueIds.remove(id);
        await lds.saveRelation(parentId, valueIds);
      });
      if (type == FileType.folder) {
        final childrenIds = await lds.getRelation(id);
        for (var childrenId in childrenIds) {
          (await deleteFile(childrenId)).match(
            (failure) {
              return left(failure);
            },
            (r) => null,
          );
        }
      }
      return right(null);
    }

    final fileType = FileSystemHelper.getTypeFromId(id, lds);
    return fileType.match((error) {
      return Future.value(left(error));
    }, (type) async {
      try {
        (await deleteDirectly(id, type)).match(
          (failure) {
            return left(failure);
          },
          (r) => null,
        );
        return (await deleteDependencies(id, type)).match(
          (failure) => left(failure),
          (r) => right(null),
        );
      } on FileNotFoundException {
        return left(
          FileNotFoundFailure(errorMessage: "deletion failed for id: $id"),
        );
      }
    });
  }

  @override
  Future<Either<Failure, void>> saveFile(File file, String parentId) async {
    Future<Either<Failure, void>> save<T>(
      Future<void> Function(T) saveFunction,
      T file,
    ) async {
      try {
        return right(await saveFunction(file));
      } on FileNotFoundException {
        return left(
          FileNotFoundFailure(
            errorMessage:
                "for ${saveFunction.toString()} with parentId: $parentId and file: ${file.toString()} was a file not found failure thrown",
          ),
        );
      }
    }

    final fileTypeEither = FileSystemHelper.getTypeFromFile(file, lds);
    switch (fileTypeEither) {
      case Right(value: final fileType):
        switch (fileType) {
          case FileType.card:
            await save<CardModel>(
              lds.saveCard,
              file.toModel() as CardModel,
            );
            break;
          case FileType.folder:
            if (!lds.relationKeys.contains(file.id)) {
              await lds.saveRelation(file.id, <String>[]);
            }
            await save<FolderModel>(
              lds.saveFolder,
              file.toModel() as FolderModel,
            );
            break;
          case FileType.subject:
            await save<SubjectModel>(
              lds.saveSubject,
              file.toModel() as SubjectModel,
            );
            if (!lds.relationKeys.contains(file.id)) {
              await lds.saveRelation(file.id, <String>[]);
            }
            break;
          case FileType.classTest:
            await save<ClassTestModel>(
              lds.saveClassTest,
              file.toModel() as ClassTestModel,
            );
            break;
        }
        Future<void> saveRelation(
          Future<List<String>> Function(String) getFunction,
          Future<void> Function(String, List<String>) saveFunction,
          String id,
        ) async {
          try {
            final otherChildrenIds = await getFunction(parentId);
            if (!otherChildrenIds.contains(file.id)) {
              otherChildrenIds.add(file.id);
              await saveFunction(parentId, otherChildrenIds);
            }
          } on FileNotFoundException {
            await saveFunction(parentId, [file.id]);
          }
        }
        if (fileType == FileType.classTest) {
          saveRelation(
            lds.getClassTestRelation,
            lds.saveClassTestRelation,
            file.id,
          );
        } else {
          saveRelation(lds.getRelation, lds.saveRelation, file.id);
        }

      case Left(value: final l):
        return left(l);
    }

    return right(null);
  }

  @override
  Future<Either<Failure, Stream<List<File>>>> watchChildren(
    String parentId,
  ) async {
    final stream = StreamController<List<File>>();

    final childrenIds = await lds.getRelation(parentId);

    Map<String, File> files = {};
    for (String childId in childrenIds) {
      (await getFile(childId)).match(
        (failure) {
          return left(failure);
        },
        (file) {
          files[file.id] = file;
        },
      );
    }

    stream.add(files.values.toList());

    lds.watchRelation(parentId).listen((event) async {
      if (!event.deleted) {
        final fileIds = await lds.getRelation(parentId);
        for (var fileId in fileIds) {
          if (!files.keys.contains(fileId)) {
            switch (await getFile(fileId)) {
              case Left(value: final l):
                return Future.value(left(l));
              case Right(value: final r):
                files[r.id] = r;
            }
          }
          final newStreamEither = watchFile(fileId);

          (newStreamEither).match((failure) => left(failure),
              (fileStream) async {
            fileStream.listen((fileEvent) {
              if (fileEvent.deleted) {
                files.remove(fileEvent.id);
              } else if (fileEvent.value != null) {
                files[fileEvent.id] = fileEvent.value!;
              }
            });
          });
        }
        // doesn't get reached when updating
        stream.add(files.values.toList());
      }
    });
    return right(stream.stream);
  }

  @override
  Either<Failure, Stream<StreamEvent<File?>>> watchFile(
    String id,
  ) {
    Either<Failure, Stream<StreamEvent<T>>> watch<T>(
      Stream<StreamEvent<T>> Function(String) watchFunction,
      String id,
    ) {
      try {
        return right(watchFunction(id));
      } on FileNotFoundException {
        return left(
          FileNotFoundFailure(
            errorMessage:
                "for watching the file ${watchFunction.toString()} with id: $id was a file not found failure thrown",
          ),
        );
      }
    }

    final fileType = FileSystemHelper.getTypeFromId(id, lds);
    return fileType.match((error) {
      return left(error);
    }, (type) {
      switch (type) {
        case FileType.card:
          return watch(lds.watchCard, id);
        case FileType.folder:
          return watch(lds.watchFolder, id);
        case FileType.subject:
          return watch(lds.watchSubject, id);
        case FileType.classTest:
          return watch(lds.watchClassTest, id);
      }
    });
  }

  @override
  Future<Either<Failure, Stream<List<String>>>> watchChildrenIds(
    String parentId,
  ) async {
    final stream = BehaviorSubject<List<String>>();
    try {
      final startChildrenIds = await lds.getRelation(parentId);
      stream.add(startChildrenIds);
      lds.watchRelation(parentId).listen((event) {
        if (event.value != null) {
          stream.add(event.value!);
        }
      });
      return right(stream.stream);
    } on FileNotFoundException {
      return left(
        FileNotFoundFailure(
          errorMessage:
              "the watchRelation or getRelation for parentId: $parentId threw an error",
        ),
      );
    }
  }

  @override
  Future<Either<Failure, void>> changeParentId(
      String fileId, String newParentId) async {
    final parentIdEither = await FileSystemHelper.getParentId(fileId, lds);
    return parentIdEither.match((failure) => left(failure), (parentId) async {
      if (parentId == newParentId) return right(null);
      final oldValueIds = await lds.getRelation(parentId);
      // remove fileId from old relation
      for (String valueId in oldValueIds) {
        if (valueId == fileId) {
          oldValueIds.remove(fileId);
          await lds.saveRelation(parentId, oldValueIds);
          break;
        }
      }
      // add fileId to new [arentid
      final newValueIds = await lds.getRelation(newParentId);
      newValueIds.add(fileId);
      await lds.saveRelation(newParentId, newValueIds);
      return right(null);
    });
  }
}
