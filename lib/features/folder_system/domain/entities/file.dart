// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:equatable/equatable.dart';

abstract class File extends Equatable {
  final String id;
  final String name;
  final DateTime dateCreated;
  final DateTime lastChanged;
  const File({
    required this.id,
    required this.name,
    required this.dateCreated,
    required this.lastChanged,
  });

  @override
  List<Object> get props => [id, name, dateCreated, lastChanged];
  @override
  String toString() {
    return 'File(id: $id, name: $name, dateCreated: $dateCreated, lastChanged: $lastChanged)';
  }

  File toModel();
}
