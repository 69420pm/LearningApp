// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:hive/hive.dart';
import 'package:learning_app/core/errors/exceptions/exceptions.dart';
import 'package:learning_app/core/streams/stream_events.dart';
import 'package:learning_app/features/folder_system/data/models/card_model.dart';
import 'package:learning_app/features/folder_system/data/models/class_test_model.dart';
import 'package:learning_app/features/folder_system/data/models/folder_model.dart';
import 'package:learning_app/features/folder_system/data/models/subject_model.dart';

typedef Relation = List<String>;

abstract class FileSystemLocalDataSource {
  Future<CardModel> getCard(String id);
  Future<FolderModel> getFolder(String id);
  Future<SubjectModel> getSubject(String id);
  Future<ClassTestModel> getClassTest(String id);
  Future<Relation> getRelation(String parentId);
  Future<Relation> getClassTestRelation(String parentId);

  Future<void> saveCard(CardModel card);
  Future<void> saveFolder(FolderModel folder);
  Future<void> saveSubject(SubjectModel subjectModel);
  Future<void> saveClassTest(ClassTestModel classTest);
  Future<void> saveRelation(String parentId, Relation relationTable);
  Future<void> saveClassTestRelation(String parentId, Relation relationTable);

  Future<void> deleteCard(String id);
  Future<void> deleteFolder(String id);
  Future<void> deleteSubject(String id);
  Future<void> deleteClassTest(String id);
  Future<void> deleteRelation(String id);
  Future<void> deleteClassTestRelation(String id);

  Stream<StreamEvent<CardModel?>> watchCard(String id);
  Stream<StreamEvent<FolderModel?>> watchFolder(String id);
  Stream<StreamEvent<SubjectModel?>> watchSubject(String? id);
  Stream<StreamEvent<ClassTestModel?>> watchClassTest(String? id);
  Stream<StreamEvent<Relation?>> watchRelation(String id);
  Stream<StreamEvent<Relation?>> watchClassTestRelation(String id);

  List<String> get cardKeys;
  List<String> get folderKeys;
  List<String> get subjectKeys;
  List<String> get classTestKeys;
  List<String> get relationKeys;
  List<String> get classTestRelationKeys;
}

class FileSystemHive implements FileSystemLocalDataSource {
  final Box<String> cardBox;
  final Box<String> folderBox;
  final Box<String> subjectBox;
  final Box<String> classTestBox;
  final Box<Relation> relationBox;
  final Box<Relation> classTestRelationBox;

  @override
  List<String> get cardKeys {
    return cardBox.keys.map((e) => e.toString()).toList();
  }

  @override
  List<String> get folderKeys {
    return folderBox.keys.map((e) => e.toString()).toList();
  }

  @override
  List<String> get subjectKeys {
    return subjectBox.keys.map((e) => e.toString()).toList();
  }

  @override
  List<String> get classTestKeys {
    return classTestBox.keys.map((e) => e.toString()).toList();
  }

  @override
  List<String> get relationKeys {
    return relationBox.keys.map((e) => e.toString()).toList();
  }

  @override
  List<String> get classTestRelationKeys {
    return classTestRelationBox.keys.map((e) => e.toString()).toList();
  }

  FileSystemHive({
    required this.cardBox,
    required this.folderBox,
    required this.subjectBox,
    required this.classTestBox,
    required this.relationBox,
    required this.classTestRelationBox,
  });

  @override
  Future<CardModel> getCard(String id) {
    final card = cardBox.get(id);
    if (card == null) {
      throw FileNotFoundException();
    }
    return Future.value(CardModel.fromJson(card));
  }

  @override
  Future<ClassTestModel> getClassTest(String id) {
    final classTest = classTestBox.get(id);
    if (classTest == null) {
      throw FileNotFoundException();
    }
    return Future.value(ClassTestModel.fromJson(classTest));
  }

  @override
  Future<FolderModel> getFolder(String id) {
    final folder = folderBox.get(id);
    if (folder == null) {
      throw FileNotFoundException();
    }
    return Future.value(FolderModel.fromJson(folder));
  }

  @override
  Future<Relation> getRelation(String parentId) {
    final table = relationBox.get(parentId);
    if (table == null) {
      throw FileNotFoundException();
    }
    return Future.value(table);
  }

  @override
  Future<Relation> getClassTestRelation(String subjectId) {
    final table = classTestRelationBox.get(subjectId);
    if (table == null) {
      throw FileNotFoundException();
    }
    return Future.value(table);
  }

