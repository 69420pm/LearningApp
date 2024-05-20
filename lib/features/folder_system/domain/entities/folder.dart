// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:learning_app/features/folder_system/data/models/folder_model.dart';
import 'package:learning_app/features/folder_system/domain/entities/file.dart';
import 'package:learning_app/features/folder_system/domain/entities/fileSystem.dart';

class Folder extends File implements FileSystem {
  @override
  final String id;
  @override
  final String name;
  @override
  final DateTime dateCreated;
  @override
  final DateTime lastChanged;
  const Folder({
    required this.id,
    required this.name,
    required this.dateCreated,
    required this.lastChanged,
  }) : super(
            id: id,
            name: name,
            dateCreated: dateCreated,
            lastChanged: lastChanged);

  Folder copyWith({
    String? id,
    String? name,
    DateTime? dateCreated,
    DateTime? lastChanged,
  }) {
    return Folder(
      id: id ?? this.id,
      name: name ?? this.name,
      dateCreated: dateCreated ?? this.dateCreated,
      lastChanged: lastChanged ?? this.lastChanged,
    );
  }

  @override
  String toString() {
    return 'Folder(id: $id, name: $name, dateCreated: $dateCreated, lastChanged: $lastChanged)';
  }

  @override
  List<Object> get props => [id, name, dateCreated, lastChanged];

  @override
  FolderModel toModel() {
    return FolderModel(
        id: id, name: name, dateCreated: dateCreated, lastChanged: lastChanged);
  }
}
