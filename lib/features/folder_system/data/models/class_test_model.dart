import 'dart:convert';

import 'package:learning_app/features/folder_system/domain/entities/class_test.dart';

class ClassTestModel extends ClassTest {
  ClassTestModel(
      {required super.id,
      required super.name,
      required super.dateCreated,
      required super.lastChanged,
      required super.date,
      required super.folderIds});
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'dateCreated': dateCreated.millisecondsSinceEpoch,
      'lastChanged': lastChanged.millisecondsSinceEpoch,
      'date': date,
      'folderIds': folderIds,
    };
  }

  factory ClassTestModel.fromMap(Map<String, dynamic> map) {
    return ClassTestModel(
        id: map['id'] as String,
        name: map['name'] as String,
        dateCreated:
            DateTime.fromMillisecondsSinceEpoch(map['dateCreated'] as int),
        lastChanged:
            DateTime.fromMillisecondsSinceEpoch(map['lastChanged'] as int),
        date: DateTime.fromMillisecondsSinceEpoch(map['date'] as int),
        folderIds: map['folderIds'] as List<String>);
  }

  String toJson() => json.encode(toMap());

  factory ClassTestModel.fromJson(String source) =>
      ClassTestModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
