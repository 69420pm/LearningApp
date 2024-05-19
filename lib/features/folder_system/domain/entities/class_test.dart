import 'package:learning_app_clone/features/folder_system/data/models/class_test_model.dart';
import 'package:learning_app_clone/features/folder_system/domain/entities/file.dart';

class ClassTest extends File {
  final String id;
  final String name;
  final DateTime dateCreated;
  final DateTime lastChanged;
  final DateTime date;
  final List<String> folderIds;

  const ClassTest(
      {required this.id,
      required this.name,
      required this.dateCreated,
      required this.lastChanged,
      required this.date,
      required this.folderIds})
      : super(
            id: id,
            name: name,
            dateCreated: dateCreated,
            lastChanged: lastChanged);

  ClassTest copyWith({
    String? id,
    String? name,
    DateTime? dateCreated,
    DateTime? lastChanged,
    DateTime? date,
    List<String>? folderIds,
  }) {
    return ClassTest(
        id: id ?? this.id,
        name: name ?? this.name,
        dateCreated: dateCreated ?? this.dateCreated,
        lastChanged: lastChanged ?? this.lastChanged,
        date: date ?? this.date,
        folderIds: folderIds ?? this.folderIds);
  }

  @override
  String toString() {
    return 'ClassTest(id: $id, name: $name, dateCreated: $dateCreated, lastChanged: $lastChanged, date: $date, folderIds: $folderIds)';
  }

  @override
  List<Object> get props =>
      [id, name, dateCreated, lastChanged, date, folderIds];

  @override
  ClassTestModel toModel() {
    return ClassTestModel(
        id: id,
        name: name,
        dateCreated: dateCreated,
        lastChanged: lastChanged,
        date: date,
        folderIds: folderIds);
  }
}
