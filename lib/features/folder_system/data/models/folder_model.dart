import 'dart:convert';

import 'package:learning_app/features/folder_system/domain/entities/folder.dart';

class FolderModel extends Folder {
  FolderModel(
      {required super.id,
      required super.name,
      required super.dateCreated,
      required super.lastChanged});
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'dateCreated': dateCreated.millisecondsSinceEpoch,
      'lastChanged': lastChanged.millisecondsSinceEpoch,
    };
  }

  factory FolderModel.fromMap(Map<String, dynamic> map) {
    return FolderModel(
      id: map['id'] as String,
      name: map['name'] as String,
      dateCreated:
          DateTime.fromMillisecondsSinceEpoch(map['dateCreated'] as int),
      lastChanged:
          DateTime.fromMillisecondsSinceEpoch(map['lastChanged'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory FolderModel.fromJson(String source) =>
      FolderModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