  @override
  Future<SubjectModel> getSubject(String id) {
    final subjectModel = subjectBox.get(id);
    if (subjectModel == null) {
      throw FileNotFoundException();
    }
    return Future.value(SubjectModel.fromJson(subjectModel));
  }

  @override
  Future<void> saveCard(CardModel card) {
    return cardBox.put(card.id, card.toJson());
  }

  @override
  Future<void> saveClassTest(ClassTestModel classTest) {
    return classTestBox.put(classTest.id, classTest.toJson());
  }

  @override
  Future<void> saveFolder(FolderModel folder) {
    return folderBox.put(folder.id, folder.toJson());
  }

  @override
  Future<void> saveRelation(String parentId, Relation relation) {
    return relationBox.put(parentId, relation);
  }

  @override
  Future<void> saveClassTestRelation(String subjectId, Relation relation) {
    return classTestRelationBox.put(subjectId, relation);
  }

  @override
  Future<void> saveSubject(SubjectModel subjectModel) {
    print(subjectModel.id);
    return subjectBox.put(subjectModel.id, subjectModel.toJson());
  }

  @override
  Stream<StreamEvent<CardModel?>> watchCard(String id) {
    try {
      final boxEvent = cardBox.watch(key: id);
      final streamEvent = boxEvent.map((event) => StreamEvent<CardModel?>(
          deleted: event.deleted,
          value: event.value != null ? CardModel.fromJson(event.value) : null,
          id: event.key));
      return streamEvent;
    } on HiveError {
      throw FileNotFoundException();
    }
  }

  @override
  Stream<StreamEvent<FolderModel?>> watchFolder(String id) {
    try {
      final boxEvent = folderBox.watch(key: id);
      final streamEvent = boxEvent.map((event) => StreamEvent<FolderModel>(
          deleted: event.deleted, value: event.value, id: event.key));
      return streamEvent;
    } on HiveError {
      throw FileNotFoundException();
    }
  }

  @override
  Stream<StreamEvent<SubjectModel?>> watchSubject(String? id) {
    try {
      final boxEvent = subjectBox.watch(key: id);
      final streamEvent = boxEvent.map((event) => StreamEvent<SubjectModel>(
          deleted: event.deleted, value: event.value, id: event.key));
      return streamEvent;
    } on HiveError {
      throw FileNotFoundException();
    }
  }

  @override
  Stream<StreamEvent<ClassTestModel?>> watchClassTest(String? id) {
    try {
      final boxEvent = classTestBox.watch(key: id);
      final streamEvent = boxEvent.map((event) => StreamEvent<ClassTestModel>(
          deleted: event.deleted, value: event.value, id: event.key));
      return streamEvent;
    } on HiveError {
      throw FileNotFoundException();
    }
  }

  @override
  Stream<StreamEvent<Relation?>> watchRelation(String id) {
    try {
      final boxEvent = relationBox.watch(key: id);
      final streamEvent = boxEvent.map((event) => StreamEvent<Relation>(
          deleted: event.deleted, value: event.value, id: event.key));
      return streamEvent;
    } on HiveError {
      throw FileNotFoundException();
    }
  }

  @override
  Stream<StreamEvent<Relation?>> watchClassTestRelation(String id) {
    try {
      final boxEvent = classTestRelationBox.watch(key: id);
      final streamEvent = boxEvent.map((event) => StreamEvent<Relation>(
          deleted: event.deleted, value: event.value, id: event.key));
      return streamEvent;
    } on HiveError {
      throw FileNotFoundException();
    }
  }

  @override
  Future<void> deleteCard(String id) {
    if (!cardBox.containsKey(id)) {
      throw FileNotFoundException();
    }
    return cardBox.delete(id);
  }

  @override
  Future<void> deleteClassTest(String id) {
    if (!cardBox.containsKey(id)) {
      throw FileNotFoundException();
    }
    return cardBox.delete(id);
  }

  @override
  Future<void> deleteFolder(String id) {
    if (!folderBox.containsKey(id)) {
      throw FileNotFoundException();
    }
    return folderBox.delete(id);
  }

  @override
  Future<void> deleteRelation(String id) {
    if (!relationBox.containsKey(id)) {
      throw FileNotFoundException();
    }
    return relationBox.delete(id);
  }

  @override
  Future<void> deleteClassTestRelation(String id) {
    if (!classTestRelationBox.containsKey(id)) {
      throw FileNotFoundException();
    }
    return classTestRelationBox.delete(id);
  }

  @override
  Future<void> deleteSubject(String id) {
    if (!subjectBox.containsKey(id)) {
      throw FileNotFoundException();
    }
    return subjectBox.delete(id);
  }
}
