import 'dart:convert';

import 'package:learning_app_clone/features/folder_system/domain/entities/subject.dart';

class SubjectModel extends Subject {
  SubjectModel(
      {required super.id,
      required super.name,
      required super.dateCreated,
      required super.lastChanged,
      required super.icon,
      required super.streakRelevant,
      required super.disabled});
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'dateCreated': dateCreated.millisecondsSinceEpoch,
      'lastChanged': lastChanged.millisecondsSinceEpoch,
      'icon': icon,
      'streakRelevant': streakRelevant,
      'disabled': disabled,
    };
  }

  factory SubjectModel.fromMap(Map<String, dynamic> map) {
    return SubjectModel(
      id: map['id'] as String,
      name: map['name'] as String,
      dateCreated:
          DateTime.fromMillisecondsSinceEpoch(map['dateCreated'] as int),
      lastChanged:
          DateTime.fromMillisecondsSinceEpoch(map['lastChanged'] as int),
      icon: map['icon'] as int,
      streakRelevant: map['streakRelevant'] as bool,
      disabled: map['disabled'] as bool,
    );
  }

  String toJson() => json.encode(toMap());

  factory SubjectModel.fromJson(String source) =>
      SubjectModel.fromMap(json.decode(source) as Map<String, dynamic>);
}
