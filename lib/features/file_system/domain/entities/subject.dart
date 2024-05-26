// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:learning_app/features/file_system/data/models/subject_model.dart';

import 'file.dart';

class Subject extends File {
  @override
  final String id;
  @override
  final String name;
  @override
  final DateTime dateCreated;
  @override
  final DateTime lastChanged;
  final int icon;
  final bool streakRelevant;
  final bool disabled;
  const Subject({
    required this.id,
    required this.name,
    required this.dateCreated,
    required this.lastChanged,
    required this.icon,
    required this.streakRelevant,
    required this.disabled,
  }) : super(
            id: id,
            name: name,
            dateCreated: dateCreated,
            lastChanged: lastChanged);

  Subject copyWith({
    String? id,
    String? name,
    DateTime? dateCreated,
    DateTime? lastChanged,
    int? icon,
    bool? streakRelevant,
    bool? disabled,
  }) {
    return Subject(
      id: id ?? this.id,
      name: name ?? this.name,
      dateCreated: dateCreated ?? this.dateCreated,
      lastChanged: lastChanged ?? this.lastChanged,
      icon: icon ?? this.icon,
      streakRelevant: streakRelevant ?? this.streakRelevant,
      disabled: disabled ?? this.disabled,
    );
  }

  @override
  String toString() {
    return 'Subject(id: $id, name: $name, dateCreated: $dateCreated, lastChanged: $lastChanged, icon: $icon, streakRelevant: $streakRelevant, disabled: $disabled)';
  }

  @override
  SubjectModel toModel() {
    return SubjectModel(
        id: id,
        name: name,
        dateCreated: dateCreated,
        lastChanged: lastChanged,
        icon: icon,
        streakRelevant: streakRelevant,
        disabled: disabled);
  }

  @override
  List<Object> get props =>
      [id, name, dateCreated, lastChanged, icon, streakRelevant, disabled];
}
